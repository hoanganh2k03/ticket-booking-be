from django.core.management.base import BaseCommand
from apps.tickets.models import SectionPrice
from apps.orders.models import OrderDetail

class Command(BaseCommand):
    help = 'Đồng bộ lại cột available_seats của Ticket dựa trên OrderDetail'

    def handle(self, *args, **kwargs):
        self.stdout.write("Đang đồng bộ dữ liệu ghế (Syncing Seats)...")

        prices = SectionPrice.objects.all()
        updated_count = 0

        for p in prices:
            # Đếm số vé ĐÃ BÁN (có trong OrderDetail)
            sold_count = OrderDetail.objects.filter(pricing=p).count()
            
            # Tính số ghế còn lại
            real_available = p.section.capacity - sold_count
            
            if real_available < 0: 
                real_available = 0

            # Nếu lệch thì cập nhật lại
            if p.available_seats != real_available:
                p.available_seats = real_available
                p.save()
                updated_count += 1

        self.stdout.write(self.style.SUCCESS(f"HOÀN TẤT! Đã cập nhật {updated_count} bản ghi SectionPrice."))