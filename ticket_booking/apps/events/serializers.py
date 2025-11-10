from rest_framework import serializers
from .models import Match, Stadium, League, Team
from apps.tickets.models import Section
# lấy ds các trận 
class MatchSerializer(serializers.ModelSerializer):
    team_1_name = serializers.CharField(source='team_1.team_name', read_only=True)
    team_2_name = serializers.CharField(source='team_2.team_name', read_only=True)
    stadium_name = serializers.CharField(source='stadium.stadium_name', read_only=True)
    league_name = serializers.CharField(source='league.league_name', read_only=True)
    ticket_status = serializers.SerializerMethodField()

    class Meta:
        model = Match
        fields = [
            'match_id',
            'match_time',
            'description',
            'round',
            'team_1_name',
            'team_2_name',
            'stadium_name',
            'league_name',
            'ticket_status',
        ]

    def get_ticket_status(self, obj):
        section_prices = obj.tickets.all()  # related_name='tickets' trong SectionPrice

        if not section_prices.exists():
            return 2  # chưa tạo vé

        if section_prices.filter(is_closed=False).exists() or section_prices.filter(available_seats=0).count() == section_prices.count():
            return 0

        return 1  # tất cả đều đang đóng, sắp bán

# UPDATE TRẬN ĐẤU
class MatchUpdateSerializer(serializers.ModelSerializer):
    stadium_name = serializers.CharField(write_only=True)

    class Meta:
        model = Match
        fields = [
            'match_time',
            'description',
            'stadium_name',
        ]

    def validate(self, data):
        # Tra stadium từ tên
        try:
            data['stadium'] = Stadium.objects.get(stadium_name=data.pop('stadium_name'))
        except Stadium.DoesNotExist:
            raise serializers.ValidationError({'stadium_name': 'Sân vận động không tồn tại.'})
        return data
# tạo traạn mới

class MatchCreateSerializer(serializers.ModelSerializer):
    match_date = serializers.DateTimeField(write_only=True)
    stadium_id = serializers.IntegerField(write_only=True)
    league = serializers.CharField(write_only=True)
    team_1 = serializers.IntegerField(write_only=True)
    team_2 = serializers.IntegerField(write_only=True)

    class Meta:
        model = Match
        fields = [
            'match_date',
            'description',
            'stadium_id',
            'league',
            'round',
            'team_1',
            'team_2'
        ]

    def create(self, validated_data):
        stadium = Stadium.objects.get(pk=validated_data['stadium_id'])
        league = League.objects.get(league_name=validated_data['league'])
        team1 = Team.objects.get(pk=validated_data['team_1'])
        team2 = Team.objects.get(pk=validated_data['team_2'])

        match = Match.objects.create(
            match_time=validated_data['match_date'],
            description=validated_data['description'],
            stadium=stadium,
            league=league,
            round=validated_data['round'],
            team_1=team1,
            team_2=team2
        )
        return match

# danh sách sân,giải,đội để tạo trận
class StadiumSerializerMatch(serializers.ModelSerializer):
    class Meta:
        model = Stadium
        fields = ['stadium_id', 'stadium_name']

class LeagueSerializerMatch(serializers.ModelSerializer):
    class Meta:
        model = League
        fields = ['league_id', 'league_name','league_type']

