import uuid
from django.db import models

from apps.accounts.models import Customer
from apps.tickets.models import SectionPrice, Seat
from apps.promotions.models import Promotion

import uuid

class Order(models.Model):
    order_id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(Customer, on_delete=models.CASCADE, null=True, blank=True)
    total_amount = models.DecimalField(max_digits=15, decimal_places=2)
    order_status = models.CharField(max_length=50, choices=[('pending', 'Đang chờ'), ('received', 'Đã nhận'), ('cancelled', 'Đã hủy')])
    order_method = models.CharField(max_length=50, choices=[('online', 'Trực tuyến'), ('offline', 'Trực tiếp')])
    created_at = models.DateTimeField(auto_now_add=True)
    points_discount = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    class Meta:
        db_table = 'order'

    def __str__(self):
        return f'Order {self.order_id}'

class Payment(models.Model):
    payment_id = models.AutoField(primary_key=True)
    order = models.OneToOneField(Order, on_delete=models.CASCADE, related_name='payment')
    payment_method = models.CharField(max_length=50, choices=[('bank_card', 'Thẻ ngân hàng'), ('transfer', 'Chuyển khoản'), ('cash', 'Tiền mặt')])
    payment_status = models.CharField(max_length=50, choices=[('success', 'Thành công'), ('failed', 'Thất bại'), ('pending', 'Đang chờ')])
    transaction_code = models.CharField(max_length=100, unique=True, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    expiration_time = models.DateTimeField(default="2025-05-01")

    class Meta:
        db_table = 'payment'

    def __str__(self):
        return f'Payment for Order {self.order.order_id}'

class OrderDetail(models.Model):
    detail_id = models.AutoField(primary_key=True)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='order_details')
    pricing = models.ForeignKey(SectionPrice, on_delete=models.CASCADE, related_name='order_details')
    qr_code = models.TextField(null=True, blank=True)
    seat = models.ForeignKey(Seat, null=True, blank=True, on_delete=models.SET_NULL)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    promotion = models.ForeignKey(Promotion, on_delete=models.SET_NULL, null=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['order', 'seat'], name='unique_order_seat'),
        ]

        db_table = 'order_detail'

    def __str__(self):
        return f'Order {self.order.order_id} - Detail {self.detail_id}'
