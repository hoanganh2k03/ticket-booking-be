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
from rest_framework import serializers
from .models import Match, Stadium, League, Team
import re # Import thư viện Regex để kiểm tra chuỗi nâng cao

class MatchCreateSerializer(serializers.ModelSerializer):
    stadium = serializers.PrimaryKeyRelatedField(queryset=Stadium.objects.all())
    league = serializers.PrimaryKeyRelatedField(queryset=League.objects.all())
    team_1 = serializers.PrimaryKeyRelatedField(queryset=Team.objects.all())
    team_2 = serializers.PrimaryKeyRelatedField(queryset=Team.objects.all())

    class Meta:
        model = Match
        fields = [
            'match_id', 'match_time', 'description', 
            'stadium', 'league', 'round', 'team_1', 'team_2'
        ]

    def validate(self, data):
        league = data['league']
        team_1 = data['team_1']
        team_2 = data['team_2']
        match_time = data['match_time']
        stadium = data['stadium']
        
        # Chuẩn hóa chuỗi round: xóa khoảng trắng thừa, chuyển về chữ thường để dễ so sánh
        round_raw = data.get('round', '').strip()
        round_lower = round_raw.lower()

        # =========================================================
        # PHẦN 1: VALIDATE LOGIC CƠ BẢN (Đội & Môn thể thao)
        # =========================================================
        if team_1.team_id == team_2.team_id:
            raise serializers.ValidationError({"team_2": "Đội 1 và Đội 2 không thể giống nhau."})

        if league.sport != team_1.sport:
            raise serializers.ValidationError({
                "team_1": f"Sai môn thể thao! Giải '{league.league_name}' là môn '{league.sport.sport_name}', nhưng đội '{team_1.team_name}' là môn '{team_1.sport.sport_name}'."
            })

        if league.sport != team_2.sport:
            raise serializers.ValidationError({
                "team_2": f"Sai môn thể thao! Giải '{league.league_name}' là môn '{league.sport.sport_name}', nhưng đội '{team_2.team_name}' là môn '{team_2.sport.sport_name}'."
            })

        # =========================================================
        # PHẦN 2: VALIDATE TRƯỜNG 'ROUND' DỰA THEO LOẠI GIẢI
        # =========================================================
        
        # --- CASE 1: ROUND ROBIN (Vòng tròn) ---
        # Yêu cầu: Phải bắt đầu bằng "Vòng", "Round", "Lượt", "Tuần" + Số
        # --- CASE 1: ROUND ROBIN (Vòng tròn) ---
        if league.league_type == 'round_robin':
            # CŨ (Xóa đi): pattern = r'^(vòng|round|lượt|tuần|matchday)\s+\d+'
            
            # MỚI: Chỉ chấp nhận chuỗi số (VD: "1", "10")
            # isdigit() trả về True nếu chuỗi chỉ chứa số
            if not round_raw.isdigit():
                raise serializers.ValidationError({
                    "round": f"Giải đấu vòng tròn: Vui lòng chỉ nhập số thứ tự vòng đấu (VD: 1, 2, 10)."
                })

        # --- CASE 2: KNOCKOUT (Loại trực tiếp) ---
        # Yêu cầu: Phải chứa các từ khóa của vòng đấu loại
        elif league.league_type == 'knockout':
            valid_keywords = [
                'loại', 'playoff', 'play-off', 
                '1/32', '1/16', '1/8', 'round of', 
                'tứ kết', 'quarter', 
                'bán kết', 'semi', 
                'chung kết', 'final', 
                'tranh hạng'
            ]
            # Kiểm tra xem round_lower có CHỨA bất kỳ từ khóa nào không
            is_valid = any(keyword in round_lower for keyword in valid_keywords)
            
            if not is_valid:
                raise serializers.ValidationError({
                    "round": f"Giải '{league.league_name}' là đấu cúp. Tên vòng phải là: Tứ kết, Bán kết, Chung kết, Vòng 1/8..."
                })

        # --- CASE 3: HYBRID (Hỗn hợp: World Cup, C1) ---
        # Yêu cầu: Chấp nhận cả kiểu Bảng đấu VÀ kiểu Knockout
        elif league.league_type == 'hybrid':
            # Từ khóa cho vòng bảng
            group_keywords = ['bảng', 'group', 'stage']
            # Từ khóa cho vòng knock-out (lấy lại list trên)
            knockout_keywords = [
                '1/16', '1/8', 'tứ kết', 'bán kết', 'chung kết', 'final', 'semi', 'playoff'
            ]
            
            is_group = any(k in round_lower for k in group_keywords)
            is_knockout = any(k in round_lower for k in knockout_keywords)

            if not (is_group or is_knockout):
                raise serializers.ValidationError({
                    "round": f"Giải '{league.league_name}' là hỗn hợp. Tên vòng phải là 'Bảng X' hoặc các vòng 'Tứ kết', 'Bán kết'..."
                })

        # --- CASE 4 & 5: FRIENDLY (Giao hữu) & OTHER (Khác) ---
        # Yêu cầu: Không quá khắt khe, nhưng không được quá ngắn hoặc vô nghĩa
        elif league.league_type in ['friendly', 'other']:
            if len(round_raw) < 2:
                 raise serializers.ValidationError({
                    "round": "Tên vòng đấu/mô tả trận đấu quá ngắn."
                })

        # =========================================================
        # PHẦN 3: CHECK TRÙNG LỊCH SÂN (Tùy chọn)
        # =========================================================
        if Match.objects.filter(stadium=stadium, match_time=match_time).exists():
             raise serializers.ValidationError({
                "match_time": f"Sân {stadium.stadium_name} đã có lịch thi đấu vào giờ này."
            })

        return data


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

