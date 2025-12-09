# urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import PromotionViewSet, MatchListAPIView_Promotions, SectionListAPIView_Promotions

router = DefaultRouter()
router.register(r'', PromotionViewSet, basename='promotion')

urlpatterns = [
    path('match/', MatchListAPIView_Promotions.as_view(), name='match-list'),
    path('section/', SectionListAPIView_Promotions.as_view(), name='section-list'),
    path('', include(router.urls)),
]
