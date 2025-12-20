from django.db import models
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import AbstractUser

class Employee(models.Model):
    id = models.AutoField(primary_key=True)
    full_name = models.CharField(max_length=255)
    date_of_birth = models.DateField()
    phone_number = models.CharField(max_length=15, unique=True)
    email = models.EmailField(unique=True)
    citizen_id = models.CharField(max_length=20, unique=True)
    gender = models.BooleanField(default=True) # 0 = Nam, 1 = Nu
    address = models.TextField()
    image = models.ImageField(upload_to='employee_images/', null=True, blank=True, default='employee_images/default.png')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'employee'

    def __str__(self):
        return self.full_name

class EmployeeAccount(AbstractUser):
    ROLE_CHOICES = [
        ('staff', 'Staff'),
        ('admin', 'Admin'),
    ]

    username = models.CharField(max_length=15, primary_key=True)
    password = models.CharField(max_length=255)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    is_active = models.BooleanField(default=True)
    employee = models.OneToOneField(Employee, on_delete=models.CASCADE)

    last_login = None
    is_superuser = None
    first_name = None
    last_name = None
    is_staff = None
    date_joined = None
    email = None

    class Meta:
        db_table = 'employee_account'

    def __str__(self):
        return self.username
    
    
class Customer(models.Model):
    id = models.AutoField(primary_key=True)
    full_name = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=15, unique=True)
    email = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    points = models.IntegerField(default=0, verbose_name="Điểm hiện có")
    loyalty_score = models.IntegerField(default=0, verbose_name="Điểm xếp hạng")
    
    TIER_CHOICES = [
        ('bronze', 'Thành viên Đồng'),
        ('silver', 'Thành viên Bạc'),
        ('gold', 'Thành viên Vàng'),
        ('diamond', 'Thành viên Kim Cương'),
    ]
    tier = models.CharField(max_length=20, choices=TIER_CHOICES, default='bronze')
    # --- LOGIC TỰ ĐỘNG CẬP NHẬT HẠNG ---
    def save(self, *args, **kwargs):
        # Tự động tính hạng dựa trên loyalty_score trước khi lưu
        if self.loyalty_score >= 5000:
            self.tier = 'diamond'
        elif self.loyalty_score >= 2000:
            self.tier = 'gold'
        elif self.loyalty_score >= 500:
            self.tier = 'silver'
        else:
            self.tier = 'bronze'
            
        super().save(*args, **kwargs)
    class Meta:
        db_table = 'customer'

    def __str__(self):
        return self.full_name

class CustomerAccount(models.Model):
    username = models.CharField(max_length=15, primary_key=True)
    password = models.CharField(max_length=255)
    faceid = models.CharField(max_length=255, null=True, blank=True, unique=True)
    is_verified = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    customer = models.OneToOneField(Customer, on_delete=models.CASCADE)

    class Meta:
        db_table = 'customer_account'

    def __str__(self):
        return self.username

class PointHistory(models.Model):
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    order = models.ForeignKey('orders.Order', on_delete=models.SET_NULL, null=True)
    change_amount = models.IntegerField() # + cho tích điểm, - cho sử dụng điểm
    reason = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

