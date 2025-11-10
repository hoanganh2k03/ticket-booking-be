# apps/tickets/celery.py
import os
from celery import Celery
from django.conf import settings

# Đặt môi trường DJANGO_SETTINGS_MODULE
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ticket_booking.settings')

# Khởi tạo Celery app với tên 'ticket_booking'
app = Celery('ticket_booking')

# Cấu hình Celery từ Django settings, prefix bắt đầu với 'CELERY'
app.config_from_object('django.conf:settings', namespace='CELERY')

# Tự động tìm kiếm task trong các app
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
