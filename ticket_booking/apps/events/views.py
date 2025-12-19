from django.shortcuts import render, get_list_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Match
from .serializers import MatchSerializer
from .serializers import MatchCreateSerializer
from .models import Team
from .models import League
from .models import Stadium, League, Team
from .serializers import StadiumSerializerMatch, LeagueSerializerMatch, TeamSerializerMatch
# from .serializers import StadiumSerializerMatch, LeagueSerializerMatch, TeamSerializerMatch
from .serializers import SectionSerializer
from rest_framework import viewsets
from .models import League
from .serializers import LeagueSerializer

from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework import status
from .models import League
from .serializers import LeagueSerializer

class LeagueViewSet(viewsets.ModelViewSet):
    queryset = League.objects.all()
    serializer_class = LeagueSerializer

    def get_queryset(self):
        qs = League.objects.all().order_by('start_date')
        sport_id = self.request.query_params.get('sport_id')
        sport_name = self.request.query_params.get('sport_name')
        if sport_id:
            try:
                qs = qs.filter(sport__sport_id=int(sport_id))
            except ValueError:
                pass
        if sport_name:
            qs = qs.filter(sport__sport_name__iexact=sport_name)
        return qs

    # Tùy chỉnh action PUT (Cập nhật)
    def update(self, request, *args, **kwargs):
        league = self.get_object()  # Lấy đối tượng league cần cập nhật
        serializer = self.get_serializer(league, data=request.data, partial=False)  # Dữ liệu được truyền từ request

        # Kiểm tra tính hợp lệ của dữ liệu đầu vào
        if serializer.is_valid():
            serializer.save()  # Lưu lại đối tượng đã được cập nhật
            return Response(serializer.data)  # Trả về dữ liệu đã được cập nhật dưới dạng JSON
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)  # Trả về lỗi nếu dữ liệu không hợp lệ
    def destroy(self, request, *args, **kwargs):
        league = self.get_object()

        # Kiểm tra xem giải đấu đã có trận đấu nào chưa
        if league.match_set.exists():  # hoặc league.matches.all().exists() nếu bạn đặt related_name
            raise ValidationError({'error': 'Không thể xóa giải đấu này vì đã có trận đấu được tổ chức.'})
        league.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
