from django.contrib import admin
from .models import ChatHistory


@admin.register(ChatHistory)
class ChatHistoryAdmin(admin.ModelAdmin):
    list_display = ['id', 'customer', 'session_id', 'created_at']
    list_filter = ['session_id', 'created_at']
    search_fields = ['customer__id', 'user_message', 'bot_response']
    readonly_fields = ['created_at']

    fieldsets = (
        ('Thông tin khách hàng', {
            'fields': ('customer', 'session_id')
        }),
        ('Nội dung chat', {
            'fields': ('user_message', 'bot_response')
        }),
        ('Thời gian', {
            'fields': ('created_at',)
        }),
    )
