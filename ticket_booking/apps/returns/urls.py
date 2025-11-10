from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import TicketReturnViewSet

router = DefaultRouter()
router.register(r'', TicketReturnViewSet, basename='returns')

urlpatterns = [
    path('', include(router.urls)),
]