
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


# AI TẠO PROMOTION
import joblib
import os
import numpy as np
from datetime import datetime
from django.conf import settings
from django.db.models import Sum, Avg
from rest_framework.views import APIView
from rest_framework.response import Response
from apps.events.models import Match
from apps.tickets.models import SectionPrice
from apps.orders.models import OrderDetail
class AnalyzePromotionEffectivenessView(APIView):
    """
    API Phân tích Khuyến mãi dựa trên Tình trạng ghế trống (Inventory).
    Input: { "match_id": 123 }
    Output: Gợi ý mức % giảm giá tốt nhất để xả hàng tồn.
    """
    def post(self, request):
        match_id = request.data.get('match_id')
        if not match_id:
            return Response({"error": "Thiếu match_id"}, status=400)

        try:
            # 1. LẤY DỮ LIỆU THỰC TẾ (REAL-TIME DATA)
            match = Match.objects.get(pk=match_id)
            
            # Tính tổng sức chứa & Số ghế đã bán
            # (Logic lấy từ SectionPrice và OrderDetail)
            capacity_data = SectionPrice.objects.filter(match=match).aggregate(
                total_cap=Sum('section__capacity'),
                total_available=Sum('available_seats'),
                avg_price=Avg('price')
            )
            
            total_capacity = capacity_data['total_cap'] or 0
            current_available = capacity_data['total_available'] or 0
            current_price = float(capacity_data['avg_price'] or 0)
            
            if total_capacity == 0:
                return Response({"error": "Trận này chưa tạo vé (Capacity=0)"}, status=400)

            current_sold = total_capacity - current_available
            fill_rate_now = (current_sold / total_capacity) * 100

            # Nếu đã bán gần hết (>90%) thì không cần Promotion
            if fill_rate_now > 90:
                return Response({
                    "status": "warning",
                    "message": f"Trận này đã bán được {fill_rate_now:.1f}%. Không cần khuyến mãi thêm."
                })

            # 2. CHUẨN BỊ AI MODEL
            model_path = os.path.join(settings.BASE_DIR, 'ml_models', 'price_optimization_model.pkl')
            model = joblib.load(model_path)

            day = match.match_time.weekday()
            hour = match.match_time.hour
            is_hot = 1 if match.is_hot_match else 0
            importance = match.importance

            # 3. GIẢ LẬP CÁC MỨC KHUYẾN MÃI (SCENARIOS)
            # Chỉ xét giảm giá (Promotion) vì mục tiêu là lấp đầy ghế trống
            discounts = [0, 10, 15, 20, 25, 30, 40, 50] 
            
            best_option = None
            max_extra_revenue = -1
            analysis = []

            for pct in discounts:
                # Giá sau khi giảm
                promo_price = current_price * (1 - pct / 100)
                
                # Hỏi AI: "Với giá này, tổng thị trường mua được bao nhiêu?"
                features = np.array([[day, hour, is_hot, importance, promo_price]])
                predicted_total_demand = int(model.predict(features)[0])
                
                # Logic quan trọng: Tính số khách MỚI tiềm năng
                # Khách mới = Nhu cầu tổng - Khách đã mua
                potential_new_buyers = predicted_total_demand - current_sold
                
                if potential_new_buyers <= 0:
                    potential_new_buyers = 0 # Giá này không hấp dẫn thêm ai cả
                
                # Không thể bán quá số ghế còn lại
                sales_volume = min(potential_new_buyers, current_available)
                
                # Doanh thu bán thêm (Incremental Revenue)
                extra_revenue = sales_volume * promo_price
                
                # Tỷ lệ lấp đầy dự kiến sau KM
                new_fill_rate = ((current_sold + sales_volume) / total_capacity) * 100

                sim_result = {
                    "discount": pct,
                    "promo_price": promo_price,
                    "extra_sold": sales_volume, # Bán thêm được bao nhiêu
                    "extra_revenue": extra_revenue, # Thu thêm được bao nhiêu
                    "final_fill_rate": round(new_fill_rate, 1)
                }
                analysis.append(sim_result)

                # Tìm phương án tối ưu tiền nhất
                if extra_revenue > max_extra_revenue:
                    max_extra_revenue = extra_revenue
                    best_option = sim_result

            # 4. TRẢ KẾT QUẢ
            return Response({
                "status": "success",
                "current_status": {
                    "sold": current_sold,
                    "available": current_available,
                    "fill_rate": round(fill_rate_now, 1),
                    "avg_price": current_price
                },
                "recommendation": {
                    "best_discount": best_option['discount'],
                    "best_price": best_option['promo_price'],
                    "expected_extra_sold": best_option['extra_sold'],
                    "expected_extra_revenue": best_option['extra_revenue'],
                    "expected_final_fill": best_option['final_fill_rate'],
                    "message": self.generate_message(best_option, current_available)
                },
                "analysis_data": analysis # Để vẽ biểu đồ
            })

        except Exception as e:
            import traceback
            traceback.print_exc()
            return Response({"error": str(e)}, status=500)

    def generate_message(self, opt, available):
        if opt['extra_sold'] == 0:
            return "Dù giảm giá cũng khó bán thêm được vé nào (Nhu cầu đã bão hòa)."
        
        fill_percent = (opt['extra_sold'] / available) * 100 if available > 0 else 0
        
        if opt['discount'] == 0:
            return "Nên giữ nguyên giá. Việc giảm giá không mang lại doanh thu cao hơn."
        
        return (f"Nên giảm {opt['discount']}%! "
                f"Dự kiến sẽ 'đẩy' đi được thêm {opt['extra_sold']} vé tồn kho, "
                f"thu về thêm {opt['extra_revenue']:,.0f} VNĐ.")