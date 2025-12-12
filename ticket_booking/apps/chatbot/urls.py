from django.urls import path
from .views import ChatbotAPIView, ChatHistoryAPIView

app_name = 'chatbot'

urlpatterns = [
    path('chat/send/', ChatbotAPIView.as_view(), name='chat'),
    path('chat/history/', ChatHistoryAPIView.as_view(), name='history'),
]
