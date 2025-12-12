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
    expired_payments = Payment.objects.filter(payment_status='pending', expiration_time__lt=timezone.now())
    
    for payment in expired_payments:
        # Cập nhật trạng thái payment thành 'failed'
        # payment.payment_status = 'failed'
        # payment.save()

        # Lấy đơn hàng liên quan đến payment này
        order = payment.order

        payment.delete()

        # Cập nhật trạng thái đơn hàng thành 'cancelled'
        order.order_status = 'cancelled'
        order.save()

        # Lấy tất cả OrderDetail liên quan đến Order này
        order_details = OrderDetail.objects.filter(order=order)

        # Cập nhật thông tin seat_id trong OrderDetail thành null và quản lý usage_limit của Promotion
        for order_detail in order_details:
            # Cập nhật lại số ghế còn lại trong SectionPrice
            section_price = order_detail.pricing
            section_price.available_seats += 1
            section_price.save()

            # Nếu OrderDetail có promotion, tăng usage_limit của Promotion
            if order_detail.promotion:
                promotion = order_detail.promotion
                promotion.usage_limit += 1
                promotion.save()

                # Log để kiểm tra các promotion đã được cập nhật
                print(f"Promotion {promotion.promo_code} usage_limit increased to {promotion.usage_limit}.")

        # Đảm bảo các thay đổi đã được lưu vào database
        print(f"Order {order.order_id} has been cancelled and all associated seats have been freed.")

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