class TeamSerializerMatch(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ['team_id', 'team_name']
# lấy ds sân,giải,đội show view
from rest_framework import serializers
from .models import Team

class TeamSerializerView(serializers.ModelSerializer):
    logo = serializers.SerializerMethodField()

    class Meta:
        model = Team
        fields = ['team_id', 'team_name', 'logo', 'head_coach', 'description']

    def get_logo(self, obj):
        request = self.context.get('request')  # Lấy request từ context
        if obj.logo and hasattr(obj.logo, 'url'):
            return request.build_absolute_uri(obj.logo.url)
        return None
    
# update/thêm team
class TeamUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ['team_name', 'logo', 'head_coach', 'description']
        extra_kwargs = {
            'logo': {'required': False, 'allow_null': True},
        }




# class LeagueSerializerView(serializers.ModelSerializer):
#     class Meta:
#         model = League
#         fields = ['league_id', 'league_name', 'start_date', 'end_date', 'created_at', 'updated_at','league_type']
    # tạo sân mới 
from apps.tickets.serializers import SectionInlineSerializer  
from rest_framework import serializers
from apps.tickets.models import Section, Seat
from .models import Stadium

class StadiumSerializerView(serializers.ModelSerializer):
    sections = SectionInlineSerializer(many=True, write_only=True)
    stadium_layouts_url = serializers.SerializerMethodField()
    capacity = serializers.IntegerField(read_only=True)

    class Meta:
        model = Stadium
        fields = [
            'stadium_id',
            'stadium_code',
            'stadium_name',
            'location',
            'capacity',
            'stadium_layouts_url',  # Chỉ để hiển thị ảnh
            'sections'
        ]
        read_only_fields = ['stadium_id', 'stadium_layouts_url', 'capacity']

    def get_stadium_layouts_url(self, obj):
        request = self.context.get('request')
        if obj.stadium_layouts and hasattr(obj.stadium_layouts, 'url'):
            return request.build_absolute_uri(obj.stadium_layouts.url)
        return None


    def create(self, validated_data):
        sections_data = validated_data.pop('sections', [])

        stadium = Stadium.objects.create(**validated_data)

        total_capacity = 0
        for section_data in sections_data:
            section_obj = Section.objects.create(stadium=stadium, **section_data)
            total_capacity += section_obj.capacity

            for seat_number in range(1, section_obj.capacity + 1):
                seat_code = f"{stadium.stadium_code}-{section_obj.section_name}-{str(seat_number).zfill(3)}"
                Seat.objects.create(
                    seat_code=seat_code,
                    seat_number=str(seat_number).zfill(3),
                    status=0,
                    section=section_obj
                )

        stadium.capacity = total_capacity
        stadium.save()

        return stadium



# serializers.py

class StadiumUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stadium
        fields = ['stadium_code', 'stadium_name', 'location']



# thêm section cho sân
from rest_framework import serializers
from apps.tickets.models import Section, Seat
from apps.tickets.serializers import SectionInlineSerializer  # Nếu cần thiết

class SectionCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = ['section_name', 'capacity']

    def create(self, validated_data):
        # Lấy stadium_id từ context (được truyền từ view)
        stadium = self.context.get('stadium')
        section = Section.objects.create(stadium=stadium, **validated_data)

        # Tạo seats cho section mới
        for seat_number in range(1, section.capacity + 1):
            seat_code = f"{stadium.stadium_code}-{section.section_name}-{str(seat_number).zfill(3)}"
            Seat.objects.create(
                seat_code=seat_code,
                seat_number=str(seat_number).zfill(3),
                status=0,  # status mặc định là 0
                section=section
            )

        return section

# UPDATE SECTION
from rest_framework import serializers
from apps.tickets.models import Section

class SectionSerializerUpdate(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = ['section_id', 'section_name', 'stadium', 'capacity']
        read_only_fields = ['stadium']  # stadium không được phép sửa từ bên ngoài
    def validate(self, attrs):
        # Kiểm tra nếu section_name thay đổi
        section_name = attrs.get('section_name')
        stadium = self.instance.stadium  # stadium là read-only, nên lấy từ instance

        if section_name and Section.objects.filter(
            stadium=stadium,
            section_name=section_name
        ).exclude(pk=self.instance.pk).exists():
            raise serializers.ValidationError({
                'section_name': "Tên khu vực đã tồn tại trong sân vận động này."
            })

        return attrs

    
# lấy thông tin section theo id sân
class SectionSerializer(serializers.ModelSerializer):
    stadium_id = serializers.IntegerField(source='stadium.stadium_id')
    stadium_name = serializers.CharField(source='stadium.stadium_name')

    class Meta:
        model = Section
        fields = ['section_id', 'section_name', 'stadium_id', 'stadium_name', 'capacity']
# lấy thông tin các ghế của section the id sân và id section
from apps.tickets.models import Seat

class SeatDetailSerializer(serializers.ModelSerializer):
    section_id = serializers.IntegerField(source='section.section_id')
    section_name = serializers.CharField(source='section.section_name')
    stadium_id = serializers.IntegerField(source='section.stadium.stadium_id')
    stadium_name = serializers.CharField(source='section.stadium.stadium_name')

    class Meta:
        model = Seat
        fields = [
            'seat_id',
            'seat_code',
            'seat_number',
            'section_id',
            'section_name',
            'stadium_id',
            'stadium_name',
            'status'
        ]
# UPDATE SÂN team,leagueleague

# class StadiumSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Stadium
#         fields = ['stadium_id', 'stadium_name', 'location', 'capacity']
#         read_only_fields = ['stadium_id', 'capacity']  # ✅ Đặt 'capacity' là read-only


# class TeamSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Team
#         fields = '__all__'
#         read_only_fields = ['logo']  


class LeagueSerializer(serializers.ModelSerializer):
    has_matches = serializers.SerializerMethodField()
    class Meta:
        model = League
        fields = '__all__'

    def get_has_matches(self, obj):
        return obj.match_set.exists()
    
# upload layout
# events/serializers.py

from rest_framework import serializers
from .models import Stadium

class StadiumLayoutUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stadium
        fields = ['stadium_layouts']
# thay đổi trận lưu lịch sử 
# serializers.py (app events)
from rest_framework import serializers
from .models import Match

class MatchPartialUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Match
        fields = ['match_time', 'description']
# mtachhistory
# serializers.py
from rest_framework import serializers
from .models import MatchHistory

class MatchHistorySerializer(serializers.ModelSerializer):
    match_code = serializers.SerializerMethodField()
    old_description = serializers.SerializerMethodField()
    new_description = serializers.SerializerMethodField()
    old_time = serializers.SerializerMethodField()
    new_time = serializers.SerializerMethodField()
    employee_info = serializers.SerializerMethodField()

    class Meta:
        model = MatchHistory
        fields = [
            'm_history_id', 'match_code',
            'old_description', 'new_description',
            'old_time', 'new_time',
            'changed_at', 'employee_info', 'reason'
        ]

    def get_match_code(self, obj):
        return obj.match.match_id

    def get_old_description(self, obj):
        return obj.old_value.get('description', '')

    def get_new_description(self, obj):
        return obj.new_value.get('description', '')

    def get_old_time(self, obj):
        return obj.old_value.get('match_time', '')

    def get_new_time(self, obj):
        return obj.new_value.get('match_time', '')

    def get_employee_info(self, obj):
        # ✅ Sửa tại đây
        return f"{obj.employee.id} - {obj.employee.full_name}"
