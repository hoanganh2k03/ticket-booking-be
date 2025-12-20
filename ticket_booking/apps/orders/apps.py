# from django.apps import AppConfig



# class OrdersConfig(AppConfig):
#     default_auto_field = "django.db.models.BigAutoField"
#     name = "apps.orders"

#     def ready(self):
#         from .scheduler import startJob
#         startJob()
#         import apps.orders.signals
import os
from django.apps import AppConfig

class OrdersConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.orders"

    def ready(self):
        # 1. Luôn import Signals để tính năng hoàn điểm hoạt động
        import apps.orders.signals

        # 2. Cấu hình Scheduler (Chỉ chạy 1 lần)
        # runserver sẽ set biến môi trường RUN_MAIN='true' ở tiến trình con
        if os.environ.get('RUN_MAIN') == 'true':
            try:
                from .scheduler import startJob
                startJob()
                print("✅ [SCHEDULER] Đã khởi động thành công (Running in Main Process)")
            except Exception as e:
                print(f"❌ [SCHEDULER ERROR] Không thể khởi động: {e}")