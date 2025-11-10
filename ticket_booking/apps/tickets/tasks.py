# apps/tickets/tasks.py
# apps/tickets/tasks.py

import logging
from celery import shared_task
from django.utils import timezone
from .models import SectionPrice, PriceHistory

logger = logging.getLogger(__name__)

@shared_task(name='tickets.tasks.update_section_prices')
def update_section_prices():
    now = timezone.now()

    # Mở những vé đến hạn và đang đóng
    sections_to_open = SectionPrice.objects.filter(
        sell_date__lte=now,
        is_closed=True
    )

    # Đóng những vé đã hết thời gian đấu mà chưa đóng
    sections_to_close_by_time = SectionPrice.objects.filter(
        match__match_time__lt=now,
        is_closed=False
    )

    # Đóng những vé đã bán hết (available_seats = 0) mà chưa đóng
    sections_to_close_by_sold_out = SectionPrice.objects.filter(
        available_seats=0,
        is_closed=False
    )

    # Thực hiện cập nhật trạng thái
    opened_count = sections_to_open.update(is_closed=False)
    closed_by_time_count = sections_to_close_by_time.update(is_closed=True)
    closed_by_sold_out_count = sections_to_close_by_sold_out.update(is_closed=True)

    total_closed = closed_by_time_count + closed_by_sold_out_count

    logger.info(f"[update_section_prices] Đã mở {opened_count} section và đóng {total_closed} section vào lúc {now}.")
    print(f"[update_section_prices] Đã mở {opened_count} section và đóng {total_closed} section.")



# from .models import SectionPrice, PriceHistory
# @shared_task(name='tickets.tasks.apply_price_change')
# def apply_price_change(p_history_id):
#     try:
#         history = PriceHistory.objects.get(pk=p_history_id)
#         section_price = history.pricing

#         section_price.price = history.new_price
#         section_price.sell_date = history.effective_date
#         section_price.save()

#         logger.info(f"[apply_price_change] Updated price for SectionPrice {section_price.pk} to {section_price.price}")
#         return f'Updated SectionPrice {section_price.pk} to {section_price.price}'
#     except PriceHistory.DoesNotExist:
#         logger.error(f"[apply_price_change] PriceHistory ID {p_history_id} not found.")
#         return f'PriceHistory ID {p_history_id} not found.'
#     except Exception as e:
#         logger.error(f"[apply_price_change] Error: {str(e)}")
#         return str(e)
@shared_task(name='tickets.tasks.apply_price_change')
def apply_price_change(p_history_id):
    try:
        history = PriceHistory.objects.get(pk=p_history_id)
        section_price = history.pricing

        section_price.price = history.new_price
        section_price.sell_date = history.effective_date
        section_price.is_closed = False  # Mở lại để bán sau khi cập nhật giá
        section_price.save(update_fields=['price', 'sell_date', 'is_closed'])

        logger.info(f"[apply_price_change] Updated price for SectionPrice {section_price.pk} to {section_price.price}")
        return f'Updated SectionPrice {section_price.pk} to {section_price.price}'
    except PriceHistory.DoesNotExist:
        logger.error(f"[apply_price_change] PriceHistory ID {p_history_id} not found.")
        return f'PriceHistory ID {p_history_id} not found.'
    except Exception as e:
        logger.error(f"[apply_price_change] Error: {str(e)}")
        return str(e)
   

@shared_task(name='tickets.tasks.close_section_before_price_change')
def close_section_before_price_change(p_history_id):
    try:
        history = PriceHistory.objects.get(pk=p_history_id)
        section_price = history.pricing

        section_price.is_closed = True
        section_price.save(update_fields=['is_closed'])

        logger.info(f"[close_section_before_price_change] Closed SectionPrice {section_price.pk}")
        return f"Closed SectionPrice {section_price.pk}"
    except PriceHistory.DoesNotExist:
        logger.error(f"[close_section_before_price_change] PriceHistory ID {p_history_id} not found.")
        return f"PriceHistory ID {p_history_id} not found."
    except Exception as e:
        logger.error(f"[close_section_before_price_change] Error: {str(e)}")
        return str(e)

