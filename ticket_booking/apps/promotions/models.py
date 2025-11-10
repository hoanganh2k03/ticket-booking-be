from django.db import models
from apps.events.models import Match
from apps.accounts.models import Employee
from apps.tickets.models import Section

class Promotion(models.Model):
    promo_id = models.AutoField(primary_key=True)
    promo_code = models.CharField(max_length=100, unique=True)
    discount_value = models.DecimalField(max_digits=10, decimal_places=2)
    discount_type = models.CharField(max_length=20, choices=[('percentage', 'Phần trăm'), ('amount', 'Số tiền')])
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    usage_limit = models.IntegerField(default=10)
    description = models.TextField(blank=True, null=True)
    user = models.ForeignKey(Employee, on_delete=models.CASCADE)
    status = models.BooleanField(default=True)

    class Meta:
        db_table = 'promotion'

    def __str__(self):
        return self.promo_code

class PromotionDetail(models.Model):
    promo = models.ForeignKey(Promotion, on_delete=models.PROTECT)
    match = models.ForeignKey(Match, on_delete=models.PROTECT)
    section = models.ForeignKey(Section, on_delete=models.PROTECT)

    class Meta:
        db_table = 'promotion_detail'        
        constraints = [
            models.UniqueConstraint(fields=['promo', 'match', 'section'], name='unique_promo_match_section')
        ]
        
    def __str__(self):
        return f'{self.promo.promo_code} - {self.match}'

