# apps/tickets/serializers.py
from rest_framework import serializers
from .models import Section, Seat, SectionPrice, PriceHistory
from apps.events.models import Match
from django.utils.timezone import localtime

class SectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = '__all__'

class SeatSerializer(serializers.ModelSerializer):
    class Meta:
        model = Seat
        fields = '__all__'

from rest_framework import serializers
from django.utils.timezone import localtime
from .models import SectionPrice

class SectionPriceSerializer(serializers.ModelSerializer):
    match_description = serializers.SerializerMethodField(read_only=True)
    section_name = serializers.SerializerMethodField(read_only=True)
    stadium_name = serializers.SerializerMethodField(read_only=True)
    match_time = serializers.SerializerMethodField(read_only=True)
    # Expose sport info so frontend can filter directly from ticketData
    sport_id = serializers.SerializerMethodField(read_only=True)
    sport_name = serializers.SerializerMethodField(read_only=True)
    sell_date = serializers.DateTimeField(format='%Y-%m-%dT%H:%M:%S')

    class Meta:
        model = SectionPrice
        fields = [
            'pricing_id',
            'price',
            'available_seats',
            'is_closed',
            'sell_date',
            'created_at',
            'match_description',
            'match_time',
            'section_name',
            'stadium_name',
            'sport_id',
            'sport_name'
        ]
        read_only_fields = [
            'pricing_id',
            'created_at',
            'match_description',
            'match_time',
            'section_name',
            'stadium_name',
            'available_seats',
            'is_closed',
            'sport_id',
            'sport_name'
        ]

    def get_match_description(self, obj):
        return obj.match.description if obj.match else None

    def get_match_time(self, obj):
        if obj.match and obj.match.match_time:
            return localtime(obj.match.match_time).strftime('%Y-%m-%dT%H:%M:%S')
        return None

    def get_section_name(self, obj):
        return obj.section.section_name if obj.section else None

    def get_stadium_name(self, obj):
        return obj.match.stadium.stadium_name if obj.match and obj.match.stadium else None

    def get_sport_id(self, obj):
        try:
            return obj.match.league.sport.sport_id
        except Exception:
            return None

    def get_sport_name(self, obj):
        try:
            return obj.match.league.sport.sport_name
        except Exception:
            return None

    def update(self, instance, validated_data):
        # Loại bỏ các trường không nên được cập nhật trực tiếp
        validated_data.pop('available_seats', None)
        validated_data.pop('is_closed', None)
        return super().update(instance, validated_data)
    def get_match_description(self, obj):
        return obj.match.description if obj.match else None

    def get_match_time(self, obj):
        if obj.match and obj.match.match_time:
            return localtime(obj.match.match_time).strftime('%Y-%m-%dT%H:%M:%S')
        return None

    def get_section_name(self, obj):
        return obj.section.section_name if obj.section else None

    def get_stadium_name(self, obj):
        return obj.match.stadium.stadium_name if obj.match and obj.match.stadium else None

    def update(self, instance, validated_data):
        # Loại bỏ các trường không nên được cập nhật trực tiếp
        validated_data.pop('available_seats', None)
        validated_data.pop('is_closed', None)
        return super().update(instance, validated_data)
# 


# 

from rest_framework import serializers
from .models import PriceHistory

from rest_framework import serializers
from .models import PriceHistory

class PriceHistorySerializer(serializers.ModelSerializer):
    match_id = serializers.SerializerMethodField()
    section_id = serializers.SerializerMethodField()
    changed_by_name = serializers.SerializerMethodField()  # ✅ Thêm field

    class Meta:
        model = PriceHistory
        fields = [
            'p_history_id',
            'old_price',
            'new_price',
            'effective_date',
            'changed_at',
            'reason',
            'pricing',
            'changed_by',
            'changed_by_name',  # ✅ Đưa vào output
            'match_id',
            'section_id'
        ]
        read_only_fields = ['old_price', 'changed_at', 'changed_by_name', 'match_id', 'section_id']
    def get_match_id(self, obj):
        return obj.pricing.match_id if obj.pricing and obj.pricing.match_id else None

    def get_section_id(self, obj):
        return obj.pricing.section_id if obj.pricing and obj.pricing.section_id else None

    def get_changed_by_name(self, obj):
        return obj.changed_by.full_name if obj.changed_by and hasattr(obj.changed_by, 'full_name') else None



class MatchNoTicketSerializer(serializers.ModelSerializer):
    stadium_name = serializers.SerializerMethodField()
    league_name = serializers.SerializerMethodField()
    team_1_name = serializers.SerializerMethodField()
    team_2_name = serializers.SerializerMethodField()
    class Meta:
        model = Match
        fields = [
            'match_id',
            'description',
            'round',
            'team_1_name',
            'team_2_name',
            'stadium_name',
            'league_name',
            'match_time'
        ]

    def get_stadium_name(self, obj):
        return obj.stadium.stadium_name if obj.stadium else None

    def get_league_name(self, obj):
        return obj.league.league_name if obj.league else None

    def get_team_1_name(self, obj):
        return obj.team_1.team_name if obj.team_1 else None

    def get_team_2_name(self, obj):
        return obj.team_2.team_name if obj.team_2 else None

    # tạo vé theo trận từng section
class SectionPriceDetailSerializer(serializers.ModelSerializer):
    match_description = serializers.SerializerMethodField()
    section_name = serializers.SerializerMethodField()
    stadium_name = serializers.SerializerMethodField()

    class Meta:
        model = SectionPrice
        fields = [
            'pricing_id',
            'match_description',
            'section_name',
            'stadium_name',
            'price',
            'available_seats',
            'is_closed',
            'sell_date',
            'created_at'
        ]

    def get_match_description(self, obj):
        return obj.match.description if obj.match else None

    def get_section_name(self, obj):
        return obj.section.section_name if obj.section else None

    def get_stadium_name(self, obj):
        return obj.section.stadium.stadium_name if obj.section and obj.section.stadium else None

    # Đảm bảo format sell_date đúng với yêu cầu
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        # Format sell_date thành chuỗi có timezone
        if instance.sell_date:
            representation['sell_date'] = instance.sell_date.strftime('%Y-%m-%dT%H:%M:%S%z')
        return representation


# chọn trận đấu để tạo vé
class MatchDetailSerializer(serializers.ModelSerializer):
    sections = SectionSerializer(many=True)  # Liệt kê các sections có thể click

    class Meta:
        model = Match
        fields = ['match_id', 'description', 'stadium', 'sections']

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        # Trả về tên sân vận động thay vì đối tượng stadium
        representation['stadium_name'] = instance.stadium.stadium_name
        return representation

# các trận đã tạo vé
class MatchSimpleSerializer(serializers.ModelSerializer):
    # Trả về league_id và sport thông qua quan hệ Match -> League -> Sport
    league_id = serializers.IntegerField(source='league.league_id', read_only=True)
    sport_id = serializers.IntegerField(source='league.sport.sport_id', read_only=True)
    sport_name = serializers.CharField(source='league.sport.sport_name', read_only=True)

    class Meta:
        model = Match
        fields = ['match_id', 'description', 'league_id', 'sport_id', 'sport_name']

# Them sân/section
class SectionInlineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = ['section_name', 'capacity']


