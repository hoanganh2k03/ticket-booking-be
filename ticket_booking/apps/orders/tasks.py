from celery import shared_task
from django.conf import settings
from django.core.mail import EmailMessage
from io import BytesIO
import qrcode
import base64
import logging

from .models import Order, Payment

logger = logging.getLogger(__name__)


@shared_task(bind=True, max_retries=3, default_retry_delay=60)
def send_invoice_email_task(self, order_id, payment_id):
    try:
        order = Order.objects.get(order_id=order_id)
        payment = Payment.objects.get(payment_id=payment_id)

        if not order.user or not getattr(order.user, 'email', None):
            logger.info("Order %s has no user/email, skipping invoice send.", order_id)
            return {'status': 'skipped', 'reason': 'no_email'}

        subject = f"Hóa đơn thanh toán cho đơn hàng {order.order_id}"
        message = f"Chào {order.user.full_name if order.user else 'Khách hàng'},\n\nCảm ơn bạn đã mua vé tại hệ thống chúng tôi.\n\nMã đơn hàng: {order.order_id}\nTổng tiền: {order.total_amount} VND\nTrạng thái thanh toán: {payment.payment_status}\nPhương thức thanh toán: {payment.payment_method}\nMã giao dịch: {payment.transaction_code}\n\nTrân trọng,\nHệ thống bán vé trực tuyến"

        # Generate QR images for each order detail
        qr_images = []
        for od in order.order_details.all():
            qr_payload = f"{order.order_id}|{od.detail_id}"
            img = qrcode.make(qr_payload)
            buf = BytesIO()
            img.save(buf, format='PNG')
            buf.seek(0)
            qr_images.append(buf.getvalue())

        email = EmailMessage(subject, message, settings.DEFAULT_FROM_EMAIL, [order.user.email])
        for i, img_bytes in enumerate(qr_images, start=1):
            email.attach(f'qr_code_{i}.png', img_bytes, 'image/png')

        email.send(fail_silently=False)
        logger.info('Invoice email sent for order %s', order_id)
        return {'status': 'sent'}
    except Exception as exc:
        logger.exception('Failed to send invoice email for order %s: %s', order_id, exc)
        try:
            # retry with exponential backoff
            raise self.retry(exc=exc)
        except Exception:
            # If retry not possible, just log and exit
            logger.exception('Retry failed for send_invoice_email_task for order %s', order_id)
            return {'status': 'failed', 'error': str(exc)}
