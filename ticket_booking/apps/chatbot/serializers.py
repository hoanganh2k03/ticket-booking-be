from rest_framework import serializers
from .models import ChatHistory


class ChatHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatHistory
        fields = ['id', 'customer', 'user_message', 'bot_response', 'created_at', 'session_id']
        read_only_fields = ['id', 'created_at']
