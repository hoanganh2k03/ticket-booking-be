from rest_framework import serializers
from django.utils import timezone
from apps.orders.models import OrderDetail
from apps.returns.models import TicketReturn
from apps.accounts.models import Employee  

class CustomerTicketReturnSerializer(serializers.ModelSerializer):
    detail_id = serializers.PrimaryKeyRelatedField(
        queryset=OrderDetail.objects.all(), source='detail', write_only=True
    )

    def validate(self, attrs):
        """
        Bắt lỗi nếu khách cố gửi yêu cầu hoàn vé sau khi trận đã diễn ra.
        """
        detail: OrderDetail = attrs['detail']
        # Lấy thời gian trận
        match_time = detail.pricing.match.match_time
        now = timezone.now()
        if match_time <= now:
            raise serializers.ValidationError(
                "Trận đấu đã diễn ra rồi, không thể yêu cầu hoàn vé."
            )
        return attrs

    class Meta:
        model = TicketReturn
        fields = ['detail_id', 'return_reason']

class TicketReturnSerializer(serializers.ModelSerializer):
    customer = serializers.ReadOnlyField(source='detail.order.user.full_name')
    seat_code = serializers.ReadOnlyField(source='detail.seat.seat_code')
    original_price = serializers.ReadOnlyField(source='detail.price')
    employee_name = serializers.SerializerMethodField()

    def get_employee_name(self, obj):
        return obj.employee.full_name if obj.employee else None

    class Meta:
        model = TicketReturn
        fields = [
            'return_id', 'customer', 'seat_code', 'original_price',
            'return_reason', 'refund_method', 'refund_amount',
            'return_status', 'return_time', 'processed_time',
            'employee_name', 'note'
        ]

class EmployeeProcessTicketReturnSerializer(serializers.Serializer):
    refund_method = serializers.ChoiceField(
        choices=TicketReturn._meta.get_field('refund_method').choices
    )
    refund_amount = serializers.DecimalField(
        max_digits=10, decimal_places=2
    )
    note = serializers.CharField(required=False, allow_blank=True)
    employee = serializers.PrimaryKeyRelatedField(
        queryset=Employee.objects.all()
    )

class EmployeeRejectTicketReturnSerializer(serializers.Serializer):
    note = serializers.CharField(required=True)
    employee = serializers.PrimaryKeyRelatedField(
        queryset=Employee.objects.all()
    )
