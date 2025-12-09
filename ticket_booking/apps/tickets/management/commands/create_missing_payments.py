import random
import uuid
from datetime import timedelta
from django.core.management.base import BaseCommand
from apps.orders.models import Order, Payment # Import model Payment

class Command(BaseCommand):
    help = 'Tạo Payment cho các Order chưa có thông tin thanh toán'

    def handle(self, *args, **kwargs):
        self.stdout.write("Đang kiểm tra và tạo Payment bổ sung...")

        # Lọc các đơn hàng chưa có payment (payment__isnull=True)
        orders = Order.objects.filter(payment__isnull=True, order_status='SUCCESS')
        
        count = 0
        payment_methods = ['MOMO', 'VNPAY', 'ZALOPAY', 'VISA', 'CASH']

        for order in orders:
            # Tạo Payment tương ứng
            Payment.objects.create(
                payment_method=random.choice(payment_methods),
                payment_status='SUCCESS', # Khớp với status của Order
                transaction_code=f"TRX_{uuid.uuid4().hex[:10].upper()}", # Mã giao dịch giả
                created_at=order.created_at, # Thanh toán ngay lúc tạo đơn
                expiration_time=order.created_at + timedelta(minutes=15),
                order=order
            )
            count += 1

        self.stdout.write(self.style.SUCCESS(f"XONG! Đã tạo thêm {count} bản ghi Payment."))