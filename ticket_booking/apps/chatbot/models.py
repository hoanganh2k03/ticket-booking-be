from django.db import models
from apps.accounts.models import Customer


class ChatHistory(models.Model):
    """Lưu lịch sử chat giữa khách hàng và chatbot"""
    id = models.AutoField(primary_key=True)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name='chat_histories')
    user_message = models.TextField()
    bot_response = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    session_id = models.CharField(max_length=100, blank=True, null=True)  # phiên hội thoại

    class Meta:
        db_table = 'chat_history'

    def __str__(self):
        return f"Chat {self.customer.id} - {self.session_id} ({self.created_at})"
