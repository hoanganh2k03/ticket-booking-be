# apps/orders/signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.db.models import F
from .models import Payment
# Đảm bảo import đúng đường dẫn model của bạn
from apps.accounts.models import PointHistory, Customer

# apps/orders/signals.py

@receiver(post_save, sender=Payment)
def handle_loyalty_points(sender, instance, **kwargs):
    try:
        if instance.payment_status == 'success':
            order = instance.order
            customer = order.user

            if customer:
                # 1. Lấy thông tin cũ trước khi cộng
                old_loyalty_score = customer.loyalty_score
                
                # 2. Xác định hệ số nhân
                multiplier = 1.0
                if customer.tier == 'silver': multiplier = 1.1
                elif customer.tier == 'gold': multiplier = 1.2
                elif customer.tier == 'diamond': multiplier = 1.5

                # 3. Tính toán điểm
                base_points = int(order.total_amount / 10000) # Điểm xếp hạng (Gốc)
                spending_points = int(base_points * multiplier) # Điểm tiêu dùng (Đã nhân)

                if spending_points > 0:
                    # Cộng dồn điểm
                    customer.points += spending_points
                    customer.loyalty_score += base_points
                    
                    # --- LOGIC MỚI: THƯỞNG VƯỢT NGƯỠNG CHO DIAMOND ---
                    if customer.tier == 'diamond':
                        # Quy định: Cứ mỗi 2000 điểm xếp hạng tăng thêm -> Tặng 500 điểm tiêu dùng
                        STEP = 2000
                        DIAMOND_BASE = 5000 # <--- Thêm mốc gốc
                        BONUS_REWARD = 500
                        
                        # Logic cũ: old_loyalty_score // STEP
                        
                        # LOGIC MỚI: Trừ đi 5000 trước khi chia
                        # Ví dụ: 6900 -> (6900-5000)//2000 = 0 (Chưa được quà)
                        # Ví dụ: 7100 -> (7100-5000)//2000 = 1 (Được quà mốc 1 - tức là 7000)
                        
                        # Xử lý trường hợp điểm < 5000 (dù hiếm khi xảy ra nếu đã là diamond)
                        score_check_old = max(0, old_loyalty_score - DIAMOND_BASE)
                        score_check_new = max(0, customer.loyalty_score - DIAMOND_BASE)

                        old_milestone = score_check_old // STEP
                        new_milestone = score_check_new // STEP
                        
                        if new_milestone > old_milestone:
                            customer.points += BONUS_REWARD
                            
                            # Ghi log thưởng riêng
                            PointHistory.objects.create(
                                customer=customer,
                                order=None, # Không thuộc đơn hàng nào, đây là quà hệ thống
                                change_amount=BONUS_REWARD,
                                reason=f" Thưởng nóng đạt mốc {new_milestone * STEP} điểm uy tín!"
                            )
                            print(f"💎 DIAMOND BONUS: Tặng {BONUS_REWARD} điểm cho {customer.full_name}")
                    # -----------------------------------------------------

                    customer.save() # Lưu lại (Hàm save trong model sẽ lo vụ cập nhật tier nếu cần)
                    
                    # Ghi log tích điểm thường
                    PointHistory.objects.create(
                        customer=customer,
                        order=order,
                        change_amount=spending_points,
                        reason=f"Tích điểm đơn hàng (Hạng {customer.get_tier_display()})"
                    )

    except Exception as e:
        print(f"❌ [SIGNAL ERROR]: {str(e)}")
from apps.orders.models import Order
# --- PHẦN BỔ SUNG: HOÀN ĐIỂM KHI HỦY ĐƠN ---
@receiver(post_save, sender=Order)
def refund_points_on_cancel(sender, instance, created, **kwargs):
    """
    Tự động hoàn lại điểm nếu đơn hàng chuyển sang trạng thái 'cancelled'
    """
    if created:
        return # Chỉ xử lý khi cập nhật trạng thái (update), không xử lý khi mới tạo

    try:
        # Chỉ chạy khi trạng thái là 'cancelled'
        if instance.order_status == 'cancelled':
            customer = instance.user
            
            # 1. Kiểm tra xem đơn này ngày xưa có dùng điểm không?
            # Tìm lịch sử trừ điểm (change_amount < 0) gắn với order này
            used_point_history = PointHistory.objects.filter(
                order=instance,
                change_amount__lt=0 
            ).first()

            # 2. Kiểm tra xem đã hoàn tiền chưa (để tránh hoàn 2 lần nếu lỡ tay bấm save nhiều lần)
            is_already_refunded = PointHistory.objects.filter(
                order=instance,
                reason__icontains="Hoàn lại điểm" # Kiểm tra nội dung log
            ).exists()

            if used_point_history and not is_already_refunded:
                # Lấy số điểm dương (bỏ dấu âm đi)
                points_to_refund = abs(used_point_history.change_amount)

                # 3. Cộng lại điểm cho khách
                customer.points += points_to_refund
                customer.save()

                # 4. Ghi log lịch sử trả điểm
                PointHistory.objects.create(
                    customer=customer,
                    order=instance,
                    change_amount=points_to_refund, # Số dương
                    reason=f"Hoàn lại điểm do hủy đơn hàng {instance.order_id}"
                )
                print(f"♻️ Đã hoàn lại {points_to_refund} điểm cho khách hàng {customer.full_name}")

    except Exception as e:
        print(f"❌ [REFUND SIGNAL ERROR]: {str(e)}")