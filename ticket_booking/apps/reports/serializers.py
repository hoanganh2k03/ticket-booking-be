from rest_framework import serializers

class DailyRevenueSerializer(serializers.Serializer):
    day = serializers.DateField()
    revenue = serializers.DecimalField(max_digits=12, decimal_places=2)

class RevenueByMatchSerializer(serializers.Serializer):
    match_id = serializers.IntegerField()
    match_time = serializers.DateTimeField()
    match_name = serializers.CharField() 
    revenue = serializers.DecimalField(max_digits=12, decimal_places=2)

class SectionRevenueSerializer(serializers.Serializer):
    section_id = serializers.IntegerField()
    section_name = serializers.CharField()
    revenue = serializers.DecimalField(max_digits=12, decimal_places=2)

class RevenueReportSerializer(serializers.Serializer):
    total_revenue = serializers.DecimalField(max_digits=14, decimal_places=2)
    by_date = DailyRevenueSerializer(many=True)
    by_match = RevenueByMatchSerializer(many=True)
    by_section = SectionRevenueSerializer(many=True)

class TicketReturnSerializer(serializers.Serializer):
    return_id = serializers.IntegerField()
    detail_id = serializers.IntegerField(source='detail.detail_id')
    seat_code     = serializers.CharField(source='detail.seat.seat_code')
    return_reason = serializers.CharField()
    refund_amount = serializers.DecimalField(max_digits=10, decimal_places=2)
    return_status = serializers.CharField()



class MatchTicketStatusSerializer(serializers.Serializer):
    match_id = serializers.IntegerField()
    match_name = serializers.CharField()
    match_date = serializers.DateTimeField()
    total_capacity = serializers.IntegerField()
    sold_tickets = serializers.IntegerField()
    available_tickets = serializers.IntegerField()
    fill_rate = serializers.DecimalField(max_digits=5, decimal_places=2)

class SectionStatusSerializer(serializers.Serializer):
    section_id = serializers.IntegerField()
    section_name = serializers.CharField()
    capacity = serializers.IntegerField()
    available_seats = serializers.IntegerField()

class DailyTicketSalesSerializer(serializers.Serializer):
    day = serializers.DateField()
    sold = serializers.IntegerField()

class TicketStatusReportSerializer(serializers.Serializer):
    matches = MatchTicketStatusSerializer(many=True)
    sections = SectionStatusSerializer(many=True)

class PromotionUsageSerializer(serializers.Serializer):
    promo_code = serializers.CharField()
    usage_count = serializers.IntegerField()
    total_discount = serializers.DecimalField(max_digits=12, decimal_places=2)

class ReturnReportSerializer(serializers.Serializer):
    total_returns = serializers.IntegerField()
    total_refunded_amount = serializers.DecimalField(max_digits=12, decimal_places=2)
    returns = TicketReturnSerializer(many=True)

# Viết serializer cho quản lý đơn đặt hàng (admin, staff)
from rest_framework import serializers
from apps.accounts.models import Customer
from apps.orders.models import Order, Payment, OrderDetail
from apps.events.models import League

class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = ['payment_id', 'payment_method', 'payment_status', 'transaction_code', 'created_at']

class OrderDetailSerializer(serializers.ModelSerializer):
    seat = serializers.CharField(source='seat.seat_number', read_only=True)
    section = serializers.CharField(source='pricing.section.section_name', read_only=True)

    class Meta:
        model = OrderDetail
        fields = ['detail_id', 'seat', 'section', 'price', 'promotion', 'qr_code', 'updated_at']

class OrderSerializer(serializers.ModelSerializer):
    user = serializers.CharField(source='user.full_name', read_only=True)
    order_status_display = serializers.SerializerMethodField()
    order_method_display = serializers.SerializerMethodField()
    payments = PaymentSerializer(many=True, source='payment_set', read_only=True)
    details = OrderDetailSerializer(many=True, source='order_details', read_only=True)

    class Meta:
        model = Order
        fields = [
            'order_id', 'user', 'total_amount', 'order_status', 'order_status_display',
            'order_method', 'order_method_display', 'created_at', 'payments', 'details'
        ]

    def get_order_status_display(self, obj):
        return obj.get_order_status_display()

    def get_order_method_display(self, obj):
        return obj.get_order_method_display()

# Lấy danh sách các giải đấu
class LeagueListSerializer(serializers.ModelSerializer):
    class Meta:
        model = League
        fields = [
            'league_id',
            'league_name',
            'start_date',
            'end_date',
        ]

# Viết serializer cho quản lý giao dịch thanh toán
from apps.orders.models import Payment

class PaymentSerializer(serializers.ModelSerializer):
    order_id = serializers.CharField(source='order.order_id', read_only=True)

    class Meta:
        model = Payment
        fields = [
            'payment_id',
            'order_id',
            'payment_method',
            'payment_status',
            'transaction_code',
            'created_at',
        ]