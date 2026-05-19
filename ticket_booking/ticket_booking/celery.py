# apps/tickets/celery.py
import os
import socket
from urllib.parse import urlparse
from celery import Celery
from django.conf import settings
import logging

logger = logging.getLogger(__name__)

# Đặt môi trường DJANGO_SETTINGS_MODULE
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ticket_booking.settings')

# Khởi tạo Celery app với tên 'ticket_booking'
app = Celery('ticket_booking')

# Cấu hình Celery từ Django settings, prefix bắt đầu với 'CELERY'
app.config_from_object('django.conf:settings', namespace='CELERY')

# Use Django settings broker URL, fallback to REDIS_URL if missing or unset.
def _get_broker_url():
    broker_url = getattr(settings, 'CELERY_BROKER_URL', None) or os.environ.get('REDIS_URL')
    if not broker_url or broker_url in ('${REDIS_URL}', '$REDIS_URL'):
        broker_url = getattr(settings, 'REDIS_URL', None)
    return broker_url

def _validate_and_choose_broker():
    url = _get_broker_url()
    if not url:
        logger.warning('No broker URL configured; Celery will start without broker.')
        return url

    parsed = urlparse(url)
    scheme = parsed.scheme.lower()

    # If broker is AMQP/RabbitMQ, check DNS resolution of hostname
    if scheme in ('amqp', 'amqps') and parsed.hostname:
        try:
            socket.getaddrinfo(parsed.hostname, parsed.port or 5672)
        except Exception as exc:
            logger.warning('Broker host %s not resolvable (%s). Falling back to REDIS_URL.', parsed.hostname, exc)
            # fallback to redis if configured
            redis_url = getattr(settings, 'REDIS_URL', None) or os.environ.get('REDIS_URL')
            if redis_url:
                logger.info('Using fallback broker URL: %s', redis_url)
                return redis_url
            else:
                logger.error('No REDIS_URL found to fall back to.')
                return url

    return url


app.conf.broker_url = _validate_and_choose_broker()

# Log chosen broker for visibility
try:
    logger.info('Celery broker URL configured as: %s', app.conf.broker_url)
except Exception:
    pass

# Tự động tìm kiếm task trong các app
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