# file: serializers.py
from rest_framework import serializers
from .models import Team, Sport

class TeamSerializerView(serializers.ModelSerializer):
    logo = serializers.SerializerMethodField()
    
    # Sử dụng SlugRelatedField để hiển thị thẳng tên sport
    # Dùng read_only=True vì đây là serializer chỉ để xem
    sport = serializers.SlugRelatedField(
        read_only=True,
        slug_field='sport_name'  # Chỉ định trường tên trong model Sport
    )

    # Expose sport id and name explicitly for frontend filtering
    sport_id = serializers.IntegerField(source='sport.sport_id', read_only=True)
    sport_name = serializers.CharField(source='sport.sport_name', read_only=True)

    class Meta:
        model = Team
        # Include sport_id and sport_name so frontend can rely on them
        fields = ['team_id', 'sport_id', 'sport_name', 'sport', 'team_name', 
                  'logo', 'head_coach', 'description','rating']

    def get_logo(self, obj):
        request = self.context.get('request')
        if obj.logo and hasattr(obj.logo, 'url'):
            if request:
                return request.build_absolute_uri(obj.logo.url)
            return obj.logo.url
        return None
    
# update/thêm team
class TeamUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Team
        fields = ['team_name', 'logo', 'head_coach', 'description']
        extra_kwargs = {
            'logo': {'required': False, 'allow_null': True},
        }
# thêm mới 18.11
# file: serializers.py (thêm vào file)

class TeamCreateUpdateSerializer(serializers.ModelSerializer):
    # Dùng PrimaryKeyRelatedField để nhận ID của Sport khi tạo/cập nhật
    sport = serializers.PrimaryKeyRelatedField(queryset=Sport.objects.all())
    # Dùng ImageField để cho phép tải file lên
    logo = serializers.ImageField(required=False, allow_null=True)

    class Meta:
        model = Team
        # --- THAY ĐỔI 1: Thêm 'rating' vào danh sách fields ---
        fields = ['sport', 'team_name', 'logo', 'head_coach', 'description', 'rating']

    # --- THAY ĐỔI 2: Thêm hàm kiểm tra giá trị rating ---
    def validate_rating(self, value):
        """
        Kiểm tra chỉ số sức mạnh phải nằm trong khoảng 1-10.
        """
        if value < 1 or value > 10:
            raise serializers.ValidationError("Chỉ số sức mạnh (rating) phải nằm trong khoảng từ 1 đến 10.")
        return value

    def validate(self, data):
        # DRF sẽ tự động kiểm tra UniqueConstraint ('unique_team_name_per_sport')
        # khi .save() được gọi.
        # Bạn có thể thêm validation phức tạp hơn ở đây nếu cần.
        return data



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
    # Expose sport id and name explicitly for frontend filtering
    sport_id = serializers.IntegerField(source='sport.sport_id', read_only=True)
    sport_name = serializers.CharField(source='sport.sport_name', read_only=True)

    class Meta:
        model = League
        # include all model fields and the two computed fields
        fields = '__all__'  # 'sport_id' and 'sport_name' will be added by serializer automatically

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


class SportSerializer(serializers.ModelSerializer):
    """
    Serializer đơn giản chỉ để liệt kê các môn thể thao.
    """
    class Meta:
        model = Sport
        # Chỉ lấy 2 trường này để điền vào dropdown là đủ
        fields = ['sport_id', 'sport_name']