
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated, IsAdminUser, AllowAny
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter
from .models import Promotion
from apps.orders.models import OrderDetail
from .serializers import PromotionSerializer
from apps.tickets.serializers import SectionSerializer
from apps.tickets.models import Section
from apps.events.models import Match
from django.utils import timezone
from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError
from rest_framework.decorators import action
from rest_framework import status
from rest_framework.views import APIView
from .tasks import set_promotion_status

class PromotionViewSet(viewsets.ModelViewSet):
    """
    API CRUD cho Promotion, có nested PromotionDetail qua 'lines'
    """
    queryset = Promotion.objects.all().order_by('-end_time')
    serializer_class = PromotionSerializer
    permission_classes = [AllowAny]
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['status']
    search_fields = ['promo_code', 'description']

    def list(self, request, *args, **kwargs):
        now = timezone.now()
        # Promotion.objects.filter(status=True, end_time__lt=now).update(status=False)

        return super().list(request, *args, **kwargs)
    
    @action(detail=False, methods=['patch'])
    def bulk_toggle(self, request):
        """
        PATCH /api/promotions/bulk_toggle/
        body: { "ids": [1,2,3], "status": true }
        """
        ids = request.data.get('ids', [])
        new_status = request.data.get('status')

        if not isinstance(ids, list) or new_status is None:
            return Response(
                {'detail': 'ids và status là bắt buộc.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        now = timezone.now()
        qs = Promotion.objects.filter(promo_id__in=ids)
        
        # Kiểm tra xem có promotion nào đã hết hạn không
        expired = qs.filter(end_time__lt=now).values_list('promo_id', flat=True)
        if expired:
            return Response(
                {
                    'detail': 'Không thể thay đổi trạng thái cho các mã đã hết hạn.',
                    'expired_ids': list(expired)
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        updated = qs.update(status=new_status)
        return Response({'updated': updated}, status=status.HTTP_200_OK)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        try:
            result = PromotionSerializer.delete_instance(instance)
            return Response(result, status=status.HTTP_200_OK)
        except ValidationError as e:
            return Response({"detail": e.detail}, status=status.HTTP_400_BAD_REQUEST)
        
    def perform_create(self, serializer):
        promo = serializer.save()
        # Đặt lịch bật vào đúng thời điểm start_time
        set_promotion_status.apply_async(
            args=[promo.promo_id, True],
            eta=promo.start_time
        )
        # Đặt lịch tắt vào đúng thời điểm end_time
        set_promotion_status.apply_async(
            args=[promo.promo_id, False],
            eta=promo.end_time
        )

    def perform_update(self, serializer):
        promo = serializer.save()
        # Nếu admin thay đổi start/end time, hủy/bỏ task cũ (nếu cần),
        # rồi đặt lại lịch mới
        set_promotion_status.apply_async(
            args=[promo.promo_id, True],
            eta=promo.start_time
        )
        set_promotion_status.apply_async(
            args=[promo.promo_id, False],
            eta=promo.end_time
        )
    
    # def update(self, request, *args, **kwargs):
    #     promotion = self.get_object()
        
    #     # Tính số lượng mã đã được sử dụng
    #     used_count = OrderDetail.objects.filter(promotion=promotion).count()
        
    #     if used_count > 0:
    #         # Nếu Promotion đã được sử dụng,
    #         # chỉ cho phép cập nhật các trường: end_time, usage_limit, description.
    #         allowed_fields = {"end_time", "usage_limit", "description"}
    #         disallowed = set(request.data.keys()) - allowed_fields
    #         if disallowed:
    #             return Response(
    #                 {
    #                     "detail": "Promotion đã được sử dụng; chỉ được cập nhật end_time, usage_limit và description.",
    #                     "disallowed_fields": list(disallowed),
    #                 },
    #                 status=status.HTTP_400_BAD_REQUEST,
    #             )
        
    #     return super().update(request, *args, **kwargs)

# Lấy danh sách section theo match
class SectionListAPIView_Promotions(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        match_id = request.query_params.get('match')
        if match_id:
            match = get_object_or_404(Match, pk=match_id)
            sections = Section.objects.filter(stadium=match.stadium)
        else:
            sections = Section.objects.all()

        serializer = SectionSerializer(sections, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
# Lấy danh sách trận đấu
class MatchListAPIView_Promotions(APIView):
    def get(self, request):
        now = timezone.now()
        matches = Match.objects.filter(match_time__gt=now)

        result = [
            {
                "match_id": match.match_id,
                "display": str(match),
                "match_time": match.match_time,
                "match_time_fmt": match.match_time.strftime("%d %b %Y, %H:%M"),
                "stadium_id": match.stadium_id
            }
            for match in matches
        ]

        return Response(result, status=status.HTTP_200_OK)


