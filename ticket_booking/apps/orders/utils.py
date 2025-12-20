from background_task import background
from django.utils import timezone
from datetime import timedelta

from .models import Payment, OrderDetail, Order
from apps.tickets.models import Seat, SectionPrice
from apps.promotions.models import Promotion
from rest_framework.exceptions import ValidationError # <--- THÊM IMPORT NÀY


def get_available_seats_for_section(section, match):
    # Lấy tất cả ghế trong section có trạng thái available (status = 0)
    available_seats = Seat.objects.filter(section=section, status=0)

    # Lấy tất cả các trận đấu trong tương lai (match_time > hiện tại)

    # Lọc các ghế đã bị chiếm dụng bởi OrderDetail của các trận đấu trong tương lai
    occupied_seats = OrderDetail.objects.filter(
        pricing__match=match,  # Lọc qua Match thông qua Order
        seat__in=available_seats  # Kiểm tra xem seat đã được chiếm chưa
    ).values_list('seat', flat=True)  # Lấy danh sách seat_id đã bị giữ

    # Loại bỏ các ghế đã bị chiếm dụng khỏi danh sách available_seats
    available_seats = available_seats.exclude(seat_id__in=occupied_seats)

    return available_seats


# import logging
# logger = logging.getLogger(__name__)

# @background(schedule=60)
# def check_payment_expiration():
#     logger.info(f"Kiểm tra thanh toán hết hạn bắt đầu lúc {timezone.now()}")
#     expired_payments = Payment.objects.filter(payment_status='pending', expiration_time__lt=timezone.now())
#     for payment in expired_payments:
#         payment.payment_status = 'failed'
#         payment.save()


def check_payment_expiration():
    now = timezone.now()
    print(f"------------------------------------------------")
    print(f"⏰ BAT DAU QUET: {now}")
    
    # 1. DEBUG: Kiểm tra tổng thể bảng Payment xem có gì không
    # In ra 5 payment mới nhất bất kể trạng thái để xem DB có dữ liệu không
    all_payments = Payment.objects.all().order_by('-created_at')[:5] 
    if all_payments.exists():
        print("   🔍 [Soi DB] 5 Payment mới nhất trong bảng Payment:")
        for p in all_payments:
            # Dùng .pk thay cho .id để tránh lỗi
            print(f"      - PK: {p.pk} | Status: '{p.payment_status}' | Expire: {p.expiration_time}")
    else:
        print("   ⚠️ Bảng Payment đang TRỐNG RỖNG! (Nếu bảng Order có đơn mà bảng Payment trống thì logic tạo đơn có vấn đề)")

    # 2. Lọc đơn Pending (Sửa lỗi .pk)
    # Lưu ý: Kiểm tra kỹ xem trong DB chữ 'pending' viết hoa hay thường
    pending_payments = Payment.objects.filter(payment_status__iexact='pending') # iexact: Không phân biệt hoa thường
    print(f"   -> Tổng số Payment đang Pending tìm thấy: {pending_payments.count()}")

    if pending_payments.exists():
        sample = pending_payments.first()
        # Sửa sample.id -> sample.pk
        is_expired = sample.expiration_time and sample.expiration_time < now
        print(f"   -> [Check mẫu] PK: {sample.pk} | Time: {sample.expiration_time} | Hết hạn chưa?: {is_expired}")

    # 3. Lọc đơn THỰC SỰ hết hạn để hủy
    expired_payments = Payment.objects.filter(payment_status__iexact='pending', expiration_time__lt=now)
    
    if not expired_payments.exists():
        print("   -> ✅ Không có đơn nào quá hạn cần hủy.")
        print(f"------------------------------------------------")
        return

    print(f"   -> ⚡ Tìm thấy {expired_payments.count()} đơn quá hạn. Bắt đầu hủy...")

    # 4. Xử lý hủy
    for payment in expired_payments:
        try:
            print(f"   ♻️ Đang xử lý Payment PK: {payment.pk}")
            order = payment.order
            
            # Xóa payment
            payment.delete()

            # Hủy đơn
            order.order_status = 'cancelled'
            order.save() 

            # Hoàn vé & Promotion
            order_details = OrderDetail.objects.filter(order=order)
            for order_detail in order_details:
                section_price = order_detail.pricing
                section_price.available_seats += 1
                section_price.save()

                if order_detail.promotion:
                    promotion = order_detail.promotion
                    promotion.usage_limit += 1
                    promotion.save()

            print(f"      ✅ Đã hủy Order {order.order_id} thành công.")
            
        except Exception as e:
            print(f"      ❌ Lỗi khi xử lý Payment {payment.pk}: {str(e)}")
            
    print(f"------------------------------------------------")

def extract_error_message(e):
    """
    Trích xuất thông báo lỗi từ đối tượng ValidationError.
    """
    if hasattr(e, 'detail'):
        if isinstance(e.detail, dict):
            # Nếu lỗi là một dictionary, lấy tất cả các thông báo lỗi từ đó
            return e.detail.get('message', "Không có thông báo lỗi chi tiết.")
        else:
            # Nếu lỗi là một chuỗi hoặc một danh sách
            return str(e.detail)
    return str(e)


def raise_custom_validation_error(message):
    """
    Tạo lỗi validation tùy chỉnh với mã lỗi và thông điệp.
    """
    error_detail = {
        "status": "error",
        "message": message
    }
    raise ValidationError(error_detail)