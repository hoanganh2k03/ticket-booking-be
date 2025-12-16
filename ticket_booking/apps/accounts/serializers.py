from django.utils import timezone
from rest_framework import serializers, status
from rest_framework.response import Response
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth import authenticate, get_user_model
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User, Group
from django.contrib.auth.hashers import make_password
from django.core.validators import RegexValidator, EmailValidator
from rest_framework.validators import UniqueValidator
import os
from django.core.exceptions import ValidationError
from django.db import transaction, IntegrityError

from .models import *
import re

phone_validator = RegexValidator(
    regex=r'^0\d{9,10}$',
    message='Số điện thoại phải bắt đầu bằng 0 và gồm 10–11 chữ số.'
)

email_validator = EmailValidator(message="Email không đúng định dạng.")

def validate_image_file(value):
    if not value:
        return value
    if not value.name.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
        raise ValidationError("Chỉ cho phép tải lên file hình ảnh (PNG, JPG, JPEG, GIF).")

class EmployeeTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        username = attrs.get('username')
        password = attrs.get('password')

        # 1. Check username
        try:
            account = EmployeeAccount.objects.get(username=username)
        except EmployeeAccount.DoesNotExist:
            raise serializers.ValidationError({'username': 'Tên đăng nhập không tồn tại.'})

        # 2. Check password
        if not check_password(password, account.password):
            raise serializers.ValidationError({'password': 'Mật khẩu không đúng.'})

        # 3. Check is_active
        if not account.is_active:
            raise serializers.ValidationError({'non_field_errors': 'Tài khoản đang bị vô hiệu hóa.'})

        # 4. Nếu hợp lệ, gọi super() để sinh token
        data = super().validate(attrs)  
        
        # 5. Bổ sung thêm full_name, role
        employee = Employee.objects.get(pk=account.employee_id)
        data['employee_id'] = employee.pk
        data['full_name'] = employee.full_name
        data['role'] = account.role
        return data
    

class MyCustomerTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        print(attrs)
        data = super().validate(attrs)
        if isinstance(self.user, Employee):
            data['role'] = 'employee'  # Thêm role cho Employee
            data['username'] = self.user.username
            data['full_name'] = self.user.full_name  # Lấy full_name từ Employee
        elif isinstance(self.user, Customer):
            data['role'] = 'customer'  # Thêm role cho Customer
            data['username'] = self.user.username
            data['full_name'] = self.user.full_name  # Lấy full_name từ Customer

        return data


class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=100)
    password = serializers.CharField(max_length=255)

    def validate_username(self, value):
            # Kiểm tra nếu username dài hơn 15 ký tự
            if len(value) > 100:
                raise serializers.ValidationError("Tên đăng nhập không được dài hơn 100 ký tự.")
            return value

    # def validate_password(self, value):
    #     # Kiểm tra độ dài mật khẩu, ví dụ ít nhất 8 ký tự
    #     if len(value) < 8:
    #         raise serializers.ValidationError("Mật khẩu phải có ít nhất 8 ký tự.")
    #     return value


