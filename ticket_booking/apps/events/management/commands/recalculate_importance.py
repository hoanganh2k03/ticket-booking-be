from django.core.management.base import BaseCommand
from apps.events.models import Match

class Command(BaseCommand):
    help = 'Tính toán lại độ quan trọng (Importance) cho toàn bộ trận đấu'

    def handle(self, *args, **kwargs):
        matches = Match.objects.all()
        count = 0
        for m in matches:
            # Gọi hàm tính toán mới trong Model
            m.calculate_hotness()
            m.save()
            count += 1
            
        self.stdout.write(self.style.SUCCESS(f'Đã cập nhật lại {count} trận đấu theo logic mới!'))