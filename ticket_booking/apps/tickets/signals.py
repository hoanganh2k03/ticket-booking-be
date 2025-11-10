# Inside your app's signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import SectionPrice

@receiver(post_save, sender=SectionPrice)
def update_is_closed(sender, instance, **kwargs):
    # Nếu available_seats = 0 và is_closed = False, đặt is_closed = True
    if instance.available_seats == 0 and not instance.is_closed:
        instance.is_closed = True
        instance.save()