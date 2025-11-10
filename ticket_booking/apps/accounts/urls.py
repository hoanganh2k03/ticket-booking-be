from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

from .views import *


router = DefaultRouter()
router.register(r'employees', EmployeeViewSet)

# Route cho staff quản lý khách hàng
router.register(r'staff/customers', CustomerAdminViewSet, basename='staff-customers')


urlpatterns = [
    path('auth/login', EmployeeLoginView.as_view(), name='employee-login'),
    # path('auth/test', LoginView.as_view(), name='test-login'),
    # path('auth/cust-test', TestLoginView.as_view(), name='test-cust-login'),

    path('auth/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    path('auth/customer/login/', CustomerLoginView.as_view(), name='customer-login'),
    path('auth/customer/register/', CustomerRegistrationView.as_view(), name='customer-register'),
    path('auth/customer/verify-otp/', CustomerVerifyOTPView.as_view(), name='verify-otp'),
    path('auth/customer/send-otp/', ResendOTPView.as_view(), name='send-otp'),

    path('employee/profile/', EmployeeProfileView.as_view(), name='employee-profile'),
    path('employee/profile/update/', EmployeeProfileUpdateView.as_view(), name='employee-profile-update'),
    path('employee/change-password/', EmployeeChangePasswordView.as_view(), name='employee-change-pass'),
    path('employee/forgot-password/', EmployeeForgotPasswordView.as_view(), name='employee-forgot-pass'),
    path('employee/reset-password/', EmployeeResetPasswordView.as_view(), name='employee-reset-pass'),

    path('customer/profile/', CustomerDetailView.as_view(), name='customer-profile'),
    path('customer/update/', CustomerUpdateView.as_view(), name='customer-update'),
    path('customer/change-password/', CustomerPasswordChangeView.as_view(), name='customer-change-pass'),
    path('customer/forgot-password/', CustomerForgotPasswordView.as_view(), name='customer-forgot-pass'),
    path('customer/reset-password/', CustomerResetPasswordView.as_view(), name='customer-reset-pass'),

    path('', include(router.urls)),
]
