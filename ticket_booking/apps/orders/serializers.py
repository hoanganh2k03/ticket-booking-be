from rest_framework import serializers
from django.utils import timezone
from django.db import transaction
from django.db.models import Q, Subquery
from rest_framework.exceptions import ValidationError

from apps.events.models import Match, Team, League, Stadium
from apps.tickets.models import SectionPrice, Section, Seat
from apps.promotions.models import Promotion, PromotionDetail
from .models import Order, OrderDetail, Payment

from datetime import datetime

class TeamSerializer(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ['team_id', 'team_name', 'logo', 'head_coach', 'description']


class LeagueSerializer(serializers.ModelSerializer):
    class Meta:
        model = League
        fields = ['league_id', 'league_name']


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
    
    class Meta:
        model = Match
        fields = ['match_id', 'match_time', 'description', 'stadium', 'league', 'round', 'team_1', 'team_2', 'created_at', 'section_prices']


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
        Trích xuất thông báo lỗi từ đối tượng ValidationError.
        """
        if isinstance(e.detail, dict):
            print(e.detail)
            # Nếu lỗi là một dictionary, lấy tất cả các thông báo lỗi từ đó
            error_message = e.detail.get('message', "Không có thông báo lỗi chi tiết.")
        else:
            # Nếu lỗi là một chuỗi hoặc một danh sách, lấy lỗi trực tiếp
            error_message = str(e.detail)
        return error_message


def raise_custom_validation_error(message):
        """
        Tạo lỗi validation tùy chỉnh với mã lỗi và thông điệp.
        Trả về một định dạng lỗi dễ xử lý hơn.
        """
        # error_message = str(message) if isinstance(message, str) else str(message)
        error_detail = {
            "status": "error",
            "message": message
        }
        raise ValidationError(error_detail)


class OrderSerializer(serializers.ModelSerializer):
    order_details = OrderDetailSerializer(many=True)

    class Meta:
        model = Order
        fields = ['order_id', 'user', 'total_amount', 'order_status', 'order_method', 'created_at', 'order_details']

    def create(self, validated_data):
        with transaction.atomic():
            try:
                order_details_data = validated_data.pop('order_details')
                order = Order.objects.create(**validated_data)

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

                grouped_order_details = {}
                for order_detail_data in order_details_data:
                    pricing = order_detail_data['pricing']
                    if pricing.pricing_id not in grouped_order_details:
                        grouped_order_details[pricing.pricing_id] = []
                    grouped_order_details[pricing.pricing_id].append(order_detail_data)

                total_order_amount = 0

                for pricing_id, order_detail_group in grouped_order_details.items():
                    pricing = SectionPrice.objects.get(pricing_id=pricing_id)
                    available_seats = get_available_seats_for_section(pricing.section, pricing.match)

                    if available_seats.count() < len(order_detail_group):
                        raise raise_custom_validation_error("Không có đủ ghế trống cho tất cả các đơn hàng.")

                    used_promotions = {pid: 0 for pid in promotion_counts.keys()}

                    for order_detail_data in order_detail_group:
                        assigned_seat = available_seats.first()
                        available_seats = available_seats.exclude(seat_id=assigned_seat.seat_id)

                        promotion = order_detail_data.get('promotion', None)
                        final_promotion = None

                        if promotion:
                            promotion_id = promotion.promo_id
                            if (promotion_id in promotion_assignments and
                                    used_promotions[promotion_id] < promotion_assignments[promotion_id]):
                                final_promotion = promotion
                                used_promotions[promotion_id] += 1
                            else:
                                print(f"Promotion {promotion_id} has no remaining uses for this order_detail.")

                        print(f"Assigned promotion: {final_promotion}")
                        order_detail_data.pop('promotion', None)

                        # --- Tính giá vé và discount trước khi tạo OrderDetail ---
                        ticket_price = pricing.price
                        discount = 0
                        if final_promotion:
                            if final_promotion.discount_type == "amount":
                                discount = final_promotion.discount_value
                            elif final_promotion.discount_type == "percentage":
                                discount = (final_promotion.discount_value / 100) * ticket_price

                        final_price = max(0, ticket_price - discount)

                        order_detail_data.pop('price', None)

                        # --- Tạo OrderDetail và lưu giá tiền đã giảm vào ---
                        order_detail = OrderDetail.objects.create(
                            order=order,
                            seat=assigned_seat,
                            promotion=final_promotion,
                            price=final_price,  # Lưu giá đã giảm vào cột 'price' của OrderDetail
                            **order_detail_data
                        )

                        total_order_amount += final_price

                    pricing.available_seats -= len(order_detail_group)
                    pricing.save()

                order.total_amount = total_order_amount
                order.save()

                return order

            except Exception as e:
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