from django.urls import path, include
from .views import *
from rest_framework.routers import DefaultRouter
from django.urls import path
from .views import PredictDemandView
router = DefaultRouter()
router.register(r'orders', OrderViewSet, basename='orders')
router.register(r'reports', OrderViewSet, basename='report')

urlpatterns = [
    path('revenue/', RevenueReportAPIView.as_view(), name='revenue-report'),
    path('promotions-usage/', PromotionUsageReportAPIView.as_view(), name='promotions-usage-report'),
    path('returns-report/', ReturnReportAPIView.as_view(), name='returns-report'),
    path('ticket-status/', TicketStatusReportAPIView.as_view(), name='ticket-status-report'),
    
    path('orders/leagues/', LeagueListAPIView.as_view(), name='league-list'),
    path('orders/leagues/<int:league_id>/matches/', MatchListByLeagueAPIView.as_view(), name='matches-by-league'),
    path('', include(router.urls)),

    path('payments/', PaymentListAPIView.as_view(), name='payments-list'),
    path('payments/<int:payment_id>/', PaymentDetailAPIView.as_view(), name='payments-detail'),
    # ML
    path('predict-demand/', PredictDemandView.as_view(), name='predict-demand'),
   
]