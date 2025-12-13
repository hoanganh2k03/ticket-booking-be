# apps/orders/routing.py
from django.urls import re_path
from . import consumers

websocket_urlpatterns = [
    # Đây chính là định nghĩa API mà Frontend của bạn đang gọi
    re_path(r'ws/book/(?P<match_id>\d+)/$', consumers.OrderConsumer.as_asgi()),
]