# lấy ds các trận 
class MatchListAPIView(APIView):
    def get(self, request):
        matches = Match.objects.all().order_by('match_time')
        serializer = MatchSerializer(matches, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
# update trận
from rest_framework import generics
from .models import Match
from .serializers import MatchSerializer, MatchUpdateSerializer
from apps.tickets.models import SectionPrice
from apps.promotions.models import PromotionDetail

from rest_framework import status
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError

class MatchDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Match.objects.all()
    lookup_field = 'match_id'

    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return MatchUpdateSerializer
        return MatchSerializer

    
    def delete(self, request, *args, **kwargs):
        match = self.get_object()
        try:
            self.perform_destroy(match)
        except ValidationError as e:
            # Lấy chuỗi đầu tiên trong danh sách lỗi nếu có
            message = e.detail[0] if isinstance(e.detail, list) else str(e.detail)
            return Response({'error': message}, status=status.HTTP_400_BAD_REQUEST)
        return Response(status=status.HTTP_204_NO_CONTENT)

    def perform_destroy(self, instance):
        # Kiểm tra xem trận đấu có vé đã bán (tức có record trong SectionPrice)
        if SectionPrice.objects.filter(match=instance).exists():
            raise ValidationError('Không thể xóa trận đấu vì đã tổ chức bán vé.')

        # Kiểm tra xem trận đấu có tồn tại trong PromotionDetail hay không
        if PromotionDetail.objects.filter(match=instance).exists():
            raise ValidationError('Không thể xóa trận đấu vì đã có trong khuyến mãi.')

        # Nếu không có vé và không có trong PromotionDetail, thực hiện xóa trận đấu
        instance.delete()


# tạo trận mới
class MatchCreateAPIView(APIView):
    def post(self, request):
        serializer = MatchCreateSerializer(data=request.data)
        
        # is_valid() sẽ tự động gọi hàm validate() ở trên
        if serializer.is_valid():
            # Lưu vào DB
            match = serializer.save()
            
            return Response({
                "status": "success",
                "message": "Tạo trận đấu thành công!",
                "data": serializer.data
            }, status=status.HTTP_201_CREATED)
            
        # Nếu lỗi, trả về chi tiết lỗi (do validate hoặc do sai ID)
        return Response({
            "status": "error",
            "message": "Dữ liệu không hợp lệ",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)
# check trận đấu hôm nay
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime
from .models import Match

class CheckMatchTodayAPIView(APIView):
    def get(self, request):
        stadium_id = request.query_params.get('stadium_id')
        match_date_str = request.query_params.get('match_date')

        if not stadium_id or not match_date_str:
            return Response({
                "status": "error",
                "message": "Missing stadium_id or match_date"
            }, status=status.HTTP_400_BAD_REQUEST)

        try:
            match_date = datetime.fromisoformat(match_date_str)
        except ValueError:
            return Response({
                "status": "error",
                "message": "Invalid match_date format"
            }, status=status.HTTP_400_BAD_REQUEST)

        start_of_day = match_date.replace(hour=0, minute=0, second=0, microsecond=0)
        end_of_day = match_date.replace(hour=23, minute=59, second=59, microsecond=999999)

        exists = Match.objects.filter(
            stadium_id=stadium_id,
            match_time__range=(start_of_day, end_of_day)
        ).exists()

        if exists:
            return Response({
                "status": "error",
                "message": "Đã có trận đấu trên sân trong hôm nay"
            }, status=status.HTTP_200_OK)
        else:
            return Response({
                "status": "success",
                "message": "Sân trống trong hôm nay"
            }, status=status.HTTP_200_OK)

# lấy team,giải,stadium       
class StadiumListAPIView(APIView):
    def get(self, request):
        stadiums = Stadium.objects.all()
        serializer = StadiumSerializerMatch(stadiums, many=True)
        return Response({
            "status": "success",
            "data": serializer.data
        }, status=status.HTTP_200_OK)
    
class LeagueListAPIView(APIView):
    def get(self, request):
        leagues = League.objects.all()
        serializer = LeagueSerializerMatch(leagues, many=True)
        return Response({
            "status": "success",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

class TeamListAPIView(APIView):
    def get(self, request):
        teams = Team.objects.all()
        serializer = TeamSerializerMatch(teams, many=True)
        return Response({
            "status": "success",
            "data": serializer.data
        }, status=status.HTTP_200_OK)
# UPDATE TEAM GIẢI STADIUM
# from rest_framework import viewsets
# from rest_framework.permissions import AllowAny
# from .models import Stadium
# from .serializers import StadiumSerializer
# class StadiumViewSet(viewsets.ModelViewSet):
#     queryset = Stadium.objects.all()
#     serializer_class = StadiumSerializer
#     permission_classes = [AllowAny]
#     lookup_field = 'stadium_id'

# from rest_framework import generics
# from rest_framework.response import Response
# from rest_framework import status
# from .models import Stadium
# from .serializers import StadiumSerializer
# # from .serializers import TeamSerializer
# from .models import League
# from .serializers import LeagueSerializer
# class StadiumDetailView(generics.RetrieveUpdateDestroyAPIView):
#     queryset = Stadium.objects.all()
#     serializer_class = StadiumSerializer
#     lookup_field = 'stadium_id'
    

# class TeamDetailView(generics.RetrieveUpdateDestroyAPIView):
#     queryset = Team.objects.all()
#     serializer_class = TeamSerializer
#     lookup_field = 'team_id'

#     def patch(self, request, *args, **kwargs):
#         request.data._mutable = True  # nếu dùng QueryDict
#         request.data.pop('logo', None)  # không cho cập nhật logo
#         return self.partial_update(request, *args, **kwargs)

#     def put(self, request, *args, **kwargs):
#         request.data._mutable = True
#         request.data.pop('logo', None)
#         return self.update(request, *args, **kwargs)

# teamupdate
from django.db.models import Q
from rest_framework import status
from rest_framework.response import Response
from rest_framework import viewsets
from .models import Team
from .serializers import TeamSerializerView, TeamUpdateSerializer
from .models import Match

from .serializers import TeamSerializerView, TeamCreateUpdateSerializer 

class TeamViewSet(viewsets.ModelViewSet):
    queryset = Team.objects.all()

    def get_queryset(self):
        qs = Team.objects.all().order_by('team_name')
        sport_id = self.request.query_params.get('sport_id')
        sport_name = self.request.query_params.get('sport_name')
        if sport_id:
            try:
                qs = qs.filter(sport__sport_id=int(sport_id))
            except ValueError:
                # ignore invalid sport_id
                pass
        if sport_name:
            qs = qs.filter(sport__sport_name__iexact=sport_name)
        return qs

    def get_serializer_class(self):
        # Dùng serializer ghi cho các hành động 'create', 'update', 'partial_update'
        if self.action in ['create', 'update', 'partial_update']:
            # Đảm bảo bạn đã đổi tên TeamUpdateSerializer thành TeamCreateUpdateSerializer
            return TeamCreateUpdateSerializer 
        
        # Dùng serializer xem cho tất cả các hành động còn lại (list, retrieve)
        return TeamSerializerView

    def get_serializer_context(self):
        # Đảm bảo 'request' luôn được truyền vào context cho get_logo
        return {'request': self.request}

    def destroy(self, request, *args, **kwargs):
        team = self.get_object()

        # Kiểm tra nếu đội đã từng tham gia bất kỳ trận đấu nào
        if Match.objects.filter(Q(team_1=team) | Q(team_2=team)).exists():
            return Response({
                "status": "error",
                "message": "Không thể xóa đội bóng vì đội đã tham gia thi đấu."
            }, status=status.HTTP_400_BAD_REQUEST)

        return super().destroy(request, *args, **kwargs)





# class LeagueDetailView(generics.RetrieveUpdateDestroyAPIView):
#     queryset = League.objects.all()
#     serializer_class = LeagueSerializer
#     lookup_field = 'league_id'

#     def patch(self, request, *args, **kwargs):
#         request.data._mutable = True
#         request.data.pop('created_at', None)
#         # request.data.pop('updated_at', None)
#         return self.partial_update(request, *args, **kwargs)

#     def put(self, request, *args, **kwargs):
#         request.data._mutable = True
#         request.data.pop('created_at', None)
#         # request.data.pop('updated_at', None)
#         return self.update(request, *args, **kwargs)

# show view events
# from .serializers import TeamSerializerView, StadiumSerializerView
# from rest_framework.generics import ListAPIView
# class TeamListAPIShowView(ListAPIView):
#     queryset = Team.objects.all()
#     serializer_class = TeamSerializerView

# class LeagueListAPIShowView(ListAPIView):
#     queryset = League.objects.all()
#     serializer_class = LeagueSerializerView

# views.py
# views.py
from rest_framework.exceptions import ValidationError

from rest_framework import status, viewsets
from rest_framework.response import Response
from .models import Stadium
from .serializers import StadiumSerializerView, StadiumUpdateSerializer

class StadiumViewSet(viewsets.ModelViewSet):
    queryset = Stadium.objects.all()

    def get_queryset(self):
        qs = Stadium.objects.all().order_by('stadium_name')
        sport_id = self.request.query_params.get('sport_id')
        sport_name = self.request.query_params.get('sport_name')
        if sport_id:
            try:
                qs = qs.filter(match__league__sport__sport_id=int(sport_id)).distinct()
            except ValueError:
                pass
        if sport_name:
            qs = qs.filter(match__league__sport__sport_name__iexact=sport_name).distinct()
        return qs

    def get_serializer_class(self):
        if self.action in ['update', 'partial_update']:
            return StadiumUpdateSerializer
        return StadiumSerializerView

    def destroy(self, request, *args, **kwargs):
        stadium = self.get_object()

        # Kiểm tra xem sân có trận đấu nào chưa
        if stadium.match_set.exists():
            raise ValidationError({'error': 'Không thể xóa sân này vì đã có trận đấu được tổ chức ở đây.'})
        # Xóa seats và sections
        for section in stadium.section_set.all():
            section.seat_set.all().delete()
            section.delete()

        stadium.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)




# tạo sân ko sectionsection


# from .serializers import StadiumSerializerView

# class StadiumCreateAPIView(generics.CreateAPIView):
#     queryset = Stadium.objects.all()
#     serializer_class = StadiumSerializerView



# tạo sân có section
# from rest_framework import mixins, generics
# from .models import Stadium
# from .serializers import StadiumSerializerView

# class StadiumListCreateAPIView(mixins.ListModelMixin,
#                                 mixins.CreateModelMixin,
#                                 generics.GenericAPIView):
#     queryset = Stadium.objects.all()
#     serializer_class = StadiumSerializerView

#     def get(self, request, *args, **kwargs):
#         return self.list(request, *args, **kwargs)

#     def post(self, request, *args, **kwargs):
#         return self.create(request, *args, **kwargs)

# lấy section theo id sânsân
from apps.tickets.models import Section

class StadiumSectionsView(APIView):
    def get(self, request, stadium_id):
        try:
            stadium = Stadium.objects.get(pk=stadium_id)
        except Stadium.DoesNotExist:
            return Response({"detail": "Stadium not found."}, status=status.HTTP_404_NOT_FOUND)

        sections = Section.objects.filter(stadium=stadium)
        serializer = SectionSerializer(sections, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
# lấy ghế theo sec và sân
from rest_framework.views import APIView
from apps.tickets.models import Seat, Section
from .serializers import SeatDetailSerializer

class SectionSeatsView(APIView):
    def get(self, request, stadium_id, section_id):
        try:
            stadium = Stadium.objects.get(pk=stadium_id)
        except Stadium.DoesNotExist:
            return Response({"detail": "Stadium not found."}, status=status.HTTP_404_NOT_FOUND)

        try:
            section = Section.objects.get(pk=section_id, stadium=stadium)
        except Section.DoesNotExist:
            return Response({"detail": "Section not found in this stadium."}, status=status.HTTP_404_NOT_FOUND)

        seats = Seat.objects.filter(section=section)
        serializer = SeatDetailSerializer(seats, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
# thêm section cho sân
from rest_framework import generics
from .models import Stadium
from .serializers import SectionCreateSerializer
from rest_framework.response import Response
from rest_framework import status
from django.db import IntegrityError  # Thêm import này
from apps.tickets.models import Section, Seat
from apps.orders.models import OrderDetail

class StadiumSectionCreateAPIView(APIView):
    def post(self, request, stadium_id):
        try:
            stadium = Stadium.objects.get(pk=stadium_id)
        except Stadium.DoesNotExist:
            return Response({"detail": "Stadium not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = SectionCreateSerializer(data=request.data, context={'stadium': stadium})
        if serializer.is_valid():
            try:
                section = serializer.save()

                # Tạo Seat cho section
                for seat_number in range(1, section.capacity + 1):
                    seat_code = f"{stadium.stadium_code}-{section.section_name}-{str(seat_number).zfill(3)}"
                    if not Seat.objects.filter(seat_code=seat_code).exists():
                        Seat.objects.create(
                            seat_code=seat_code,
                            seat_number=str(seat_number).zfill(3),
                            status=0,
                            section=section
                        )

                return Response({"detail": "Section and Seats created successfully."}, status=status.HTTP_201_CREATED)

            except IntegrityError as e:
                if 'unique_stadium_section_name' in str(e):
                    return Response(
                        {"section_name": ["Tên khu vực đã tồn tại trong sân vận động này."]},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                return Response({"detail": "Lỗi cơ sở dữ liệu."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
# UPDATE SECTION THEO ID
# from rest_framework import status
# from rest_framework.response import Response
# from rest_framework.views import APIView
# from apps.tickets.models import Section, Seat
# from apps.events.serializers import SectionSerializerUpdate
# from apps.events.models import Stadium

# class SectionUpdateAPIView(APIView):
#     def put(self, request, stadium_id, section_id):
#         try:
#             stadium = Stadium.objects.get(pk=stadium_id)
#         except Stadium.DoesNotExist:
#             return Response({"detail": "Stadium not found."}, status=status.HTTP_404_NOT_FOUND)

#         try:
#             section = Section.objects.get(pk=section_id, stadium=stadium)
#         except Section.DoesNotExist:
#             return Response({"detail": "Section not found."}, status=status.HTTP_404_NOT_FOUND)

#         # Serializer để validate dữ liệu mới
#         serializer = SectionSerializerUpdate(section, data=request.data, partial=True)  # Chỉ cập nhật trường có trong request
#         if serializer.is_valid():
#             # Cập nhật section
#             updated_section = serializer.save()

#             # Reset lại seats nếu có thay đổi sức chứa
#             if 'capacity' in request.data:  # Chỉ reset seats khi có thay đổi capacity
#                 # Xóa tất cả các seats hiện tại trong section này
#                 Seat.objects.filter(section=updated_section).delete()

#                 # Tạo lại seats với số lượng theo capacity mới
#                 for seat_number in range(1, updated_section.capacity + 1):
#                     seat_code = f"{stadium.stadium_code}-{updated_section.section_name}-{str(seat_number).zfill(3)}"
#                     Seat.objects.create(
#                         seat_code=seat_code,
#                         seat_number=str(seat_number).zfill(3),
#                         status=0,
#                         section=updated_section
#                     )

#             return Response({"detail": "Section updated and seats reset successfully."}, status=status.HTTP_200_OK)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from apps.tickets.models import Section, Seat
from .serializers import SectionSerializerUpdate
from apps.orders.models import OrderDetail
from .models import Stadium

class SectionUpdateAPIView(APIView):
    def put(self, request, stadium_id, section_id):
        try:
            stadium = Stadium.objects.get(pk=stadium_id)
        except Stadium.DoesNotExist:
            return Response({"detail": "Stadium not found."}, status=status.HTTP_404_NOT_FOUND)

        try:
            section = Section.objects.get(pk=section_id, stadium=stadium)
        except Section.DoesNotExist:
            return Response({"detail": "Section not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = SectionSerializerUpdate(section, data=request.data, partial=True)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        new_capacity = request.data.get("capacity")
        if new_capacity is not None:
            new_capacity = int(new_capacity)
            current_capacity = section.capacity

            # Lấy tất cả ghế trong section hiện tại
            all_seats = Seat.objects.filter(section=section).order_by("seat_number")
            all_seat_ids = list(all_seats.values_list("seat_id", flat=True))

            # Lấy danh sách các ghế đã bán trong section này (không trùng lặp)
            sold_seat_ids = list(
                OrderDetail.objects.filter(seat__section=section, seat__isnull=False)
                .values_list("seat_id", flat=True)
                .distinct()  # Đảm bảo chỉ tính các ghế đã bán duy nhất
            )
            sold_count = len(sold_seat_ids)

            # Nếu capacity mới nhỏ hơn số ghế đã bán, không cho giảm
            if new_capacity < sold_count:
                return Response({
                    "detail": f"Không thể giảm capacity xuống {new_capacity} vì đã bán {sold_count} ghế."
                }, status=status.HTTP_400_BAD_REQUEST)

            # Nếu capacity mới nhỏ hơn capacity hiện tại
            if new_capacity < current_capacity:
                to_remove_count = current_capacity - new_capacity
                # Ghế chưa bán trong section hiện tại
                unsold_seats = all_seats.exclude(seat_id__in=sold_seat_ids).order_by("-seat_number")

                if unsold_seats.count() < to_remove_count:
                    return Response({
                        "detail": f"Chỉ có {unsold_seats.count()} ghế chưa bán, không thể giảm capacity thêm nữa."
                    }, status=status.HTTP_400_BAD_REQUEST)

                # Lấy ID của ghế chưa bán
                seats_to_delete_ids = list(unsold_seats[:to_remove_count].values_list('seat_id', flat=True))  # Sử dụng 'seat_id' thay vì 'id'

                # Xóa các ghế chưa bán
                Seat.objects.filter(seat_id__in=seats_to_delete_ids).delete()  # Sử dụng 'seat_id' thay vì 'id'



            # Nếu capacity mới lớn hơn capacity hiện tại, tạo thêm ghế
            elif new_capacity > current_capacity:
                for seat_number in range(current_capacity + 1, new_capacity + 1):
                    seat_code = f"{stadium.stadium_code}-{section.section_name}-{str(seat_number).zfill(3)}"
                    Seat.objects.create(
                        seat_code=seat_code,
                        seat_number=str(seat_number).zfill(3),
                        section=section,
                        status=0
                    )

        # Lưu và cập nhật section
        serializer.save()

        return Response({"detail": "Section updated successfully."}, status=status.HTTP_200_OK)



# xóa section
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Stadium
from apps.tickets.models import Seat,Section
from apps.promotions.models import PromotionDetail
from apps.tickets.models import SectionPrice  # Import model SectionPrice

class SectionDeleteAPIView(APIView):
    def delete(self, request, stadium_id, section_id):
        try:
            # Kiểm tra sân tồn tại
            stadium = Stadium.objects.get(pk=stadium_id)
        except Stadium.DoesNotExist:
            return Response({"detail": "Stadium not found."}, status=status.HTTP_404_NOT_FOUND)

        try:
            # Kiểm tra section có trong sân
            section = Section.objects.get(pk=section_id, stadium=stadium)
        except Section.DoesNotExist:
            return Response({"detail": "Section not found."}, status=status.HTTP_404_NOT_FOUND)

        # Kiểm tra xem có vé nào đã được tạo trong Section này
        section_price_exists = SectionPrice.objects.filter(section=section).exists()
        if section_price_exists:
            return Response({
                "detail": "Không thể xóa khu vực vì đã tạo vé cho khu vực này."
            }, status=status.HTTP_400_BAD_REQUEST)

        # Kiểm tra xem có ghế nào trong section đã được bán chưa (ưu tiên kiểm tra lỗi này)
        sold_exists = OrderDetail.objects.filter(seat__section=section).exists()
        if sold_exists:
            return Response({
                "detail": "Không thể xóa khu vực vì đã có ghế từng được bán."
            }, status=status.HTTP_400_BAD_REQUEST)

        # Kiểm tra xem section có được áp dụng trong PromotionDetail không
        promotion_detail_exists = PromotionDetail.objects.filter(section=section).exists()
        if promotion_detail_exists:
            return Response({
                "detail": "Không thể xóa khu vực vì đã áp dụng khuyến mãi!"
            }, status=status.HTTP_400_BAD_REQUEST)

        # Xóa toàn bộ ghế của section
        Seat.objects.filter(section=section).delete()

        # Xóa section
        section.delete()

        return Response({"detail": "Section and its seats deleted successfully."}, status=status.HTTP_204_NO_CONTENT)

# upload ảnh logo team
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Team

class UploadTeamLogoView(APIView):
    def post(self, request, team_id):
        try:
            team = Team.objects.get(pk=team_id)
        except Team.DoesNotExist:
            return Response({"error": "Team không tồn tại."}, status=status.HTTP_404_NOT_FOUND)

        logo = request.FILES.get('logo')
        if not logo:
            return Response({"error": "Vui lòng gửi file ảnh logo."}, status=status.HTTP_400_BAD_REQUEST)

        team.logo = logo
        team.save()

        return Response({
            "message": "Upload logo thành công.",
            "logo_url": request.build_absolute_uri(team.logo.url)
        }, status=status.HTTP_200_OK)
# upload sta
# events/views.py



# from .serializers import StadiumLayoutUploadSerializer

# class UploadStadiumLayoutView(APIView):
#     def patch(self, request, stadium_id):
#         try:
#             stadium = Stadium.objects.get(pk=stadium_id)
#         except Stadium.DoesNotExist:
#             return Response({'error': 'Stadium not found'}, status=status.HTTP_404_NOT_FOUND)

#         serializer = StadiumLayoutUploadSerializer(stadium, data=request.data, partial=True)
#         if serializer.is_valid():
#             serializer.save()
#             return Response({'message': 'Upload thành công', 'stadium_layouts': serializer.data['stadium_layouts']}, status=status.HTTP_200_OK)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Stadium

class UploadStadiumLayoutView(APIView):
    def post(self, request, stadium_id):
        try:
            stadium = Stadium.objects.get(pk=stadium_id)
        except Stadium.DoesNotExist:
            return Response({"error": "Stadium không tồn tại."}, status=status.HTTP_404_NOT_FOUND)

        stadium_layouts = request.FILES.get('stadium_layouts')
        if not stadium_layouts:
            return Response({"error": "Vui lòng gửi file ảnh stadium_layouts."}, status=status.HTTP_400_BAD_REQUEST)

        stadium.stadium_layouts = stadium_layouts
        stadium.save()

        return Response({
            "message": "Upload stadium_layouts thành công.",
            "stadium_layouts_url": request.build_absolute_uri(stadium.stadium_layouts.url)
        }, status=status.HTTP_200_OK)
# thay đổi trận đấu với lịch sử
# views.py (app events)
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from django.utils.timezone import now, is_naive, make_aware
from django.utils.dateparse import parse_datetime
from django.forms.models import model_to_dict
from .models import Match, MatchHistory
from .serializers import MatchPartialUpdateSerializer
from apps.tickets.models import SectionPrice
from apps.accounts.models import Employee

from datetime import datetime
from django.core.mail import send_mail
from django.conf import settings
class MatchUpdateWithHistoryAPIView(APIView):
    permission_classes = [AllowAny]
    def stringify_datetimes(self, data_dict):
        """Chuyển datetime về chuỗi để lưu JSONField."""
        for key, value in data_dict.items():
            if isinstance(value, datetime):
                data_dict[key] = value.strftime('%Y-%m-%d %H:%M:%S')
        return data_dict
    def put(self, request, match_id):
        try:
            match = Match.objects.get(pk=match_id)
        except Match.DoesNotExist:
            return Response({"detail": "Match not found."}, status=status.HTTP_404_NOT_FOUND)

        # Đảm bảo match_time là timezone-aware
        if is_naive(match.match_time):
            match_time_aware = make_aware(match.match_time)
        else:
            match_time_aware = match.match_time
        if match_time_aware <= now():
            return Response({"detail": "Cannot update a match that already happened."}, status=status.HTTP_400_BAD_REQUEST)
        if not SectionPrice.objects.filter(match=match, is_closed=False).exists():
            return Response({"detail": "Match is not currently on sale."}, status=status.HTTP_400_BAD_REQUEST)
        allowed_fields = ['match_time', 'description']
        update_data = {
            field: value for field, value in request.data.items()
            if field in allowed_fields
        }
        if not update_data:
            return Response({"detail": "Only 'match_time' and 'description' can be updated."}, status=status.HTTP_400_BAD_REQUEST)
        # Chuyển đổi match_time nếu có
        if 'match_time' in update_data:
            parsed_time = parse_datetime(update_data['match_time'])
            if not parsed_time:
                return Response({"detail": "Invalid datetime format for match_time."}, status=status.HTTP_400_BAD_REQUEST)
            if is_naive(parsed_time):
                parsed_time = make_aware(parsed_time)
            update_data['match_time'] = parsed_time
        # Lưu dữ liệu cũ
        old_data = self.stringify_datetimes(model_to_dict(match, fields=allowed_fields))
        # Cập nhật
        serializer = MatchPartialUpdateSerializer(match, data=update_data, partial=True)
        if serializer.is_valid():
            serializer.save()
            new_data = {field: getattr(match, field) for field in allowed_fields}
            new_data = self.stringify_datetimes(new_data)
            try:
                employee = request.user.employee
            except Exception:
                employee = Employee.objects.first()  # fallback (test)
            MatchHistory.objects.create(
                match=match,
                employee=employee,
                change_type='update',
                old_value=old_data,
                new_value=new_data,
                reason=request.data.get('reason', 'Cập nhật thông tin trận đấu')
            )
            # 11. Gửi email thông báo đến tất cả khách đã mua vé
            tickets = SectionPrice.objects.filter(match=match)
            emails = tickets.values_list('order_details__order__user__email', flat=True).distinct()

            subject = f"[Thông Báo] Cập Nhật Thông Tin Trận Đấu: {match}"
            message = (
                f"**Kính gửi Quý khách,**\n\n"
                f"Chúng tôi xin thông báo về việc cập nhật thông tin trận đấu **'{match}'** mà quý khách đang quan tâm.\n\n"
                f"Dưới đây là các thông tin chi tiết về sự thay đổi:\n\n"
                
                f"**1. Thông tin cũ:**\n"
                f"- **Thời gian:** {old_data.get('match_time')}\n"
                f"- **Mô tả:** {old_data.get('description')}\n\n"
                
                f"**2. Thông tin mới:**\n"
                f"- **Thời gian:** {new_data.get('match_time')}\n"
                f"- **Mô tả:** {new_data.get('description')}\n\n"

                f"Chúng tôi xin lưu ý và mong quý khách điều chỉnh lại lịch trình của mình theo thông tin mới.\n\n"
                f"Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi. Chúng tôi luôn sẵn sàng hỗ trợ quý khách.\n\n"
                f"**Trân trọng,**\n"
                f"**Đội ngũ GoalTix**"
            )

            for addr in emails:
                send_mail(
                    subject,
                    message,
                    settings.DEFAULT_FROM_EMAIL,
                    [addr],
                    fail_silently=True,
                )
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
# lịch sử trận
# views.py
from rest_framework.generics import ListAPIView
from .models import MatchHistory
from .serializers import MatchHistorySerializer  # Sẽ tạo ở bước dưới

class MatchHistoryListAPIView(ListAPIView):
    queryset = MatchHistory.objects.select_related('match', 'employee').all()
    serializer_class = MatchHistorySerializer



from .serializers import TeamSerializerView, TeamCreateUpdateSerializer, SportSerializer
from .models import  Sport
class SportViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = [AllowAny]

    """
    API endpoint này chỉ cho phép LẤY (GET) danh sách các môn thể thao.
    """
    queryset = Sport.objects.all().order_by('sport_name') # Lấy tất cả, sắp xếp theo tên
    serializer_class = SportSerializer
    