class EmployeeRegistrationSerializer(serializers.ModelSerializer):
    role = serializers.ChoiceField(
        choices=EmployeeAccount.ROLE_CHOICES,
        write_only=True
    )
    
    email = serializers.EmailField(
        validators=[
            email_validator,
            UniqueValidator(
                queryset=Employee.objects.all(),
                message="Email này đã được sử dụng."
            )
        ],
        error_messages={
            'blank': 'Email là bắt buộc.',
            'required': 'Email là bắt buộc.',
            'invalid': 'Email không đúng định dạng.'
        }
    )

    citizen_id = serializers.CharField(
        validators=[
            RegexValidator(
                regex=r'^\d{9,12}$',
                message="CCCD phải gồm 9–12 chữ số."
            ),
            UniqueValidator(
                queryset=Employee.objects.all(),
                message="CCCD này đã được sử dụng."
            )
        ]
    )

    phone_number = serializers.CharField(
        validators=[
            phone_validator,
            UniqueValidator(
                queryset=Employee.objects.all(),    
                message="Số điện thoại này đã được đăng ký."
            )
        ],
        error_messages={'blank': 'Số điện thoại là bắt buộc.', 'required': 'Số điện thoại là bắt buộc.'}
    )

    image = serializers.ImageField(
        validators=[validate_image_file],
        error_messages={
            'invalid': 'File tải lên không hợp lệ. Vui lòng chọn file hình ảnh.'
        },
        required=False,
        allow_null=True
    )

    class Meta:
        model = Employee
        fields = [
            'full_name', 'date_of_birth', 'phone_number',
            'email', 'citizen_id', 'gender', 'address', 'role', 'image',
        ]

    def validate_full_name(self, value):
        # Chỉ cho phép chữ cái và khoảng trắng
        if not all(c.isalpha() or c.isspace() for c in value):
            raise serializers.ValidationError("Họ & tên chỉ được chứa chữ cái và khoảng trắng.")
        return value

    def validate_date_of_birth(self, value):
        # Không được chọn ngày trong tương lai, và độ tuổi phải >= 18
        today = timezone.now().date()
        if value > today:
            raise serializers.ValidationError("Ngày sinh không thể ở tương lai.")
        age = today.year - value.year - ((today.month, today.day) < (value.month, value.day))
        if age < 18:
            raise serializers.ValidationError("Nhân viên phải từ 18 tuổi trở lên.")
        return value


    def create(self, validated_data):
        # try:
            with transaction.atomic():
                # Tạo Employee
                employee = Employee.objects.create(
                    full_name=validated_data['full_name'],
                    date_of_birth=validated_data['date_of_birth'],
                    phone_number=validated_data['phone_number'],
                    citizen_id=validated_data['citizen_id'],
                    gender=validated_data['gender'],
                    address=validated_data['address'],
                    email=validated_data['email'],
                    image=validated_data.get('image'),
                )
                # Tạo EmployeeAccount
                EmployeeAccount.objects.create(
                    username=validated_data['citizen_id'],
                    password=make_password(validated_data['citizen_id']),
                    role=validated_data['role'],
                    employee=employee
                )
            return employee
        # except IntegrityError as e:
        #     # Bắt mọi lỗi unique/constraint, trả về ValidationError
        #     raise serializers.ValidationError({
        #         'non_field_errors': ['Không thể thêm nhân viên: ' + str(e)]
        #     })

    
class EmployeeSerializer(serializers.ModelSerializer):
    role = serializers.CharField(source='employeeaccount.role', read_only=True)
    is_active = serializers.BooleanField(source='employeeaccount.is_active', read_only=True)
    class Meta:
        model = Employee
        fields = ['id', 'full_name', 'role', 'gender', 'date_of_birth', 'phone_number', 'email', 'citizen_id', 'address', 'image', 'created_at', 'updated_at', 'is_active']


class EmployeeProfileSerializer(serializers.ModelSerializer):
    role = serializers.CharField(source='employeeaccount.role', read_only=True)
    username = serializers.CharField(source='employeeaccount.username', read_only=True)
    is_active = serializers.BooleanField(source='employeeaccount.is_active', read_only=True)
    class Meta:
        model = Employee
        fields = ['id', 'full_name', 'username', 'role', 'gender', 'date_of_birth', 'phone_number', 'email', 'citizen_id', 'address', 'image', 'created_at', 'updated_at', 'is_active']


class EmployeeProfileUpdateSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(
        error_messages={
            'blank': 'Họ và tên là bắt buộc.',
            'required': 'Họ và tên là bắt buộc.'
        }
    )
    date_of_birth = serializers.DateField(
        error_messages={
            'invalid': 'Ngày sinh không hợp lệ.',
            'required': 'Ngày sinh là bắt buộc.'
        }
    )
    phone_number = serializers.CharField(
        validators=[phone_validator],
        error_messages={
            'blank': 'Số điện thoại là bắt buộc.',
            'required': 'Số điện thoại là bắt buộc.'
        }
    )
    email = serializers.EmailField(
        validators=[email_validator],
        error_messages={
            'blank': 'Email là bắt buộc.',
            'required': 'Email là bắt buộc.',
            'invalid': 'Email không đúng định dạng.'
        }
    )
    gender = serializers.CharField(
        error_messages={
            'blank': 'Giới tính là bắt buộc.',
            'required': 'Giới tính là bắt buộc.'
        }
    )
    address = serializers.CharField(
        error_messages={
            'blank': 'Địa chỉ là bắt buộc.',
            'required': 'Địa chỉ là bắt buộc.'
        }
    )
    image = serializers.ImageField(
        validators=[validate_image_file],
        error_messages={
            'invalid': 'File tải lên không hợp lệ. Vui lòng chọn file hình ảnh.'
        },
        required=False,
        allow_null=True
    )
    citizen_id = serializers.CharField(
        validators=[
            RegexValidator(
                regex=r'^\d{9,12}$',
                message="CCCD phải gồm 9–12 chữ số."
            ),
            UniqueValidator(
                queryset=Employee.objects.all(),
                message="CCCD này đã được sử dụng."
            )
        ],
        error_messages={
            'blank': 'CCCD là bắt buộc.',
            'required': 'CCCD là bắt buộc.'
        }
    )

    class Meta:
        model = Employee
        fields = ['full_name', 'date_of_birth', 'phone_number', 'email', 'gender', 'address', 'image', 'citizen_id']

    def validate_full_name(self, value):
        # Chỉ cho phép chữ cái và khoảng trắng
        if not all(c.isalpha() or c.isspace() for c in value):
            raise serializers.ValidationError("Họ & tên chỉ được chứa chữ cái và khoảng trắng.")
        return value

    def validate_date_of_birth(self, value):
        today = timezone.now().date()
        if value > today:
            raise serializers.ValidationError("Ngày sinh không thể ở tương lai.")
        age = today.year - value.year - ((today.month, today.day) < (value.month, value.day))
        if age < 18:
            raise serializers.ValidationError("Nhân viên phải từ 18 tuổi trở lên.")
        return value

    def validate_email(self, value):
        qs = Employee.objects.filter(email__iexact=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.pk)
        if qs.exists():
            raise serializers.ValidationError("Email này đã được sử dụng.")
        return value

    def validate_phone_number(self, value):
        qs = Employee.objects.filter(phone_number=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.pk)
        if qs.exists():
            raise serializers.ValidationError("Số điện thoại này đã được đăng ký.")
        return value

    def update(self, instance, validated_data):
        instance.full_name = validated_data.get('full_name', instance.full_name)
        instance.date_of_birth = validated_data.get('date_of_birth', instance.date_of_birth)
        instance.email = validated_data.get('email', instance.email)
        instance.gender = validated_data.get('gender', instance.gender)
        instance.phone_number = validated_data.get('phone_number', instance.phone_number)
        instance.address = validated_data.get('address', instance.address)
        instance.image = validated_data.get('image', instance.image)
        instance.save()
        return instance
    

class EmployeeChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True, min_length=6)


class EmployeeResetPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6)
    new_password = serializers.CharField(min_length=6)


class EmployeeUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = ['full_name', 'date_of_birth', 'phone_number', 'email', 'gender', 'address', 'image']

    # Khong can check vi Django da check
    # def validate_email(self, value):
    #     # Kiểm tra email có trùng với email của nhân viên khác không
    #     employee_id = self.instance.employee_id  # Lấy ID nhân viên hiện tại
    #     if Employee.objects.filter(email=value).exclude(employee_id=employee_id).exists():
    #         raise serializers.ValidationError("This email is already in use.")
    #     return value

    # def validate_phone_number(self, value):
    #     # Kiểm tra số điện thoại có trùng với số điện thoại của nhân viên khác không
    #     employee_id = self.instance.employee_id  # Lấy ID nhân viên hiện tại
    #     if Employee.objects.filter(phone_number=value).exclude(employee_id=employee_id).exists():
    #         raise serializers.ValidationError("This phone number is already in use.")
    #     return value

    # def validate_full_name(self, value):
    #     # Chỉ chứa chữ và khoảng trắng
    #     if not all(c.isalpha() or c.isspace() for c in value):
    #         raise serializers.ValidationError("Họ & tên chỉ được chứa chữ cái và khoảng trắng.")
    #     return value

    # def validate_email(self, value):
    #     qs = Employee.objects.filter(email__iexact=value)
    #     if self.instance:
    #         qs = qs.exclude(pk=self.instance.pk)
    #     if qs.exists():
    #         raise serializers.ValidationError("Email này đã được sử dụng bởi nhân viên khác.")
    #     return value

    # def validate_phone_number(self, value):
    #     qs = Employee.objects.filter(phone_number=value)
    #     if self.instance:
    #         qs = qs.exclude(pk=self.instance.pk)
    #     if qs.exists():
    #         raise serializers.ValidationError("Số điện thoại này đã được đăng ký bởi nhân viên khác.")
    #     return value

    # def validate_date_of_birth(self, value):
    #     today = timezone.now().date()
    #     if value > today:
    #         raise serializers.ValidationError("Ngày sinh không thể ở tương lai.")
    #     age = today.year - value.year - ((today.month, today.day) < (value.month, value.day))
    #     if age < 18:
    #         raise serializers.ValidationError("Nhân viên phải từ 18 tuổi trở lên.")
    #     return value


class CustomerSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='customeraccount.username', read_only=True)
    faceid = serializers.CharField(source='customeraccount.faceid', read_only=True)

    class Meta:
        model = Customer
        fields = ['id', 'full_name', 'phone_number', 'email', 'created_at', 'updated_at', 'username', 'faceid']


class CustomerAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomerAccount
        fields = ['username', 'password', 'is_verified', 'is_active', 'customer', 'faceid']

    def update(self, instance, validated_data):
        # Cập nhật thông tin tài khoản
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        # allow updating faceid too
        if 'faceid' in validated_data:
            # If faceid is empty string, set to None
            faceid_val = validated_data.get('faceid')
            instance.faceid = faceid_val if faceid_val else None
            # we should remove it from validated_data to avoid extra field processing
            validated_data.pop('faceid', None)
        return super().update(instance, validated_data)

    def create(self, validated_data):
        # ensure password is hashed
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        # handle empty faceid
        if 'faceid' in validated_data and not validated_data['faceid']:
            validated_data['faceid'] = None
        return super().create(validated_data)


class CustomerUpdateSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(
        error_messages={
            'blank': 'Họ và tên là bắt buộc.',
            'required': 'Họ và tên là bắt buộc.'
        }
    )
    phone_number = serializers.CharField(
        validators=[phone_validator],
        error_messages={
            'blank': 'Số điện thoại là bắt buộc.',
            'required': 'Số điện thoại là bắt buộc.'
        }
    )
    email = serializers.EmailField(
        validators=[email_validator],
        error_messages={
            'blank': 'Email là bắt buộc.',
            'required': 'Email là bắt buộc.',
            'invalid': 'Email không đúng định dạng.'
        }
    )
    class Meta:
        model = Customer
        fields = ['full_name', 'phone_number', 'email']

    def validate_full_name(self, value):
        if 'id' in self.context:  # Kiểm tra nếu có id của khách hàng
            customer_id = self.context['id']
        # Kiểm tra giá trị không được để trống
        if not value or value.strip() == "":
            raise serializers.ValidationError("Họ & tên không được để trống.")

        # Chỉ cho phép chữ (bao gồm dấu tiếng Việt), khoảng trắng và loại bỏ ký tự đặc biệt/ký tự số
        if not all(c.isalpha() or c.isspace() for c in value):
            raise serializers.ValidationError("Họ & tên chỉ được chứa chữ cái và khoảng trắng.")

        # Kiểm tra độ dài tối thiểu (ví dụ: 2 ký tự) và tối đa (ví dụ: 50 ký tự)
        if len(value.strip()) < 2:
            raise serializers.ValidationError("Họ & tên phải có ít nhất 2 ký tự.")
        if len(value.strip()) > 50:
            raise serializers.ValidationError("Họ & tên không được vượt quá 50 ký tự.")

        # Loại bỏ khoảng trắng thừa ở đầu/cuối và giữa các từ
        value = " ".join(value.split())
        return value

    def validate_email(self, value):
        # Kiểm tra email chưa tồn tại
        if 'id' in self.context:  # Kiểm tra nếu có id của khách hàng
            customer_id = self.context['id']
            if Customer.objects.filter(email=value).exclude(id=customer_id).exists():
                raise serializers.ValidationError("Email này đã được đăng ký.")
        else:
            if Customer.objects.filter(email=value).exists():
                raise serializers.ValidationError("Email này đã được đăng ký.")
    
        if len(value) > 100:
            raise serializers.ValidationError("Email không được vượt quá 100 ký tự.")
        
        value = value.strip()
        return value

    def validate_phone_number(self, value):
        # Kiểm tra số điện thoại chưa tồn tại, nhưng không kiểm tra với chính người dùng hiện tại
        if 'id' in self.context:  # Kiểm tra nếu có id của khách hàng
            customer_id = self.context['id']
            if Customer.objects.filter(phone_number=value).exclude(id=customer_id).exists():
                raise serializers.ValidationError("Số điện thoại này đã được đăng ký.")
        else:
            if Customer.objects.filter(phone_number=value).exists():
                raise serializers.ValidationError("Số điện thoại này đã được đăng ký.")
        return value


class PasswordChangeSerializer(serializers.Serializer):
    old_password = serializers.CharField(max_length=255)
    new_password = serializers.CharField(max_length=255)
    confirm_new_password = serializers.CharField(max_length=255)


