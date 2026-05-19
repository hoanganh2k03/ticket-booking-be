from celery import shared_task
from django.conf import settings
from django.core.cache import cache
from django.core.mail import EmailMessage
from django.db import transaction
from io import BytesIO
import errno
import logging
import qrcode

from .models import Order, Payment

logger = logging.getLogger(__name__)


def send_invoice_email_now(order_id, payment_id):
    order = Order.objects.get(order_id=order_id)
    payment = Payment.objects.get(payment_id=payment_id)

    if not order.user or not getattr(order.user, 'email', None):
        logger.info("Order %s has no user/email, skipping invoice send.", order_id)
        return {'status': 'skipped', 'reason': 'no_email'}

    subject = f"Hoa don thanh toan cho don hang {order.order_id}"
    message = (
        f"Chao {order.user.full_name if order.user else 'Khach hang'},\n\n"
        "Cam on ban da mua ve tai he thong chung toi.\n\n"
        f"Ma don hang: {order.order_id}\n"
        f"Tong tien: {order.total_amount} VND\n"
        f"Trang thai thanh toan: {payment.payment_status}\n"
        f"Phuong thuc thanh toan: {payment.payment_method}\n"
        f"Ma giao dich: {payment.transaction_code}\n\n"
        "Tran trong,\n"
        "He thong ban ve truc tuyen"
    )

    email = EmailMessage(subject, message, settings.DEFAULT_FROM_EMAIL, [order.user.email])
    for i, order_detail in enumerate(order.order_details.all(), start=1):
        qr_payload = f"{order.order_id}|{order_detail.detail_id}"
        img = qrcode.make(qr_payload)
        buf = BytesIO()
        img.save(buf, format='PNG')
        email.attach(f'qr_code_{i}.png', buf.getvalue(), 'image/png')

    logger.info(
        "Sending invoice email for order %s via %s:%s to %s",
        order_id,
        settings.EMAIL_HOST,
        settings.EMAIL_PORT,
        order.user.email,
    )
    email.send(fail_silently=False)
    logger.info('Invoice email sent for order %s', order_id)
    return {'status': 'sent'}


def enqueue_invoice_email(order, payment):
    if not getattr(order.user, 'email', None):
        logger.info("Order %s has no user/email, skipping invoice enqueue.", order.order_id)
        return

    cache_key = f"invoice_email_queued:{payment.payment_id}"
    if not cache.add(cache_key, True, timeout=7 * 24 * 60 * 60):
        logger.info("Invoice email already queued for payment %s", payment.payment_id)
        return

    def _enqueue():
        try:
            send_invoice_email_task.delay(str(order.order_id), payment.payment_id)
            logger.info("Invoice email task queued for order %s", order.order_id)
        except Exception:
            cache.delete(cache_key)
            logger.exception("Failed to enqueue invoice email task for order %s", order.order_id)

    transaction.on_commit(_enqueue)


@shared_task(bind=True, max_retries=3, default_retry_delay=60, name='apps.orders.tasks.send_invoice_email_task')
def send_invoice_email_task(self, order_id, payment_id):
    try:
        return send_invoice_email_now(order_id, payment_id)
    except OSError as exc:
        if getattr(exc, 'errno', None) in (errno.ENETUNREACH, errno.EHOSTUNREACH):
            logger.error(
                "SMTP network is unreachable for order %s. Check outbound SMTP/network policy and EMAIL_HOST/EMAIL_PORT.",
                order_id,
                exc_info=True,
            )
            return {'status': 'failed', 'error': str(exc), 'retryable': False}
        logger.exception('Failed to send invoice email for order %s: %s', order_id, exc)
        raise self.retry(exc=exc)
    except Exception as exc:
        logger.exception('Failed to send invoice email for order %s: %s', order_id, exc)
        raise self.retry(exc=exc)
