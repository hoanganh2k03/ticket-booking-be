import pandas as pd
import joblib
import os
import random
from django.conf import settings
from django.core.management.base import BaseCommand
from django.db.models import Avg, Sum
from sklearn.ensemble import RandomForestRegressor

# Import Models
from apps.events.models import Match
from apps.tickets.models import SectionPrice
from apps.orders.models import OrderDetail

class Command(BaseCommand):
    help = 'Huấn luyện AI với logic Cầu cứng (Inelastic Demand) cho trận HOT'

    def handle(self, *args, **kwargs):
        self.stdout.write(self.style.WARNING('1. Đang trích xuất dữ liệu thực tế...'))
        
        data = []
        matches = Match.objects.all()
        
        # 1. LẤY DỮ LIỆU THẬT (REAL DATA)
        for match in matches:
            # Lấy giá trung bình
            avg_price = SectionPrice.objects.filter(match=match).aggregate(Avg('price'))['price__avg']
            if not avg_price: continue

            # Lấy tổng vé bán
            total_sold = OrderDetail.objects.filter(pricing__match=match).count()
            
            # Lấy tổng sức chứa thực tế của trận này (để tính fill_rate nếu cần normalize)
            # Nhưng Random Forest có thể học số tuyệt đối nếu quy mô sân tương đồng
            
            data.append({
                'day_of_week': match.match_time.weekday(),
                'hour': match.match_time.hour,
                'is_hot_match': 1 if match.is_hot_match else 0,
                'importance': match.importance,
                'price': float(avg_price),
                'total_sold': total_sold
            })

        # 2. INJECT DỮ LIỆU GIẢ ĐỊNH PHÂN TẦNG (TIERED INJECTION)
        print("   -> Đang tiêm dữ liệu phân tầng (4 Tiers)...")
        
        import random
        AVG_CAPACITY = 1200 

        # --- TIER 1: SIÊU HOT (Importance 5, Derby) ---
        # Khách hàng: Bất chấp giá.
        for _ in range(200):
            price = random.randint(200000, 2000000)
            if price <= 800000: fill = random.uniform(0.95, 1.0) # Dưới 800k là auto full
            elif price <= 1500000: fill = random.uniform(0.70, 0.90)
            else: fill = random.uniform(0.30, 0.60)
            
            data.append({
                'day_of_week': random.choice([5, 6]), 'hour': random.choice([19, 20]),
                'is_hot_match': 1, 'importance': 5,
                'price': price, 'total_sold': int(AVG_CAPACITY * fill)
            })

        # --- TIER 2: SAO SỐ / CỬA TRÊN (Importance 4 - VD: Man City vs Sheffield) ---
        # Khách hàng: Chịu chi để xem ngôi sao, nhưng không "điên" như trận Derby.
        # Giá 300k vẫn phải bán tốt (80-90%), nhưng lên 600k là giảm.
        for _ in range(200):
            price = random.randint(150000, 1000000)
            if price <= 400000: 
                fill = random.uniform(0.85, 0.98) # <--- ĐIỂM KHÁC BIỆT: Giá 290k-400k vẫn full
            elif price <= 700000: 
                fill = random.uniform(0.50, 0.75)
            else: 
                fill = random.uniform(0.10, 0.30)

            data.append({
                'day_of_week': random.randint(0, 6), 'hour': random.choice([17, 19, 20]),
                'is_hot_match': 0, 'importance': 4, # Importance 4
                'price': price, 'total_sold': int(AVG_CAPACITY * fill)
            })

        # --- TIER 3: TRUNG BÌNH (Importance 3) ---
        # Khách hàng: Cân nhắc giá kỹ.
        for _ in range(200):
            price = random.randint(100000, 600000)
            if price <= 200000: fill = random.uniform(0.70, 0.90)
            elif price <= 350000: fill = random.uniform(0.40, 0.60)
            else: fill = random.uniform(0.05, 0.20)

            data.append({
                'day_of_week': random.randint(0, 6), 'hour': random.randint(17, 20),
                'is_hot_match': 0, 'importance': 3,
                'price': price, 'total_sold': int(AVG_CAPACITY * fill)
            })

        # --- TIER 4: ĐỘI YẾU / Ế (Importance 1, 2 - VD: Burnley vs Luton) ---
        # Khách hàng: Chỉ đi xem nếu rẻ như cho.
        # Giá 290k là CỰC ĐẮT với họ -> Fill rate phải thấp thảm hại.
        for _ in range(200):
            price = random.randint(50000, 400000)
            if price <= 100000: 
                fill = random.uniform(0.60, 0.85) # Rẻ bèo mới mua
            elif price <= 200000: 
                fill = random.uniform(0.20, 0.40) # Hơi đắt tí là nghỉ
            else: 
                fill = 0 # Trên 200k là sân trống
            
            data.append({
                'day_of_week': random.randint(0, 6), 'hour': random.randint(14, 17),
                'is_hot_match': 0, 
                'importance': random.choice([1, 2]), # Importance 1-2
                'price': price, 'total_sold': int(AVG_CAPACITY * fill)
            })

        # 3. TRAIN MODEL
        df = pd.DataFrame(data)
        self.stdout.write(f"   -> Tổng dữ liệu train: {len(df)} mẫu.")

        X = df[['day_of_week', 'hour', 'is_hot_match', 'importance', 'price']]
        y = df['total_sold']

        self.stdout.write(self.style.WARNING('2. Đang huấn luyện...'))
        
        # Tăng n_estimators để model học kỹ hơn
        model = RandomForestRegressor(n_estimators=300, random_state=42)
        model.fit(X, y)

        # Lưu model
        save_path = os.path.join(settings.BASE_DIR, 'ml_models')
        if not os.path.exists(save_path): os.makedirs(save_path)
        joblib.dump(model, os.path.join(save_path, 'price_optimization_model.pkl'))

        self.stdout.write(self.style.SUCCESS('✅ Train xong! '))