class CustomerRegistrationSerializer(serializers.ModelSerializer):
    username = serializers.CharField(max_length=15, write_only=True)
    password = serializers.CharField(max_length=255, write_only=True)
    email = serializers.EmailField(
        validators=[email_validator],
        error_messages={'blank': 'Email là bắt buộc.', 'required': 'Email là bắt buộc.'}
    )
    phone_number = serializers.CharField(
        validators=[phone_validator],
        error_messages={'blank': 'Số điện thoại là bắt buộc.', 'required': 'Số điện thoại là bắt buộc.'}
    )
    class Meta:
        model = Customer
        fields = [
            'username', 'password', 'full_name', 'phone_number', 'email'
        ]

    def validate_full_name(self, value):
        # Kiểm tra giá trị không được để trống
        if not value or value.strip() == "":
            raise serializers.ValidationError("Họ & tên không được để trống.")

        # Chỉ cho phép chữ (bao gồm dấu tiếng Việt), khoảng trắng và loại bỏ ký tự đặc biệt/ký tự số
        if not all(c.isalpha() or c.isspace() for c in value):
            raise serializers.ValidationError("Họ & tên chỉ được chứa chữ cái và khoảng trắng.")

        # Kiểm tra độ dài tối thiểu (ví dụ: 2 ký tự) và tối đa (ví dụ: 50 ký tự)
        if len(value.strip()) < 2:
            raise serializers.ValidationError("Họ & tên phải có ít nhất 2 ký tự.")
        if len(value.strip()) > 50:
            raise serializers.ValidationError("Họ & tên không được vượt quá 50 ký tự.")

        # Loại bỏ khoảng trắng thừa ở đầu/cuối và giữa các từ
        value = " ".join(value.split())
        return value
    
    def validate_username(self, value):
        # Kiểm tra giá trị không được để trống
        if not value or value.strip() == "":
            raise serializers.ValidationError("Tên đăng nhập không được để trống.")

        # Kiểm tra tên đăng nhập đã tồn tại trong hệ thống
        if CustomerAccount.objects.filter(username=value).exists():
            raise serializers.ValidationError("Tên đăng nhập đã tồn tại.")

        # Kiểm tra độ dài tối thiểu (ít nhất 4 ký tự) và tối đa (ví dụ: 30 ký tự)
        if len(value) < 4:
            raise serializers.ValidationError("Tên đăng nhập phải có ít nhất 4 ký tự.")
        if len(value) > 30:
            raise serializers.ValidationError("Tên đăng nhập không được vượt quá 30 ký tự.")

        # Kiểm tra chỉ cho phép chữ, số và một số ký tự đặc biệt (ví dụ: dấu gạch dưới _)
        if not all(c.isalnum() or c == '_' for c in value):
            raise serializers.ValidationError("Tên đăng nhập chỉ được chứa chữ, số và dấu gạch dưới (_).")

        # Kiểm tra không bắt đầu hoặc kết thúc bằng dấu gạch dưới
        if value.startswith('_') or value.endswith('_'):
            raise serializers.ValidationError("Tên đăng nhập không được bắt đầu hoặc kết thúc bằng dấu gạch dưới (_).")

        # Loại bỏ khoảng trắng thừa (nếu có)
        value = value.strip()
        return value

    def validate_email(self, value):
        # Kiểm tra email chưa tồn tại
        if Customer.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError("Email này đã được sử dụng.")
    
        if len(value) > 100:
            raise serializers.ValidationError("Email không được vượt quá 100 ký tự.")
        
        value = value.strip()
        return value

    def validate_phone_number(self, value):
        # Định dạng đã được kiểm qua RegexValidator ở trên
        # Chỉ cần check unique
        if Customer.objects.filter(phone_number=value).exists():
            raise serializers.ValidationError("Số điện thoại này đã được đăng ký.")
        return value
    
    def validate_password(self, value):
        if len(value) < 8:
            raise serializers.ValidationError('Mật khẩu phải có ít nhất 8 ký tự.')
        return value

    def create(self, validated_data):
        customer = Customer.objects.create(
            full_name=validated_data['full_name'],
            phone_number=validated_data['phone_number'],
            email=validated_data['email'],
        )

        CustomerAccount.objects.create(
            username=validated_data['username'],
            password=make_password(validated_data['password']),
            customer=customer
        )

        return customer
    
class CustomerCreateUpdateSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(
        required=True,
        error_messages={'required': 'Họ và tên là bắt buộc.'}
    )
    email = serializers.EmailField(
        required=True,
        validators=[
            email_validator,
            UniqueValidator(
                queryset=Customer.objects.all(),
                message='Email này đã được sử dụng.'
            )
        ],
        error_messages={
            'required': 'Email là bắt buộc.',
            'invalid': 'Email không đúng định dạng.'
        }
    )
    
    phone_number = serializers.CharField(
        required=True,
        validators=[
            # cho phép chính xác 10 hoặc 11 chữ số
            RegexValidator(
                regex=r'^\d{10,11}$',
                message='Số điện thoại phải gồm 10–11 chữ số.'
            ),
            UniqueValidator(
                queryset=Customer.objects.all(),
                message='Số điện thoại này đã được đăng ký.'
            )
        ],
        error_messages={'required': 'Số điện thoại là bắt buộc.'}
    )

    class Meta:
        model = Customer
        fields = ['full_name', 'email', 'phone_number']

    def validate_email(self, value):
        """
        Trên create: chắc chắn không có bản ghi nào trùng.
        Trên update: loại trừ chính nó trước khi kiểm tra.
        """
        qs = Customer.objects.filter(email__iexact=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.pk)
        if qs.exists():
            raise serializers.ValidationError('Email này đã được sử dụng.')
        return value

    def validate_phone_number(self, value):
        """
        Tương tự với phone_number.
        """
        qs = Customer.objects.filter(phone_number=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.pk)
        if qs.exists():
            raise serializers.ValidationError('Số điện thoại này đã được đăng ký.')
        return value
