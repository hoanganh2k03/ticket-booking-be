from rest_framework import serializers
from django.utils import timezone
from django.db import transaction
from django.db.models import Q, Subquery
from rest_framework.exceptions import ValidationError
from django.db import transaction
from django.db.models import F
from django.db.models import Max
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from apps.events.models import Match, Team, League, Stadium
from apps.tickets.models import SectionPrice, Section, Seat
from apps.promotions.models import Promotion, PromotionDetail
from .models import Order, OrderDetail, Payment
from datetime import datetime
from django.db import transaction
from django.db.models import F
import random
from .utils import get_available_seats_for_section, extract_error_message, raise_custom_validation_error
class TeamSerializer(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ['team_id', 'team_name', 'logo', 'head_coach', 'description']


class LeagueSerializer(serializers.ModelSerializer):
    sport_name = serializers.CharField(source='sport.sport_name', read_only=True)
    class Meta:
        model = League
        fields = ['league_id', 'league_name', 'start_date', 'end_date', 'sport_name']


class StadiumSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stadium
        fields = '__all__'


class SectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = '__all__'


class SectionPriceSerializer(serializers.ModelSerializer):
    section = SectionSerializer()
    class Meta:
        model = SectionPrice
        fields = ['pricing_id', 'match', 'section', 'price', 'available_seats', 'sell_date', 'is_closed']


class MatchSerializer(serializers.ModelSerializer):
    team_1 = TeamSerializer()
    team_2 = TeamSerializer()
    league = LeagueSerializer()
    stadium = StadiumSerializer()
    section_prices = SectionPriceSerializer(source='tickets', many=True)
    discount_percent = serializers.SerializerMethodField()
    class Meta:
        model = Match
        fields = ['match_id', 'match_time', 'description', 'stadium', 'league', 'round', 'team_1', 'team_2', 'created_at', 'section_prices','importance','is_hot_match','discount_percent']
    def get_discount_percent(self, obj):
        now = timezone.now()
        
        # LOGIC SỬA ĐỔI:
        # Chúng ta query từ bảng Promotion, nhưng lọc qua bảng con PromotionDetail
        # Cú pháp: promotiondetail__match=obj
        # (Nghĩa là: Tìm Promotion mà có PromotionDetail trỏ tới Match hiện tại)
        
        result = Promotion.objects.filter(
            promotiondetail__match=obj, # <--- ĐIỂM QUAN TRỌNG NHẤT
            
            status=True,                # Promotion phải đang Active
            start_time__lte=now,        # Đã bắt đầu
            end_time__gte=now,          # Chưa kết thúc
            usage_limit__gt=0,          # Còn lượt dùng
            discount_type='percentage'  # Chỉ lấy loại phần trăm
        ).aggregate(Max('discount_value'))
        
        return result['discount_value__max'] or 0

class PromotionDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = PromotionDetail
        fields = ['promo', 'match', 'section']

class PromotionSerializer(serializers.ModelSerializer):
    details = PromotionDetailSerializer(many=True, read_only=True)

    class Meta:
        model = Promotion
        fields = ['promo_id', 'promo_code', 'discount_value', 'discount_type', 'start_time', 'end_time', 'usage_limit', 'description', 'status', 'details']


# Order Processing
class OrderDetailSerializer(serializers.ModelSerializer):
    promotion = serializers.PrimaryKeyRelatedField(queryset=Promotion.objects.all(), required=False, allow_null=True)
    
    class Meta:
        model = OrderDetail
        fields = ['pricing', 'seat', 'price', 'promotion', 'qr_code']

        # Thêm dòng này để ignore dữ liệu rác từ FE
        read_only_fields = ['detail_id', 'price', 'qr_code']

def get_available_seats_for_section(section, match):
    # Lấy tất cả ghế trong section có trạng thái available (status = 0)
    available_seats = Seat.objects.filter(section=section, status=0)

    # Lấy tất cả các trận đấu trong tương lai (match_time > hiện tại)

    order_details = OrderDetail.objects.filter(
        pricing__match=match,
        seat__in=available_seats,
        order__order_status='received'
    ).select_related('ticketreturn')

    # Chỉ lấy những OrderDetail mà ticket_return là None hoặc status != 'completed'
    occupied_seat_ids = []
    for od in order_details:
        # Nếu không có ticket_return hoặc ticket_return.status khác completed thì ghế đang chiếm
        if not hasattr(od, 'ticketreturn') or od.ticketreturn is None:
            occupied_seat_ids.append(od.seat_id)
        elif od.ticketreturn.return_status != 'completed':
            occupied_seat_ids.append(od.seat_id)


    # Loại bỏ các ghế đã bị chiếm dụng khỏi danh sách available_seats
    available_seats = available_seats.exclude(seat_id__in=occupied_seat_ids)

    return available_seats


def extract_error_message(e):
    """
    Trích xuất thông báo lỗi từ nhiều loại Exception khác nhau (ValidationError, IntegrityError, v.v.)
    """
    # 1. Nếu là ValidationError của DRF (có thuộc tính .detail)
    if hasattr(e, 'detail'):
        if isinstance(e.detail, dict):
            # Nếu detail là dict, cố gắng lấy message hoặc trả về chuỗi của dict
            # Đôi khi lỗi nằm trong key cụ thể, ví dụ {'non_field_errors': ['...']}
            for key, value in e.detail.items():
                if isinstance(value, list):
                    return f"{key}: {value[0]}"
                return str(value)
            return str(e.detail)
        elif isinstance(e.detail, list):
            return str(e.detail[0])
        else:
            return str(e.detail)

    # 2. Nếu là lỗi thông thường hoặc lỗi Database (không có .detail)
    return str(e)


def raise_custom_validation_error(message):
    """
    Tạo lỗi validation tùy chỉnh và chuẩn hóa thông điệp trả về.
    - Nếu `message` không phải chuỗi, cố gắng trích xuất chuỗi bằng `extract_error_message`.
    - Trả về `ValidationError` với key `message` (dễ đọc trên frontend).
    """
    # Chuẩn hóa message về chuỗi
    if not isinstance(message, str):
        normalized = extract_error_message(message)
    else:
        normalized = message

    # Trả về cấu trúc đơn giản để frontend dễ hiển thị
    raise ValidationError({"message": normalized})


# ==========================================

# ==========================================
# 3. CLASS ORDER SERIALIZER (HOÀN CHỈNH)
# ==========================================
import math
class OrderSerializer(serializers.ModelSerializer):
    order_details = OrderDetailSerializer(many=True)
    class Meta:
        model = Order
        fields = ['order_id', 'user', 'total_amount', 'order_status', 'order_method', 'created_at', 'order_details']

    def create(self, validated_data):
        # 1. BẮT ĐẦU VÙNG AN TOÀN (Giữ nguyên)
        # Nếu có lỗi, mọi thứ sẽ được rollback (hủy bỏ)
        with transaction.atomic():
            try:
                request = self.context.get('request')
                # Mặc định là 0 nếu khách không nhập điểm
                use_points = int(request.data.get('use_points', 0)) 
                customer = validated_data.get('user') # Instance của Customer
                
                order_details_data = validated_data.pop('order_details')
                order = Order.objects.create(**validated_data)
                # order_details_data = validated_data.pop('order_details')
                # order = Order.objects.create(**validated_data)

                # --- (Phần code xử lý Promotion của bạn - GIỮ NGUYÊN) ---
                promotion_counts = {}
                for order_detail_data in order_details_data:
                    promotion = order_detail_data.get('promotion', None)
                    if promotion:
                        promotion_id = promotion.promo_id
                        if promotion_id not in promotion_counts:
                            promotion_counts[promotion_id] = {'promotion': promotion, 'count': 0}
                        promotion_counts[promotion_id]['count'] += 1

                promotion_assignments = {}
                for promotion_id, info in promotion_counts.items():
                    promotion = info['promotion']
                    count = info['count']
                    promotion.refresh_from_db()
                    available_uses = promotion.usage_limit
                    promotion_assignments[promotion_id] = min(available_uses, count)
                    if promotion_assignments[promotion_id] > 0:
                        promotion.usage_limit -= promotion_assignments[promotion_id]
                        if promotion.usage_limit == 0:
                            promotion.status = False
                        promotion.save()
                # --- (Kết thúc phần Promotion) ---


                # --- (Phần code gom nhóm vé - GIỮ NGUYÊN) ---
                grouped_order_details = {}
                for order_detail_data in order_details_data:
                    pricing = order_detail_data['pricing']
                    if pricing.pricing_id not in grouped_order_details:
                        grouped_order_details[pricing.pricing_id] = []
                    grouped_order_details[pricing.pricing_id].append(order_detail_data)

                total_order_amount = 0

                # --- 3. THÊM 2 BIẾN NÀY ĐỂ KÍCH HOẠT WEBSOCKET ---
                sections_to_update_ws = {} # Dữ liệu sẽ gửi qua WebSocket
                match_id_for_ws = None     # ID của "phòng" WebSocket
                all_assigned_seats = []    # (Nâng cao) Gửi ID ghế đã bán
                # --------------------------------------------------

                for pricing_id, order_detail_group in grouped_order_details.items():
                    
                    # 4. !!! SỬA LẠI: DÙNG select_for_update() ĐỂ KHÓA HÀNG !!!
                    # Đây là cách "bảo vệ" available_seats khỏi Race Condition
                    # Bất kỳ ai khác cố update hàng này sẽ phải ĐỢI
                    try:
                        pricing = SectionPrice.objects.select_for_update().get(pricing_id=pricing_id)
                    except SectionPrice.DoesNotExist:
                        raise raise_custom_validation_error("Khu vực vé không tồn tại.")
                    
                    # (Lưu lại match_id để gửi WebSocket)
                    if not match_id_for_ws:
                        match_id_for_ws = pricing.match.match_id

                    # 5. KIỂM TRA BỘ ĐẾM (Bên trong vùng an toàn - Giữ nguyên)
                    if pricing.available_seats < len(order_detail_group):
                        raise raise_custom_validation_error(f"Không có đủ ghế trống (chỉ còn {pricing.available_seats}).")

                    # 6. KIỂM TRA GHẾ THỰC TẾ (Giữ nguyên logic của bạn)
                    available_seats = get_available_seats_for_section(pricing.section, pricing.match)
                    if available_seats.count() < len(order_detail_group):
                        raise raise_custom_validation_error(f"Lỗi hệ thống: Số ghế thực tế ({available_seats.count()}) không khớp bộ đếm ({pricing.available_seats}).")

                    used_promotions = {pid: 0 for pid in promotion_counts.keys()}

                    # 7. GÁN GHẾ (Giữ nguyên logic .first() của bạn)
                    for order_detail_data in order_detail_group:
                        assigned_seat = available_seats.first()
                        available_seats = available_seats.exclude(seat_id=assigned_seat.seat_id)

                        # ... (Logic tính giá, gán promotion của bạn - GIỮ NGUYÊN) ...
                        promotion = order_detail_data.get('promotion', None)
                        final_promotion = None
                        if promotion:
                            promotion_id = promotion.promo_id
                            if (promotion_id in promotion_assignments and
                                    used_promotions[promotion_id] < promotion_assignments[promotion_id]):
                                final_promotion = promotion
                                used_promotions[promotion_id] += 1
                        
                        ticket_price = pricing.price
                        discount = 0
                        if final_promotion:
                            if final_promotion.discount_type == "amount":
                                discount = final_promotion.discount_value
                            elif final_promotion.discount_type == "percentage":
                                discount = (final_promotion.discount_value / 100) * ticket_price
                        final_price = max(0, ticket_price - discount)
                        order_detail_data.pop('price', None)
                        order_detail_data.pop('promotion', None)
                        # ----------------------------------------------------

                        order_detail = OrderDetail.objects.create(
                            order=order,
                            seat=assigned_seat,
                            promotion=final_promotion,
                            price=final_price,
                            **order_detail_data
                        )
                        total_order_amount += final_price
                        all_assigned_seats.append(assigned_seat.seat_id) # Thêm ID ghế vào list

                    # 8. !!! SỬA LẠI: CẬP NHẬT BỘ ĐẾM AN TOÀN BẰNG F() !!!
                    pricing.available_seats = F('available_seats') - len(order_detail_group)
                    pricing.save()
                    
                    pricing.refresh_from_db() # Tải lại dữ liệu mới nhất từ DB
                    
                    # Lúc này pricing.available_seats sẽ là 17 (19 - 2)
                    sections_to_update_ws[str(pricing.section.section_id)] = pricing.available_seats
                    # ------------------------------------------------
                # tích điểm
                # --- MỚI: XỬ LÝ TRỪ ĐIỂM GIẢM GIÁ (Sau khi đã tính tổng tiền vé) ---
                points_discount_money = 0
                if customer and use_points > 0:
                    # 1. Kiểm tra số dư điểm
                    if customer.points < use_points:
                        raise raise_custom_validation_error(f"Số điểm không đủ (Bạn có {customer.points} điểm).")
                    
                    # 2. Tính số điểm TỐI ĐA cần thiết để thanh toán đơn hàng này
                    # Ví dụ: Đơn 900k -> Cần tối đa 900 điểm
                    # Đơn 900.500đ -> Cần tối đa 901 điểm (dùng math.ceil làm tròn lên)
                    max_points_needed = math.ceil(total_order_amount / 1000)
                    
                    # 3. Chốt số điểm thực tế sẽ trừ (Lấy số nhỏ hơn giữa: Khách nhập vs Hệ thống cần)
                    # Nếu khách nhập 1000, nhưng cần 900 -> Trừ 900
                    # Nếu khách nhập 500, cần 900 -> Trừ 500
                    actual_points_to_use = min(use_points, max_points_needed)
                    
                    # 4. Tính tiền giảm giá thực tế
                    points_discount_money = actual_points_to_use * 1000
                    
                    # 5. Cập nhật điểm của Customer (Trừ số điểm thực tế)
                    customer.points = F('points') - actual_points_to_use
                    customer.save()
                    
                    # 6. Ghi lịch sử trừ điểm
                    from apps.accounts.models import PointHistory
                    PointHistory.objects.create(
                        customer=customer,
                        order=order,
                        change_amount=-actual_points_to_use, # Lưu số điểm thực tế bị trừ
                        reason=f"Sử dụng {actual_points_to_use} điểm giảm giá (yêu cầu {use_points})"
                    )

                # --- CẬP NHẬT TRẠNG THÁI CUỐI CÙNG CỦA ORDER ---
                order.points_discount = points_discount_money
                # Tổng tiền = Tổng giá vé - Tiền giảm từ điểm
                order.total_amount = max(0, total_order_amount - points_discount_money)
                order.save()
                # --- KẾT THÚC XỬ LÝ ĐIỂM GIẢM GIÁ ---
                # websocket
                
                if match_id_for_ws and sections_to_update_ws:
                    try:
                        channel_layer = get_channel_layer()
                        async_to_sync(channel_layer.group_send)(
                            f"match_{match_id_for_ws}", 
                            {
                                "type": "broadcast_ticket_update", 
                                "updated_sections": sections_to_update_ws, # Gửi số 17 đúng
                                "message": "Có vé vừa được đặt thành công!"
                            }
                        )
                        print(f"✅ Đã gửi WebSocket: {sections_to_update_ws}")
                    except Exception as ws_error:
                        print(f"❌ Lỗi gửi WebSocket: {ws_error}")

                return order

            except Exception as e:
                # Nếu có lỗi (hết vé), transaction.atomic() sẽ tự động
                # rollback (hủy) mọi thay đổi (kể cả F()).
                # -> `available_seats` sẽ KHÔNG BỊ TRỪ.
                error_message = extract_error_message(e)
                raise raise_custom_validation_error(error_message)
            


class PaymentSerializer(serializers.ModelSerializer):
    order = serializers.PrimaryKeyRelatedField(queryset=Order.objects.all())
    transaction_code = serializers.CharField(allow_null=True, required=False, allow_blank=True)
    class Meta:
        model = Payment
        fields = ['payment_id', 'order', 'payment_method', 'payment_status', 'transaction_code', 'expiration_time', 'created_at']



class SeatSerializer(serializers.ModelSerializer):
    class Meta:
        model = Seat
        fields = ['seat_id', 'seat_number']


class PromotionListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promotion
        fields = ['promo_id', 'promo_code', 'discount_value', 'discount_type', 'description']


class PaymentOrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = ['payment_id', 'payment_method', 'payment_status', 'transaction_code', 'created_at']


class MatchOrderSerializer(serializers.ModelSerializer):
    team_1 = TeamSerializer()
    team_2 = TeamSerializer()
    league = LeagueSerializer()
    stadium = StadiumSerializer()
    
    class Meta:
        model = Match
        fields = ['match_id', 'match_time', 'description', 'stadium', 'league', 'round', 'team_1', 'team_2', 'created_at']


class OrderDetailListSerializer(serializers.ModelSerializer):
    seat = SeatSerializer()
    promotion = PromotionListSerializer()  # Assuming you have SectionPriceSerializer created

    class Meta:
        model = OrderDetail
        fields = ['detail_id', 'order', 'qr_code', 'seat', 'price', 'promotion', 'updated_at']


class OrderListSerializer(serializers.ModelSerializer):
    order_details = OrderDetailListSerializer(many=True)
    payment = PaymentOrderSerializer()  # Assuming one payment per order
    match = MatchOrderSerializer()  # Include match related to the order (if applicable)

    class Meta:
        model = Order
        fields = ['order_id', 'user', 'total_amount', 'order_status', 'order_method', 'created_at', 'order_details', 'payment', 'match']