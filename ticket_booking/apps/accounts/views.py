from django.contrib.auth.hashers import check_password
from django.core.mail import send_mail
from django.conf import settings
from django.contrib.auth import update_session_auth_hash, authenticate, get_user_model
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.decorators import action
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework_simplejwt.serializers import TokenRefreshSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, viewsets
from rest_framework.filters import SearchFilter
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.authentication import TokenAuthentication
from rest_framework.exceptions import NotFound

import random
import string
import redis
import jwt

from .permissions import *
from .models import Employee
from .serializers import *
from .utils import *
from apps.orders.models import Order


redis_client = redis.StrictRedis.from_url(settings.REDIS_URL, decode_responses=True)


class EmployeeLoginView(TokenObtainPairView):
    serializer_class = EmployeeTokenObtainPairSerializer


class TestLoginView(TokenObtainPairView):
    serializer_class = MyCustomerTokenObtainPairSerializer


# class EmployeeLoginView(APIView):
#     def post(self, request, *args, **kwargs):
#         serializer = LoginSerializer(data=request.data)

#         if serializer.is_valid():
#             username = serializer.validated_data['username']
#             password = serializer.validated_data['password']

#             try:
#                 employee_account = EmployeeAccount.objects.get(username=username)

#                 if check_password(password, employee_account.password):
#                     employee = employee_account.employee

#                     refresh = RefreshToken.for_user(employee)
#                     access_token = str(refresh.access_token)

#                     return Response({
#                         "status": "success",
#                         "message": "Đăng nhập thành công.",
#                         "data": {
#                             "access_token": access_token,
#                             "refresh_token": str(refresh),
#                             "employee": {
#                                 "employee_id": employee.id,
#                                 "full_name": employee.full_name,
#                                 "role": employee_account.role,
#                                 "image": employee.image.url if employee.image else None
#                             }
#                         }
#                     }, status=status.HTTP_200_OK)
#                 else:
#                     return Response({
#                         "status": "error",
#                         "message": "Mật khẩu không đúng.",
#                     }, status=status.HTTP_400_BAD_REQUEST)

#             except EmployeeAccount.DoesNotExist:
#                 return Response({
#                     "status": "error",
#                     "message": "Tên đăng nhập không tồn tại.",
#                 }, status=status.HTTP_400_BAD_REQUEST)
        
#         return Response({
#             "status": "error",
#             "message": "Thông tin đăng nhập không hợp lệ.",
#             "errors": serializer.errors
#         }, status=status.HTTP_400_BAD_REQUEST)
    

class EmployeeProfileView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        try:
            # Lấy thông tin EmployeeAccount của user hiện tại
            employee_account = request.user.employee
            
            # Serialize thông tin employee
            serializer = EmployeeProfileSerializer(employee_account)
            
            # Trả về thông tin theo định dạng yêu cầu
            return Response({
                'status': 'success',
                'message': 'Lấy thông tin nhân viên thành công',
                'data': serializer.data
            })
        except Exception as e:
            # Nếu có lỗi xảy ra, trả về thông báo lỗi
            return Response({
                'status': 'error',
                'message': str(e),
                'data': {}
            })
    

class EmployeeProfileUpdateView(APIView):
    # permission_classes = [IsAuthenticated, IsAdmin]

     def patch(self, request):
        data = request.data
        # 1. Thử lấy employee gắn với user
        employee = getattr(request.user, 'employee', None)

        # 2. Nếu user không có profile employee, lấy id từ payload
        if employee is None:
            emp_id = data.get('id')
            if not emp_id:
                return Response({
                    'status': 'error',
                    'message': 'Thiếu trường "id" để xác định nhân viên cần cập nhật.',
                    'data': {}
                }, status=status.HTTP_400_BAD_REQUEST)

            try:
                employee = Employee.objects.get(pk=emp_id)
            except Employee.DoesNotExist:
                return Response({
                    'status': 'error',
                    'message': f'Không tìm thấy nhân viên với id={emp_id}.',
                    'data': {}
                }, status=status.HTTP_404_NOT_FOUND)

        # 3. Tiến hành validate + save
        serializer = EmployeeProfileUpdateSerializer(employee, data=data, partial=True)
        if not serializer.is_valid():
            return Response({
                'status': 'error',
                'message': 'Dữ liệu không hợp lệ',
                'data': serializer.errors
            }, status=status.HTTP_400_BAD_REQUEST)

        serializer.save()
        return Response({
            'status': 'success',
            'message': 'Cập nhật hồ sơ thành công',
            'data': serializer.data
        }, status=status.HTTP_200_OK)


class EmployeeChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        try:
            # Lấy user hiện tại
            user = request.user

            # Serialize và xác minh dữ liệu
            serializer = EmployeeChangePasswordSerializer(data=request.data)
            if serializer.is_valid():
                old_password = serializer.validated_data['old_password']
                new_password = serializer.validated_data['new_password']
                
                # Kiểm tra mật khẩu cũ
                if not user.check_password(old_password):
                    return Response({
                        'status': 'error',
                        'message': 'Mật khẩu cũ không đúng',
                        'data': {}
                    }, status=status.HTTP_400_BAD_REQUEST)

                # Kiểm tra nếu mật khẩu cũ giống mật khẩu mới
                if old_password == new_password:
                    return Response({
                        'status': 'error',
                        'message': 'Mật khẩu mới không được giống mật khẩu cũ',
                        'data': {}
                    }, status=status.HTTP_400_BAD_REQUEST)

                # Đổi mật khẩu và lưu
                user.set_password(new_password)
                user.save()

                # Cập nhật session auth hash
                update_session_auth_hash(request, user)

                return Response({
                    'status': 'success',
                    'message': 'Cập nhât mật khẩu thành công',
                    'data': {}
                })
            else:
                return Response({
                    'status': 'error',
                    'message': 'Invalid data provided',
                    'data': serializer.errors
                }, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e),
                'data': {}
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class EmployeeForgotPasswordView(APIView):

    def post(self, request):
        try:
            email = request.data.get('email')  # Lấy email từ body request

            if not email:
                return Response({
                    'status': 'error',
                    'message': 'Tài khoản email là bắt buộc',
                    'data': {}
                }, status=status.HTTP_400_BAD_REQUEST)

            # Lấy thông tin Employee từ email
            employee = Employee.objects.filter(email=email).first()

            if not employee:
                return Response({
                    'status': 'error',
                    'message': 'Không tìm thấy tài khoản với email này',
                    'data': {}
                }, status=status.HTTP_404_NOT_FOUND)
            
            # Tạo OTP mới
            otp = generate_otp()

            # Lưu OTP vào Redis với thời gian hết hạn (ví dụ 5 phút)
            redis_client.setex(f"otp:{employee.email}", 300, otp)

            # Gửi OTP qua email
            send_mail(
                subject="Mã OTP để đặt lại mật khẩu",
                message=f"Mã OTP của bạn là {otp}. Nó sẽ hết hạn trong vòng 5 phút.",
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[employee.email],
                fail_silently=False
            )

            return Response({
                'status': 'success',
                'message': 'Mã OTP đã được gửi đến email của bạn',
                'data': {}
            })
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e),
                'data': {}
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class EmployeeResetPasswordView(APIView):

    def post(self, request):
        # Serialize dữ liệu
        serializer = EmployeeResetPasswordSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            otp = serializer.validated_data['otp']
            new_password = serializer.validated_data['new_password']

            # Kiểm tra OTP trong Redis
            stored_otp = redis_client.get(f"otp:{email}")
            
            if stored_otp is None:
                return Response({
                    'status': 'error',
                    'message': 'Mã OTP đã hết hạn hoặc không hợp lệ',
                    'data': {}
                }, status=status.HTTP_400_BAD_REQUEST)

            # Kiểm tra OTP đúng không
            if stored_otp != otp:
                return Response({
                    'status': 'error',
                    'message': 'Mã OTP không chính xác',
                    'data': {}
                }, status=status.HTTP_400_BAD_REQUEST)

            # Cập nhật mật khẩu mới
            try:
                employee = Employee.objects.get(email=email)
                employee_account = employee.employeeaccount

                # —— Chèn kiểm tra ở đây ——
                if check_password(new_password, employee_account.password):
                    return Response({
                        'status': 'error',
                        'message': 'Mật khẩu mới không được trùng với mật khẩu cũ.',
                        'data': {}
                    }, status=status.HTTP_400_BAD_REQUEST)

                # Nếu khác, thì mới cập nhật
                employee_account.password = make_password(new_password)
                employee_account.save()
                redis_client.delete(f"otp:{email}")

                return Response({
                    'status': 'success',
                    'message': 'Cập nhật mật khẩu thành công',
                    'data': {}
                })
            except Employee.DoesNotExist:
                return Response({
                    'status': 'error',
                    'message': 'Không tìm thấy tài khoản với email này',
                    'data': {}
                }, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({
                'status': 'error',
                'message': 'Dữ liệu không hợp lệ',
                'data': serializer.errors
            }, status=status.HTTP_400_BAD_REQUEST)


class EmployeeViewSet(viewsets.ModelViewSet):
    parser_classes = [MultiPartParser, FormParser]
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer
    filter_backends = [SearchFilter]
    # permission_classes = [IsAuthenticated]
    # authentication_classes = [TokenAuthentication]

    def get_serializer_class(self):
        if self.action == 'create':
            return EmployeeRegistrationSerializer
        elif self.action in ('update', 'partial_update'):
            return EmployeeProfileUpdateSerializer
        return EmployeeSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        
        if serializer.is_valid():
            employee = serializer.save()

            return Response({
                "status": "success",
                "message": "Nhân viên mới được thêm thành công.",
                "data": {
                    "employee_id": employee.id,
                    "full_name": employee.full_name,
                    "gender": employee.gender,
                    "date_of_birth": employee.date_of_birth,
                    "role": employee.employeeaccount.role,
                    "email": employee.email,
                    "phone_number": employee.phone_number,
                    "citizen_id": employee.citizen_id,
                    "address": employee.address,
                    "image": employee.image.url if employee.image else None,
                    "is_active": employee.employeeaccount.is_active,
                    'created_at': employee.created_at,
                    'updated_at': employee.updated_at
                }
            }, status=status.HTTP_201_CREATED)
        
        return Response({
            "status": "error",
            "message": "Invalid data",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)
    
    def update(self, request, *args, **kwargs):
        employee = self.get_object()
        serializer = self.get_serializer(employee, data=request.data, partial=True)

        if serializer.is_valid():
            employee = serializer.save()

            return Response({
                "status": "success",
                "message": "Thông tin nhân viên đã được cập nhật.",
                "data": {
                    "employee_id": employee.id,
                    "full_name": employee.full_name,
                    "gender": employee.gender,
                    "date_of_birth": employee.date_of_birth,
                    "role": employee.employeeaccount.role,
                    "email": employee.email,
                    "phone_number": employee.phone_number,
                    "citizen_id": employee.citizen_id,
                    "address": employee.address,
                    "image": employee.image.url if employee.image else None,
                    "is_active": employee.employeeaccount.is_active,
                    'created_at': employee.created_at,
                    'updated_at': employee.updated_at
                }
            }, status=status.HTTP_200_OK)

        return Response({
            "status": "error",
            "message": "Invalid data",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)

    # Action để vô hiệu hóa account nhân viên
    @action(detail=True, methods=['post'])
    def disable_account(self, request, pk=None):
        try:
            employee_account = EmployeeAccount.objects.get(employee__id=pk)

            if not employee_account.is_active:
                return Response({"message": "Tài khoản hiện đang vô hiệu hóa."}, status=status.HTTP_400_BAD_REQUEST)

            employee_account.is_active = False
            employee_account.save()
            return Response({"message": "Vô hiệu hóa tài khoản thành công."}, status=status.HTTP_200_OK)
        except EmployeeAccount.DoesNotExist:
            return Response({"message": "Không tim thấy tài khoản nhân viên."}, status=status.HTTP_404_NOT_FOUND)

    # Action để mở khóa tài khoản nhân viên
    @action(detail=True, methods=['post'])
    def enable_account(self, request, pk=None):
        try:
            employee_account = EmployeeAccount.objects.get(employee__id=pk)

            if employee_account.is_active:
                return Response({"message": "Tài khoản hiện đang hoạt động."}, status=status.HTTP_400_BAD_REQUEST)

            employee_account.is_active = True
            employee_account.save()
            return Response({"message": "Kích hoạt tài khoản thành công."}, status=status.HTTP_200_OK)
        except EmployeeAccount.DoesNotExist:
            return Response({"message": "Không tim thấy tài khoản nhân viên."}, status=status.HTTP_404_NOT_FOUND)
        
    def destroy(self, request, *args, **kwargs):
        try:
            employee = self.get_object()

            employee.delete()

            return Response({"message": "Đã xóa thành công nhân viên và tài khoản liên quan."}, status=status.HTTP_204_NO_CONTENT)

        except Employee.DoesNotExist:
            return Response({"message": "Không tìm thấy nhân viên này."}, status=status.HTTP_404_NOT_FOUND)
        

class CustomerLoginView(APIView):
    # permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = LoginSerializer(data=request.data)

        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']

            try:
                customer_account = CustomerAccount.objects.get(username=username)

                if check_password(password, customer_account.password):

                    if not customer_account.is_verified:
                        return Response({
                            "status": "error",
                            "message": "Tài khoản chưa được xác thực.",
                        }, status=status.HTTP_400_BAD_REQUEST)

                    customer = customer_account.customer

                    refresh = RefreshToken.for_user(customer_account)
                    access_token = str(refresh.access_token)

                    return Response({
                        "status": "success",
                        "message": "Đăng nhập thành công.",
                        "data": {
                            "access_token": access_token,
                            "refresh_token": str(refresh),
                            "customer": {
                                "customer_id": customer.id,
                                "full_name": customer.full_name,
                                "email": customer.email
                            }
                        }
                    }, status=status.HTTP_200_OK)
                else:
                    return Response({
                        "status": "error",
                        "message": "Mật khẩu không đúng.",
                    }, status=status.HTTP_400_BAD_REQUEST)

            except CustomerAccount.DoesNotExist:
                return Response({
                    "status": "error",
                    "message": "Tên đăng nhập không tồn tại.",
                }, status=status.HTTP_400_BAD_REQUEST)
        
        return Response({
            "status": "error",
            "message": "Thông tin đăng nhập không hợp lệ.",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)
    

# class CustomerViewSet(viewsets.ModelViewSet):
#     queryset = Customer.objects.all()
#     serializer_class = CustomerSerializer
#     filter_backends = [SearchFilter]

#     def get_serializer_class(self):
#         if self.action == 'create':
#             return CustomerRegistrationSerializer
#         elif self.action == 'update':
#             return CustomerUpdateSerializer
#         return CustomerSerializer


class CustomerRegistrationView(APIView):

    def post(self, request, *args, **kwargs):
        serializer = CustomerRegistrationSerializer(data=request.data)
        
        if serializer.is_valid():
            customer = serializer.save()

            # Tạo OTP (6 chữ số ngẫu nhiên)
            otp = ''.join(random.choices(string.digits, k=6))

            # Lưu OTP vào Redis (hết hạn trong 5 phút)
            redis_client.setex(f"otp_{customer.email}", 300, otp)  # Lưu OTP với key 'otp_email' và hết hạn sau 5 phút

            # Gửi OTP qua email
            send_mail(
                'Xác thực tài khoản của bạn',
                f'Mã OTP của bạn là: {otp}',
                'hattoriheiji48691810@gmail.com',  # Địa chỉ email người gửi
                [customer.email],  # Địa chỉ email người nhận
                fail_silently=False,
            )

            return Response({
                "status": "success",
                "message": "Đăng ký tài khoản thành công. Mã OTP đã được gửi vào email của bạn.",
                "data": {
                    "customer_id": customer.id,
                    "full_name": customer.full_name,
                    "email": customer.email,
                    "phone_number": customer.phone_number
                }
            }, status=status.HTTP_201_CREATED)

        return Response({
            "status": "error",
            "message": "Invalid data",
            "errors": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)


class CustomerVerifyOTPView(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        otp = request.data.get('otp')

        # Kiểm tra xem email và OTP có hợp lệ không
        if not email or not otp:
            return Response({
                "status": "error",
                "message": "Email và OTP là bắt buộc."
            }, status=status.HTTP_400_BAD_REQUEST)

        # Kiểm tra OTP trong Redis
        stored_otp = redis_client.get(f"otp_{email}")

        if stored_otp is None:
            return Response({
                "status": "error",
                "message": "OTP đã hết hạn hoặc không hợp lệ."
            }, status=status.HTTP_400_BAD_REQUEST)

        if stored_otp != otp:
            return Response({
                "status": "error",
                "message": "Mã OTP không chính xác."
            }, status=status.HTTP_400_BAD_REQUEST)

        # Nếu OTP hợp lệ, xác minh tài khoản
        try:
            customer = Customer.objects.get(email=email)
            customer_account = CustomerAccount.objects.get(customer=customer)
            customer_account.is_verified = True
            customer_account.save()

            # Xóa OTP đã sử dụng khỏi Redis
            redis_client.delete(f"otp_{email}")

            return Response({
                "status": "success",
                "message": "Xác thực tài khoản thành công."
            }, status=status.HTTP_200_OK)

        except Customer.DoesNotExist:
            return Response({
                "status": "error",
                "message": "Không tìm thấy tài khoản với email này."
            }, status=status.HTTP_400_BAD_REQUEST)


class ResendOTPView(APIView):
    def post(self, request, *args, **kwargs):
        username = request.data.get('username')  # Lấy email người dùng từ request

        if not username:
            return Response({
                "status": "error",
                "message": "Username là bắt buộc."
            }, status=status.HTTP_400_BAD_REQUEST)

        try:

            # Kiểm tra xem tài khoản customer có tồn tại và chưa được xác thực
            customer_account = CustomerAccount.objects.get(username=username)

            if customer_account.is_verified:
                return Response({
                    "status": "error",
                    "message": "Tài khoản đã được xác thực."
                }, status=status.HTTP_400_BAD_REQUEST)

            # Tạo OTP (6 chữ số ngẫu nhiên)
            otp = ''.join(random.choices(string.digits, k=6))

            email = customer_account.customer.email  # Lấy email từ tài khoản customer

            # Lưu OTP vào Redis (hết hạn trong 5 phút)
            redis_client.setex(f"otp_{email}", 300, otp)  # Lưu OTP với key 'otp_email' và hết hạn sau 5 phút

            # Gửi OTP qua email
            send_mail(
                'Xác thực tài khoản của bạn',
                f'Mã OTP của bạn là: {otp}',
                'hattoriheiji48691810@gmail.com',  # Địa chỉ email người gửi
                [email],  # Địa chỉ email người nhận
                fail_silently=False,
            )

            return Response({
                "status": "success",
                "message": "Mã OTP đã được gửi vào email của bạn.",
                "data": {
                    "email": email
                }
            }, status=status.HTTP_200_OK)

        except CustomerAccount.DoesNotExist:
            return Response({
                "status": "error",
                "message": "Không tìm thấy tài khoản với username này."
            }, status=status.HTTP_400_BAD_REQUEST)


def is_valid_user(customer_id, token):
    """
    Helper function to check if the username in the token matches the username 
    in the CustomerAccount associated with the provided customer_id. Also checks 
    for token validity (including expiration).
    """
    try:
        # Decode the token and extract user_id
        decoded_token = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
        username_from_token = decoded_token.get('user_id')

        # Fetch the username associated with the customer_id
        user_id = CustomerAccount.objects.get(username=username_from_token).customer_id

        # Compare the username in the token with the username in the database
        if str(user_id) != str(customer_id):
            return False, "Không có quyền truy cập tài khoản này."
        
        # If everything checks out
        return True, None

    except jwt.ExpiredSignatureError:
        return False, "Token đã hết hạn."
    except jwt.InvalidTokenError:
        return False, "Token không hợp lệ."
    except CustomerAccount.DoesNotExist:
        return False, "Customer không tồn tại."
    

def check_for_token(request):
    """
    Helper function to check if the token is provided in the query parameters.
    If the token is missing, it returns a Response indicating the error.
    Otherwise, it returns None.
    """
    token = request.query_params.get('token')  # Get token from query parameters
    if token is None:
        return Response({"error": "Bạn không có quyền truy cập. Cần phải có token."}, status=status.HTTP_403_FORBIDDEN)
    return None


class CustomerDetailView(APIView):
    # permission_classes = [IsCustomer]
    # authentication_classes = [TokenAuthentication]

    def get(self, request):
        customer_id = request.query_params.get('id')  # Get customer id from query parameters

        if customer_id is None:
            return Response({
                "status": "error",
                "message": "Cần phải có Customer ID.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Fetch customer details from the database
            customer = Customer.objects.get(id=customer_id)
            serializer = CustomerSerializer(customer)

            # Success response
            return Response({
                "status": "success",
                "message": "Lấy thông tin thành công.",
                "data": serializer.data
            }, status=status.HTTP_200_OK)

        except Customer.DoesNotExist:
            return Response({
                "status": "error",
                "message": "Không tìm thấy khách hàng này.",
                "data": None
            }, status=status.HTTP_404_NOT_FOUND)


class CustomerUpdateView(APIView):

    def put(self, request, *args, **kwargs):
        customer_id = request.query_params.get('id')  # Get customer id from query parameters

        if customer_id is None:
            return Response({
                "status": "error",
                "message": "Cần phải có Customer ID.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Fetch customer object from the database
            customer = Customer.objects.get(id=customer_id)
            
            # Use a serializer to validate and update customer data
            serializer = CustomerUpdateSerializer(customer, data=request.data, partial=True, context={'id': customer.id})

            if serializer.is_valid():
                serializer.save()  # Save the updated data
                return Response({
                    "status": "success",
                    "message": "Cập nhật thông tin thành công.",
                    "data": serializer.data
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    "status": "error",
                    "message": "Dữ liệu không hợp lệ.",
                    "errors": serializer.errors
                }, status=status.HTTP_400_BAD_REQUEST)

        except Customer.DoesNotExist:
            return Response({
                "status": "error",
                "message": "Không tìm thấy khách hàng này.",
                "errors": None
            }, status=status.HTTP_404_NOT_FOUND)


class CustomerPasswordChangeView(APIView):

    def put(self, request):
        # Get the customer_id from the request
        customer_id = request.query_params.get('id')
        if customer_id is None:
            return Response({
                "status": "error",
                "message": "Cần phải có Customer ID.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        # If customer_id is provided, proceed with password change
        serializer = PasswordChangeSerializer(data=request.data)

        # Check if all fields are provided
        if not request.data.get('old_password') or not request.data.get('new_password') or not request.data.get('confirm_new_password'):
            return Response({
                "status": "error",
                "message": "Các trường (old_password, new_password, confirm_new_password) cần phải có.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        if serializer.is_valid():
            old_password = serializer.validated_data['old_password']
            new_password = serializer.validated_data['new_password']
            confirm_new_password = serializer.validated_data['confirm_new_password']
            
            # Check if the new password is the same as the old password
            if new_password == old_password:
                return Response({
                    "status": "error",
                    "message": "Mật khẩu mới không được giống mật khẩu cũ.",
                    "data": None
                }, status=status.HTTP_400_BAD_REQUEST)

            # Check if new passwords match
            if new_password != confirm_new_password:
                return Response({
                    "status": "error",
                    "message": "Mật khẩu mới không khớp.",
                    "data": None
                }, status=status.HTTP_400_BAD_REQUEST)

            # Check if the new password is at least 8 characters
            if len(new_password) < 8:
                return Response({
                    "status": "error",
                    "message": "Mật khẩu mới phải có ít nhất 8 ký tự.",
                    "data": None
                }, status=status.HTTP_400_BAD_REQUEST)

            # Check if the old password matches the current password in the database
            try:
                customer_account = CustomerAccount.objects.get(customer_id=customer_id)
            except CustomerAccount.DoesNotExist:
                return Response({
                    "status": "error",
                    "message": "Không tìm thấy tài khoản.",
                    "data": None
                }, status=status.HTTP_404_NOT_FOUND)

            if not check_password(old_password, customer_account.password):
                return Response({
                    "status": "error",
                    "message": "Sai mật khẩu cũ.",
                    "data": None
                }, status=status.HTTP_400_BAD_REQUEST)

            # Set the new password
            customer_account.password = make_password(new_password)
            customer_account.save()

            return Response({
                "status": "success",
                "message": "Thay đổi mật khẩu thành công.",
                "data": None
            }, status=status.HTTP_200_OK)

        return Response({
            "status": "error",
            "message": "Invalid data",
            "data": serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)

    
# Chưa auth token và check id
class CustomerForgotPasswordView(APIView):

    def post(self, request, *args, **kwargs):
        # Step 1: Get the email from the request data
        email = request.data.get('email')

        if not id:
            return Response({
                "status": "error",
                "message": "Cần phải có email của Customer.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        # Step 2: Check if the email exists in the database
        try:
            customer = Customer.objects.get(email=email)
        except Customer.DoesNotExist:
            return Response({
                "status": "error",
                "message": "Không tìm thấy tài khoản này.",
                "data": None
            }, status=status.HTTP_404_NOT_FOUND)
        
        # email = customer.email
        # print(email)

        # Step 3: Generate a 6-digit OTP
        otp = ''.join(random.choices(string.digits, k=6))

        # Step 4: Store the OTP in Redis (valid for 5 minutes)
        print(f"Storing OTP: otp_{email} with value {otp} in Redis")
        redis_client.setex(f"forgot_password_otp_{email}", 300, otp)  # Key: 'forgot_password_otp_<email>', Expiry: 300 seconds (5 minutes)

        send_mail(
            'Password Reset OTP',
            f'Your OTP for resetting the password is: {otp}.',
            'hattoriheiji48691810@gmail.com',  # From email
            [email],  # To email
            fail_silently=False,
        )

        # Step 6: Return a success response
        return Response({
            "status": "success",
            "message": "Mã OTP đã được gửi vào email của bạn.",
            "data": None
        }, status=status.HTTP_200_OK)
    

class CustomerResetPasswordView(APIView):

    def put(self, request):
        # Step 1: Get the email, OTP, and new password from the request
        email = request.data.get('email')  # Add email to the request body
        otp = request.data.get('otp')  # Use data instead of query_params for consistency
        new_password = request.data.get('new_password')

        if not email or not otp or not new_password:
            return Response({
                "status": "error",
                "message": "Email, OTP, và mật khẩu mới là bắt buộc.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        # Step 2: Retrieve the stored OTP from Redis using the email
        stored_otp = redis_client.get(f"forgot_password_otp_{email}")
        print(f"Retrieved OTP: {stored_otp} for email: {email} from Redis")

        if stored_otp != otp:
            return Response({
                "status": "error",
                "message": "Mã OTP không chính xác hoặc đã hết hạn.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        # Step 3: Retrieve the user by email and reset the password
        try:
            customer = Customer.objects.get(email=email)
        except Customer.DoesNotExist:
            return Response({
                "status": "error",
                "message": "Không tìm thấy tài khoản này.",
                "data": None
            }, status=status.HTTP_404_NOT_FOUND)

        # Step 4: Check if the new password is the same as the old password
        customer_account = customer.customeraccount
        if check_password(new_password, customer_account.password):
            return Response({
                "status": "error",
                "message": "Mật khẩu mới không được trùng với mật khẩu cũ.",
                "data": None
            }, status=status.HTTP_400_BAD_REQUEST)

        # Step 5: Update the password
        customer_account.password = make_password(new_password)
        customer_account.save()

        # Step 6: Remove the OTP from Redis
        redis_client.delete(f"forgot_password_otp_{email}")

        return Response({
            "status": "success",
            "message": "Đặt lại mật khẩu thành công.",
            "data": None
        }, status=status.HTTP_200_OK)
    

class CustomerAdminViewSet(viewsets.ModelViewSet):
    """
    - list:    GET    /admin/customers/          → lấy tất cả Customer
    - create:  POST   /admin/customers/          → tạo mới Customer (không tạo account)
    - update:  PUT    /admin/customers/{pk}/     → cập nhật Customer
    - partial_update: PATCH /admin/customers/{pk}/
    - destroy: DELETE /admin/customers/{pk}/     → nếu cần xóa
    """
    queryset = Customer.objects.all()
    filter_backends = [SearchFilter]
    search_fields = ['full_name', 'phone_number', 'email']
    # permission_classes = [IsAuthenticated]  # hoặc IsStaff tuỳ setup

    def get_serializer_class(self):
        if self.action in ('create', 'update', 'partial_update'):
            return CustomerCreateUpdateSerializer
        return CustomerSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        customer = serializer.save()

        from django.contrib.auth.hashers import make_password

        username = customer.phone_number
        password = ''.join(random.choices(string.ascii_letters + string.digits, k=8))  # Random password of length 8
        customer_account = CustomerAccount.objects.create(
            username=username,
            password=make_password(password),  # Note: You may want to hash the password before saving
            customer=customer
        )
        customer_account.save()

        return Response({
            "status": "success",
            "message": "Customer được tạo thành công.",
            "data": CustomerSerializer(customer).data
        }, status=status.HTTP_201_CREATED)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        customer = serializer.save()
        return Response({
            "status": "success",
            "message": "Customer được cập nhật thành công.",
            "data": CustomerSerializer(customer).data
        }, status=status.HTTP_200_OK)

    def destroy(self, request, *args, **kwargs):
        customer = self.get_object()

        # 1. Khách hàng đã có account thì không thể xóa
        if CustomerAccount.objects.filter(customer=customer, is_verified=True).exists():
            return Response({
                "status": "error",
                "message": "Khách hàng có tài khoản đã xác thực."
            }, status=status.HTTP_400_BAD_REQUEST)

        # 2. Khách hàng đã có đơn hàng thì không thể xóa
        if Order.objects.filter(user=customer).exists():
            return Response({
                "status": "error",
                "message": "Không thể xóa: khách hàng đã có đơn hàng."
            }, status=status.HTTP_400_BAD_REQUEST)

        # 3. Xóa thành công
        customer.delete()
        return Response({
            "status": "success",
            "message": "Xóa khách hàng thành công."
        }, status=status.HTTP_200_OK)