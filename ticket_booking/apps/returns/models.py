from django.db import models
from apps.orders.models import OrderDetail
from apps.accounts.models import Employee

class TicketReturn(models.Model):
    return_id = models.AutoField(primary_key=True)
    detail = models.OneToOneField(OrderDetail, on_delete=models.CASCADE)
    return_reason = models.TextField()
    return_status = models.CharField(max_length=50, choices=[('pending', 'Đang chờ'), ('approved', 'Đã duyệt'), ('rejected', 'Từ chối'), ('completed', 'Hoàn tất')])
    refund_method = models.CharField(max_length=50, choices=[('bank_card', 'Thẻ ngân hàng'), ('transfer', 'Chuyển khoản'), ('cash', 'Tiền mặt')])
    return_time = models.DateTimeField(auto_now_add=True)
    processed_time = models.DateTimeField(null=True, blank=True)
    refund_amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE, null=True, blank=True)
    note = models.TextField(null=True, blank=True)

    def save(self, *args, **kwargs):
        if self.refund_amount is not None and self.refund_amount > self.detail.price:
            raise ValueError("Tiền trả lại không được lớn hơn số tiền gốc.")
        super().save(*args, **kwargs)

    class Meta:
        db_table = 'ticket_return'

    def __str__(self):
        return f'Yêu cầu trả vé cho đơn hàng {self.detail.order.order_id}'
