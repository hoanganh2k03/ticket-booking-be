import pandas as pd
import joblib
import os
from django.conf import settings
from django.core.management.base import BaseCommand
from django.db.models import Sum, Count, Avg
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error

# Import Models
from apps.events.models import Match
from apps.tickets.models import SectionPrice
from apps.orders.models import OrderDetail

class Command(BaseCommand):
    help = 'Huấn luyện mô hình dự báo nhu cầu đặt vé'

    def handle(self, *args, **kwargs):
        self.stdout.write(self.style.WARNING('1. Đang trích xuất dữ liệu từ Database...'))
        
        # --- GIAI ĐOẠN 1: LẤY DỮ LIỆU (ETL) ---
        data = []
        matches = Match.objects.all()

        for match in matches:
            # 1. Lấy các đặc trưng (Features - Input)
            # Ngày trong tuần (0=Thứ 2, 6=CN)
            day_of_week = match.match_time.weekday()
            # Giờ thi đấu
            hour = match.match_time.hour
            # Giá vé trung bình của trận này
            avg_price = SectionPrice.objects.filter(match=match).aggregate(Avg('price'))['price__avg']
            
            if avg_price is None:
                continue # Bỏ qua nếu trận lỗi không có giá

            # 2. Lấy kết quả thực tế (Label - Output)
            # Đếm tổng số vé đã bán ra cho trận này
            # Logic: OrderDetail -> Pricing -> Match
            total_sold = OrderDetail.objects.filter(pricing__match=match).count()

            data.append({
                'day_of_week': day_of_week, # Feature 1
                'hour': hour,               # Feature 2
                'avg_price': float(avg_price), # Feature 3
                'total_sold': total_sold    # Target
            })

        # Chuyển sang DataFrame của Pandas
        df = pd.DataFrame(data)
        self.stdout.write(f"   -> Đã thu thập được {len(df)} mẫu dữ liệu huấn luyện.")

        if len(df) < 10:
            self.stdout.write(self.style.ERROR("Dữ liệu quá ít để train! Hãy chạy seed_data trước."))
            return

        # --- GIAI ĐOẠN 2: HUẤN LUYỆN (TRAINING) ---
        self.stdout.write(self.style.WARNING('2. Đang huấn luyện mô hình AI...'))

        # X là đầu vào (Các yếu tố ảnh hưởng)
        X = df[['day_of_week', 'hour', 'avg_price']]
        # y là đầu ra (Số lượng vé dự báo)
        y = df['total_sold']

        # Chia tập train/test (80% để học, 20% để thi thử)
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # Chọn thuật toán: Linear Regression (Hồi quy tuyến tính)
        # Bạn có thể đổi thành RandomForestRegressor() nếu muốn xịn hơn
        model = LinearRegression()
        model.fit(X_train, y_train)

        # --- GIAI ĐOẠN 3: ĐÁNH GIÁ VÀ LƯU ---
        # Thử dự báo trên tập Test
        predictions = model.predict(X_test)
        mae = mean_absolute_error(y_test, predictions)
        
        self.stdout.write(f"   -> Sai số trung bình (MAE): +/- {mae:.2f} vé")
        self.stdout.write(f"   -> Hệ số góc (Weights): {model.coef_}")

        # Lưu model ra file .pkl
        save_path = os.path.join(settings.BASE_DIR, 'ml_models')
        if not os.path.exists(save_path):
            os.makedirs(save_path)
            
        model_file = os.path.join(save_path, 'ticket_demand_model.pkl')
        joblib.dump(model, model_file)

        self.stdout.write(self.style.SUCCESS(f'THÀNH CÔNG! Model đã được lưu tại: {model_file}'))