from celery import shared_task
from django.conf import settings
from django.core.cache import cache
from django.core.mail import EmailMessage
from django.db import transaction
from io import BytesIO
import base64
import errno
import logging
import qrcode
import requests

from .models import Order, Payment

logger = logging.getLogger(__name__)


def _build_invoice_email(order, payment):
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

    attachments = []
    for i, order_detail in enumerate(order.order_details.all(), start=1):
        qr_payload = f"{order.order_id}|{order_detail.detail_id}"
        img = qrcode.make(qr_payload)
        buf = BytesIO()
        img.save(buf, format='PNG')
        img_bytes = buf.getvalue()
        attachments.append({
            'filename': f'qr_code_{i}.png',
            'content': base64.b64encode(img_bytes).decode('ascii'),
            'content_type': 'image/png',
            'bytes': img_bytes,
        })

    return subject, message, attachments


def _send_invoice_with_resend(order, payment, subject, message, attachments):
    if not settings.RESEND_API_KEY:
        raise RuntimeError('RESEND_API_KEY is not configured')

    payload = {
        'from': settings.RESEND_FROM_EMAIL,
        'to': [order.user.email],
        'subject': subject,
        'text': message,
        'attachments': [
            {
                'filename': attachment['filename'],
                'content': attachment['content'],
                'content_type': attachment['content_type'],
            }
            for attachment in attachments
        ],
    }
    headers = {
        'Authorization': f'Bearer {settings.RESEND_API_KEY}',
        'Content-Type': 'application/json',
        'Idempotency-Key': f'invoice-{payment.payment_id}',
    }

    logger.info(
        "Sending invoice email for order %s via Resend API to %s",
        order.order_id,
        order.user.email,
    )
    response = requests.post(
        settings.RESEND_API_URL,
        json=payload,
        headers=headers,
        timeout=settings.EMAIL_API_TIMEOUT,
    )
    if response.status_code >= 400:
        raise RuntimeError(f"Resend API error {response.status_code}: {response.text[:500]}")

    data = response.json()
    logger.info('Invoice email sent for order %s via Resend id=%s', order.order_id, data.get('id'))
    return {'status': 'sent', 'provider': 'resend', 'id': data.get('id')}


def _send_invoice_with_smtp(order, subject, message, attachments):
    email = EmailMessage(subject, message, settings.DEFAULT_FROM_EMAIL, [order.user.email])
    for attachment in attachments:
        email.attach(attachment['filename'], attachment['bytes'], attachment['content_type'])

    logger.info(
        "Sending invoice email for order %s via %s:%s to %s",
        order.order_id,
        settings.EMAIL_HOST,
        settings.EMAIL_PORT,
        order.user.email,
    )
    email.send(fail_silently=False)
    logger.info('Invoice email sent for order %s via SMTP', order.order_id)
    return {'status': 'sent', 'provider': 'smtp'}


def send_invoice_email_now(order_id, payment_id):
    order = Order.objects.get(order_id=order_id)
    payment = Payment.objects.get(payment_id=payment_id)

    if not order.user or not getattr(order.user, 'email', None):
        logger.info("Order %s has no user/email, skipping invoice send.", order_id)
        return {'status': 'skipped', 'reason': 'no_email'}

    subject, message, attachments = _build_invoice_email(order, payment)
    if settings.EMAIL_PROVIDER == 'resend':
        return _send_invoice_with_resend(order, payment, subject, message, attachments)
    return _send_invoice_with_smtp(order, subject, message, attachments)


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
