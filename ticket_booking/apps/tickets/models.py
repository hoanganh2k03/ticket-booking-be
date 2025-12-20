from django.db import models
from apps.events.models import Match, Stadium
from django.db.models.signals import post_delete
from django.dispatch import receiver

from django.dispatch import receiver
from django.db.models.signals import post_delete

from django.db.models.signals import post_delete
from django.dispatch import receiver

class Section(models.Model):
    section_id = models.AutoField(primary_key=True)
    section_name = models.CharField(max_length=100)
    stadium = models.ForeignKey('events.Stadium', on_delete=models.CASCADE)
    capacity = models.IntegerField()
    map_position = models.CharField(max_length=255, null=True, blank=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['stadium', 'section_name'], name='unique_stadium_section_name')
        ]

        db_table = 'section'

    def __str__(self):
        return f'{self.section_name} - {self.stadium.stadium_name}'
    
    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        self.update_stadium_capacity()

    def update_stadium_capacity(self):
        total_capacity = Section.objects.filter(stadium=self.stadium).aggregate(total=models.Sum('capacity'))['total'] or 0
        self.stadium.capacity = total_capacity
        self.stadium.save()


@receiver(post_delete, sender=Section)
def update_capacity_on_delete(sender, instance, **kwargs):
    stadium = instance.stadium
    total_capacity = Section.objects.filter(stadium=stadium).aggregate(total=models.Sum('capacity'))['total'] or 0
    stadium.capacity = total_capacity
    stadium.save()


class Seat(models.Model):
    seat_id = models.AutoField(primary_key=True)
    seat_code = models.CharField(max_length=50, unique=True)
    seat_number = models.CharField(max_length=10)
    section = models.ForeignKey(Section, on_delete=models.CASCADE)
    status = models.IntegerField(default=0)  # 0 - available, 1 - maintenance

    class Meta:
        db_table = 'seat'

    def __str__(self):
        return self.seat_code

class SectionPrice(models.Model):
    pricing_id = models.AutoField(primary_key=True)
    match = models.ForeignKey(Match, on_delete=models.CASCADE, related_name='tickets')
    section = models.ForeignKey(Section, on_delete=models.CASCADE, related_name='tickets')
    price = models.DecimalField(max_digits=10, decimal_places=2)
    available_seats = models.IntegerField()
    is_closed = models.BooleanField(default=True)
    sell_date = models.DateTimeField()

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['match', 'section'], name='unique_match_section')
        ]

        db_table = 'section_price'

    def __str__(self):
        return f'{self.match} - {self.section.section_name}'

class PriceHistory(models.Model):
    p_history_id = models.AutoField(primary_key=True)
    pricing = models.ForeignKey(SectionPrice, on_delete=models.CASCADE)
    old_price = models.DecimalField(max_digits=10, decimal_places=2)
    new_price = models.DecimalField(max_digits=10, decimal_places=2)
    effective_date = models.DateTimeField()  
    changed_at = models.DateTimeField(auto_now_add=True)
    changed_by = models.ForeignKey('accounts.Employee', on_delete=models.CASCADE)
    reason = models.TextField()

    class Meta:
        db_table = 'price_history'

    def __str__(self):
        return f'Price change for {self.pricing}'
