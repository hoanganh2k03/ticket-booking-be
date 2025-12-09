
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import SectionViewSet, SeatViewSet, SectionPriceViewSet
from .views import PriceHistoryViewSet
from .views import SectionPriceViewSet, MatchWithoutTicketsViewSet
from .views import create_section_price
from .views import MatchDetailView
from . import views
from .views import CompletedTicketMatchesAPIView,MatchSectionPricesAPIView
from django.urls import path
from .views import SuggestOptimalPriceView
router = DefaultRouter()
router.register(r'sections', SectionViewSet)
router.register(r'seats', SeatViewSet)
router.register(r'section-prices', SectionPriceViewSet)
router.register(r'price-histories', PriceHistoryViewSet)
router.register(r'matches/without-tickets', MatchWithoutTicketsViewSet, basename='match-without-tickets')

urlpatterns = [
    path('', include(router.urls)),
     #  Thêm thủ công API tạo SectionPrice theo match_id và section_id
    path('match/<int:match_id>/section/<int:section_id>/price/', create_section_price, name='create-section-price'),
    path('match-detail/<int:match_id>/', MatchDetailView.as_view(), name='match-detail'),
    # urls.py

    path('completed-matches/', CompletedTicketMatchesAPIView.as_view(), name='completed-ticket-matches'),
    path('match/<int:match_id>/section-prices/', MatchSectionPricesAPIView.as_view(), name='match-section-prices'),
    path('suggest-price/', SuggestOptimalPriceView.as_view(), name='suggest-price'),
]
