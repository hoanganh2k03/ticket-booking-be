# apps/returns/views.py
from decimal import Decimal
from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from django.utils import timezone
from rest_framework.response import Response
from django.db import models, transaction
from django.core.mail import send_mail
from django.conf import settings
from apps.returns.models import TicketReturn
from apps.tickets.models import SectionPrice
import time 
from .serializers import (
    CustomerTicketReturnSerializer,
    TicketReturnSerializer,   # dùng để đọc chi tiết
    EmployeeProcessTicketReturnSerializer,
    EmployeeRejectTicketReturnSerializer,
)

class TicketReturnViewSet(viewsets.ModelViewSet):
    queryset = TicketReturn.objects.all().order_by('-return_time')
    authentication_classes = []  # bỏ qua token authentication
    permission_classes = [permissions.AllowAny]
    # permission_classes = [permissions.IsAuthenticated]
    
    def get_serializer_class(self):
        if self.action == 'create':
            return CustomerTicketReturnSerializer
        if self.action == 'process':
            return EmployeeProcessTicketReturnSerializer
        if self.action == 'reject':
            return EmployeeRejectTicketReturnSerializer
        return TicketReturnSerializer

    def perform_create(self, serializer):
        # chỉ lưu pending + liên kết detail & reason
        serializer.save(return_status='pending')

    def get_queryset(self):
        qs = super().get_queryset()
        status_filter = self.request.query_params.get('return_status')

        # if self.request.user.role == 'customer':
        #     # chỉ xem của mình
        #     qs = qs.filter(detail__order__user=self.request.user)
        if status_filter:
            qs = qs.filter(return_status=status_filter)
        return qs

    # @action(detail=True, methods=['post'], url_path='process')
    # def process(self, request, pk=None):
    #     ret = self.get_object()
    #     if ret.return_status != 'pending':
    #         return Response(
    #             {'detail': 'Thủ tục hoàn vé đã được xử lý.'},
    #             status=status.HTTP_400_BAD_REQUEST
    #         )
    from django.db import transaction
    @action(detail=True, methods=['post'], url_path='process')
    def process(self, request, pk=None):
        with transaction.atomic():
            ret = TicketReturn.objects.select_for_update().get(pk=pk)  # khóa bản ghi
            if ret.return_status != 'pending':
                return Response({'detail': 'Thủ tục hoàn vé đã được xử lý.'}, status=400)
        serializer = EmployeeProcessTicketReturnSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        with transaction.atomic():
            # Cập nhật thông tin hoàn vé
            ret.refund_amount   = data['refund_amount']
            ret.refund_method   = data['refund_method']
            ret.note            = data.get('note', '')
            ret.return_status   = 'completed'
            ret.processed_time  = timezone.now()
            ret.employee        = data['employee']
            ret.save()

            # Lấy OrderDetail gốc từ TicketReturn
            order_detail = ret.detail

            # 1. Release ghế: update available_seats và is_closed atomically
            section_price = order_detail.pricing
            from django.db.models import F

            SectionPrice.objects.filter(pk=section_price.pk).update(
                available_seats=F('available_seats') + 1,
                **({'is_closed': False} if section_price.available_seats == 0 else {})
            )

            # 2. Nếu có dùng promo, update usage_limit and status
            promo = getattr(order_detail, 'promotion', None)
            if promo:
                if promo.status == 0 and promo.usage_limit == 0:
                    promo.status = 1
                promo.usage_limit = promo.usage_limit + 1
                promo.save()

            # 3. Cập nhật lại tổng tiền của Order
            order = order_detail.order
            order.total_amount = order.order_details.aggregate(
                total=models.Sum('price')
            )['total'] or 0
            # Nếu tất cả vé đã được hoàn, có thể chuyển trạng thái đơn về 'cancelled' hoặc tuỳ logic
            # remaining = order.order_details.exclude(
            #     ticketreturn__return_status='completed'
            # ).count()
            # if remaining == 0:
            #     order.order_status = 'cancelled'
            order.save()

            # 4. Cập nhật lại updated_date trong order_detail
            order_detail.updated_date = timezone.now()
            order_detail.save()

        # --- LẤY THÔNG TIN VÉ ---
        od: OrderDetail = ret.detail
        section_name = od.pricing.section.section_name if od.pricing.section else '–'
        seat_code    = od.seat.seat_number if od.seat else '–'
        match        = od.pricing.match
        match_desc   = match.description
        match_time   = match.match_time.strftime('%d-%m-%Y %H:%M')

        customer = ret.detail.order.user
        method = {'bank_card': 'Thẻ ngân hàng', 'transfer': 'Chuyển khoản', 'cash': 'Tiền mặt'}
        # --- XÂY DỰNG NỘI DUNG EMAIL ---
        subject = f"[Hoàn vé] Yêu cầu #{ret.return_id} đã được CHẤP NHẬN"
        message = (
            f"Chào {ret.detail.order.user.full_name},\n\n"
            f"Yêu cầu hoàn vé của bạn đã được **chấp nhận**.\n\n"
            f"— Thông tin vé:\n"
            f"   • Mã đơn: {ret.detail.order.order_id}\n"
            f"   • Mã vé: {od.detail_id}\n"
            f"   • Giải đấu / Trận: {match.league.league_name} / {match_desc}\n"
            f"   • Thời gian: {match_time}\n"
            f"   • Khu vực: {section_name}\n"
            f"   • Ghế: {seat_code}\n"
            f"   • Giá gốc: {od.price} VNĐ\n"
            f"   • Mã khuyến mãi: {od.promotion.promo_code if od.promotion else 'Không có'}\n\n"
            f"— Thông tin hoàn:\n"
            f"   • Số tiền hoàn: {ret.refund_amount} VNĐ\n"
            f"   • Phương thức: {method[ret.refund_method]}\n\n"
            f"Xin cảm ơn bạn đã sử dụng dịch vụ.\n"
        )

        try:
            send_mail(
                subject,
                message,
                settings.DEFAULT_FROM_EMAIL,
                [customer.email],
                fail_silently=False,
            )
            time.sleep(2)
        except Exception as e:
            # bạn có thể log lỗi hoặc bỏ qua tuỳ ý
            print("Lỗi gửi email process:", e)

        return Response({'status': 'completed'}, status=status.HTTP_200_OK)

    @action(detail=True, methods=['post'], url_path='reject')
    def reject(self, request, pk=None):

        ret = self.get_object()
        if ret.return_status != 'pending':
            return Response(
                {'detail': 'Thủ tục hoàn vé đã được xử lý.'},
                status=status.HTTP_400_BAD_REQUEST
            )
    
        # validate và lấy data
        serializer = EmployeeRejectTicketReturnSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        # gán lại các trường từ data
        ret.return_status   = 'rejected'
        ret.processed_time  = timezone.now()
        ret.employee        = data['employee']
        ret.note            = data['note']
        ret.save()

        # --- Gửi email thông báo từ chối ---
        customer = ret.detail.order.user
        # --- LẤY THÔNG TIN VÉ ---
        od: OrderDetail = ret.detail
        section_name = od.pricing.section.section_name if od.pricing.section else '–'
        seat_code    = od.seat.seat_number if od.seat else '–'
        match        = od.pricing.match
        match_desc   = match.description
        match_time   = match.match_time.strftime('%d-%m-%Y %H:%M')

        # --- XÂY DỰNG NỘI DUNG EMAIL TỪ CHỐI ---
        subject = f"[Hoàn vé] Yêu cầu #{ret.return_id} đã BỊ TỪ CHỐI"
        message = (
            f"Chào {ret.detail.order.user.full_name},\n\n"
            f"Yêu cầu hoàn vé của bạn đã **bị từ chối**.\n"
            f"Lý do: {ret.note}\n\n"
            f"— Thông tin vé:\n"
            f"   • Mã đơn: {ret.detail.order.order_id}\n"
            f"   • Mã vé: {od.detail_id}\n"
            f"   • Giải đấu / Trận: {match.league.league_name} / {match_desc}\n"
            f"   • Thời gian: {match_time}\n"
            f"   • Khu vực: {section_name}\n"
            f"   • Ghế: {seat_code}\n\n"
            f"Xin liên hệ bộ phận hỗ trợ nếu bạn cần thêm thông tin.\n"
        )
        try:
            send_mail(
                subject,
                message,
                settings.DEFAULT_FROM_EMAIL,
                [customer.email],
                fail_silently=False,
            )
        except Exception as e:
            print("Lỗi gửi email reject:", e)

        return Response({'status': 'rejected'}, status=200)
