# serializers.py
from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from .models import Promotion, PromotionDetail, Section, Match, Employee
from apps.tickets.models import SectionPrice
from apps.orders.models import OrderDetail
from django.utils import timezone
from django.db import transaction

class EmployeeSimpleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = ['id', 'full_name']

class PromoCodeUniqueValidator(UniqueValidator):
    message = "Mã Promotion đã tồn tại."

class PromotionDetailSerializer(serializers.ModelSerializer):

    match = serializers.PrimaryKeyRelatedField(queryset=Match.objects.all())
    section = serializers.PrimaryKeyRelatedField(queryset=Section.objects.all())

    class Meta:
        model = PromotionDetail
        fields = ['match', 'section']

    def to_representation(self, instance):
        rep = super().to_representation(instance)
        rep['match_name'] = str(instance.match) + " - " + str(instance.match.match_time.strftime("%d %b %Y, %H:%M"))
        rep['section_name'] = str(instance.section)
        return rep

class PromotionSerializer(serializers.ModelSerializer):
    used_count = serializers.SerializerMethodField()
    available = serializers.SerializerMethodField() 
    promo_code = serializers.CharField(
        validators=[PromoCodeUniqueValidator(queryset=Promotion.objects.all())],
        error_messages={
            'blank': "Mã khuyến mãi không được để trống."
        }
    )
    lines = PromotionDetailSerializer(source='promotiondetail_set', many=True, required=False, write_only=True)
    promotion_details = PromotionDetailSerializer(source='promotiondetail_set', many=True, read_only=True)

    user = EmployeeSimpleSerializer(read_only=True)
    user_id = serializers.PrimaryKeyRelatedField(
        queryset=Employee.objects.all(),
        write_only=True,
        source='user',
    )


    class Meta:
        model = Promotion
        fields = [
            'promo_id', 'promo_code', 'discount_value', 'discount_type',
            'start_time', 'end_time', 'usage_limit', 'description',
            'status', 'promotion_details', 'lines', 'user', 'user_id',
            'used_count', 'available'
        ]
        read_only_fields = ['promo_id', 'promotion_details', 'employee', 'used_count']

    def get_used_count(self, obj):
        from apps.orders.models import OrderDetail
        return OrderDetail.objects.filter(promotion=obj).count()
    
    def get_available(self, obj):
        return obj.usage_limit if obj.usage_limit is not None else 0
        
    def validate(self, data):
        errors = {}
        promo_code = data.get('promo_code', '')

        import re
        if not re.match(r"^[A-Za-z0-9_-]+$", promo_code):
            errors['promo_code'] = (
                "Mã promotion không hợp lệ. Vui lòng chỉ sử dụng chữ cái, số, dấu '-' và '_'"
            )

        # Kiểm tra trùng mã code
        if self.instance:
            # Update
            if Promotion.objects.filter(promo_code=promo_code).exclude(pk=self.instance.pk).exists():
                errors['promo_code'] = "Mã Promotion đã tồn tại."
        else:
            # Create
            if Promotion.objects.filter(promo_code=promo_code).exists():
                errors['promo_code'] = "Mã Promotion đã tồn tại."
                
        now = timezone.now()
        st = data.get('start_time')
        et = data.get('end_time')

        # Kiểm tra thời gian bắt đầu và kết thúc
        if st is None:
            errors['start_time'] = "Thời gian bắt đầu là bắt buộc."
        if et is None:
            errors['end_time'] = "Thời gian kết thúc là bắt buộc."
            
        if st and et and st >= et:
            errors['end_time'] = "Phải lớn hơn ngày bắt đầu."

        if not self.instance:  # create
            if st and et and (st < now or et < now):
                errors['start_time'] = errors['end_time'] = "Không được nhỏ hơn thời gian hiện tại."
        
        dv = data.get('discount_value')
        dt = data.get('discount_type')

        # Kiểm tra giá trị giảm giá
        if dv is not None and dt:
            if dt == 'percentage':
                if not (1 <= dv <= 100):
                    errors['discount_value'] = "Giảm % phải >= 1 và ≤ 100."
            elif dt == 'amount':
                if not (10000 < dv < 10000000):
                    errors['discount_value'] = "Giảm tiền phải > 10000 và <= 10.000.000 VNĐ."
        
        usage_limit = data.get('usage_limit')
        if usage_limit is not None:
            if usage_limit <= 0 or usage_limit > 1000000:
                errors['usage_limit'] = "Giới hạn sử dụng 1 - 100000 lần."
            
        # --- Thời gian của trận đấu phải nằm thời gian của mã khuyến mãi mới được áp dụng ---
        promotion_details = data.get('promotiondetail_set')

        if promotion_details:
            for detail in promotion_details:
                match_obj = detail.get('match')
                if match_obj and hasattr(match_obj, 'match_time'):
                    match_time = match_obj.match_time
                    if not (st <= match_time <= et):
                        errors.setdefault('promotion_details', []).append(
                            "Thời gian áp dụng mã khuyến mãi không phù hợp với thời gian diễn ra trận đấu."
                        )
        if errors:
            raise serializers.ValidationError(errors)
        return data

    def create(self, validated_data):
        lines_data = validated_data.pop('promotiondetail_set', [])

        with transaction.atomic():
            # Tạo Promotion trước
            promo = Promotion.objects.create(
                **validated_data
            )

            # Tạo PromotionDetail cho từng dòng
            for ld in lines_data:
                PromotionDetail.objects.create(
                    promo=promo,
                    match=ld['match'],
                    section=ld['section']
                )

        return promo

    def update(self, instance, validated_data):
        new_details = validated_data.pop('promotiondetail_set', None)

        if new_details is not None:
            # 2. Tập hợp bộ cũ và bộ mới dưới dạng set of tuples
            old_set = {
                (d.match_id, d.section_id)
                for d in instance.promotiondetail_set.all()
            }
            new_set = {
                (item['match'].match_id, item['section'].section_id)
                for item in new_details
            }

            # 3. Tính xem có những cặp nào đang bị remove
            to_remove = old_set - new_set

            # 4. Với mỗi (match, section) trong to_remove, kiểm tra OrderDetail
            conflicts = []
            for match_id, section_id in to_remove:
                
                # Lấy ra tất cả SectionPrice ứng với match & section đó
                pricings = SectionPrice.objects.filter(
                    match_id=match_id,
                    section_id=section_id
                )
                if OrderDetail.objects.filter(
                    promotion=instance,
                    pricing__in=pricings
                ).exists():
                    match_obj = Match.objects.get(pk=match_id)
                    section_obj = Section.objects.get(pk=section_id)
                    conflicts.append(f"(match={match_obj}, section={section_obj.section_name})")
                    print(f"Conflict found: {match_obj} - {section_obj.section_name}")

            # 5. Nếu có conflict, raise lỗi và dừng luôn; không update bất cứ thứ gì
            if conflicts:
                raise serializers.ValidationError({
                    'details': (
                        "Không thể xóa các mục: "
                        + ", ".join(conflicts)
                        + " vì đã có đơn hàng sử dụng."
                    )
                })

            # 6. Nếu không có conflict, xoá hết detail cũ rồi tạo lại theo new_details
            instance.promotiondetail_set.all().delete()
            for item in new_details:
                PromotionDetail.objects.create(
                    promo=instance,
                    match=item['match'],
                    section=item['section']
                )

        # 7. Cuối cùng update các trường khác của Promotion
        return super().update(instance, validated_data)
    
    @staticmethod
    def delete_instance(instance):
        """
        Hàm xóa một Promotion instance chỉ nếu không có PromotionDetail nào liên kết.
        Nếu có, ném ra lỗi.
        """
        if instance.promotiondetail_set.exists():
            raise serializers.ValidationError("Không thể xóa mã khuyến mãi vì đã có trận đấu - section được áp dụng.")
        with transaction.atomic():
            instance.delete()
        return {"detail": "Xóa Promotion thành công."}


