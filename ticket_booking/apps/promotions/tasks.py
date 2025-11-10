from celery import shared_task
from django.utils import timezone
from .models import Promotion
import logging

logger = logging.getLogger(__name__)

@shared_task
def set_promotion_status(promo_id, status):
    logger.info(f"[Promotions] Task set_promotion_status chạy: promo_id={promo_id}, status={status}")
    # Cập nhật status
    updated = Promotion.objects.filter(promo_id=promo_id).update(status=status)
    if updated:
        logger.info(f"[Promotions] Update successful promo_id={promo_id} → status={status}")
    else:
        logger.warning(f"[Promotions] Update fail promo_id={promo_id}")