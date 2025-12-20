from django.urls import path
from .views import *

urlpatterns = [
    path('matches/', MatchListAPIView.as_view(), name='match-list'),

    path('matches/<int:match_id>/', MatchDetailAPIView.as_view(), name='match-detail'),
    path('promotions/<int:match_id>/<int:section_id>/', PromotionListView.as_view(), name='promotion_list'),

    path('create-order/', OrderCreateAPIView.as_view(), name='order-create'),
    # path('create-payment/', PaymentCreateView.as_view(), name='payment-create'),
    path('momo-payment/', MoMoPaymentAPIView.as_view(), name='payment-test'),
    path('done-payment/', MoMoIPNAPIView.as_view(), name='get-test'),
    path('order/details/qr/', OrderDetailQRAPIView.as_view(), name='order_detail_qr'),

    path('customer/', CustomerOrdersAPIView.as_view(), name='order_customer'),

    path('order-list/', OrderListView.as_view(), name='order_list'),
    path('ticket-return/', TicketReturnAPIView.as_view(), name='return_ticket'),
    path('cash-card-payment/', CashCardPaymentAPIView.as_view(), name='cash-card-payment'),
    path('payment-result/', payment_result_view, name='payment-result'),
]