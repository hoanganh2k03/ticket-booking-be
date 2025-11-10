from rest_framework.permissions import BasePermission
from .models import EmployeeAccount, CustomerAccount, Employee

class IsAdmin(BasePermission):
    """
    Cho phép truy cập cho người dùng có role 'admin'.
    """

    def has_permission(self, request, view):
        if request.user.is_authenticated:
            # Lấy đối tượng Employee liên kết với user (request.user là EmployeeAccount)
            try:
                # Đảm bảo bạn lấy được Employee instance từ request.user
                employee = request.user.employee  # employee là mối quan hệ OneToOne với Employee
                employee_account = EmployeeAccount.objects.get(employee=employee)
                
                # Kiểm tra xem employee_account có role 'staff' không
                return employee_account.role == 'admin'
            except EmployeeAccount.DoesNotExist:
                # Nếu không tìm thấy EmployeeAccount, trả về False
                return False
            except Employee.DoesNotExist:
                # Nếu không tìm thấy Employee, trả về False
                return False
        return False


class IsStaff(BasePermission):
    """
    Cho phép truy cập cho người dùng có role 'staff'.
    """

    def has_permission(self, request, view):
        if request.user.is_authenticated:
            # Lấy đối tượng Employee liên kết với user (request.user là EmployeeAccount)
            try:
                # Đảm bảo bạn lấy được Employee instance từ request.user
                employee = request.user.employee  # employee là mối quan hệ OneToOne với Employee
                employee_account = EmployeeAccount.objects.get(employee=employee)
                
                # Kiểm tra xem employee_account có role 'staff' không
                return employee_account.role == 'staff'
            except EmployeeAccount.DoesNotExist:
                # Nếu không tìm thấy EmployeeAccount, trả về False
                return False
            except Employee.DoesNotExist:
                # Nếu không tìm thấy Employee, trả về False
                return False
        return False


class IsCustomer(BasePermission):
    """
    Cho phép truy cập cho người dùng có role 'customer'.
    """

    def has_permission(self, request, view):
        if request.user.is_authenticated:
            # Kiểm tra nếu người dùng là một Customer
            try:
                customer = request.user.customer
                customer_account = CustomerAccount.objects.get(customer=customer)
                return True  # Nếu là customer, cho phép truy cập
            except:
                return False
        return False


class IsCustomerAuthenticated(BasePermission):
    def has_permission(self, request, view):
        
        return (
            request.user is not None
            and isinstance(request.user, CustomerAccount)
            and request.user.is_active
            and request.user.is_verified
        )