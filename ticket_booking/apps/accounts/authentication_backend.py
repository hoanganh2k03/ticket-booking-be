from django.contrib.auth.backends import BaseBackend
from .models import *
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import check_password

class CustomAuthenticationBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        # Kiểm tra trong mô hình Employee
        try:
            employee_account = EmployeeAccount.objects.get(username=username)
            if employee_account.check_password(password):
                return employee_account.employee
        except EmployeeAccount.DoesNotExist:
            pass

        # Kiểm tra trong mô hình Customer
        try:
            customer_account = CustomerAccount.objects.get(username=username)
            if check_password(password, customer_account.password):
                return customer_account.customer
        except CustomerAccount.DoesNotExist:
            pass

        return None
