"""
ASGI config for ticket_booking project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
from django.urls import path

from apps.orders.consumers import OrderConsumer


os.environ.setdefault("DJANGO_SETTINGS_MODULE", "ticket_booking.settings")

application = ProtocolTypeRouter({
    "http": get_asgi_application(),  # Dành cho HTTP
    "websocket": AuthMiddlewareStack(  # Dành cho WebSockets
        URLRouter([
            path("ws/order/<int:match_id>/", OrderConsumer.as_asgi()),
        ])
    ),
})