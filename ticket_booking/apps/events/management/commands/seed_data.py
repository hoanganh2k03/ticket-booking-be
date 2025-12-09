import random
import uuid
import itertools
from datetime import timedelta, datetime
from django.core.management.base import BaseCommand
from django.utils import timezone
from django.db import transaction, IntegrityError

# Import Models
from apps.events.models import Match, League, Sport, Stadium, Team
from apps.tickets.models import Section, SectionPrice, Seat
from apps.orders.models import Order, OrderDetail, Payment
from apps.accounts.models import Customer

class Command(BaseCommand):
    help = 'Tạo dữ liệu EPL dựa trên Sân Vận Động ĐÃ CÓ SẴN (Fix lỗi trùng lịch)'

    def handle(self, *args, **kwargs):
        self.stdout.write(self.style.WARNING('⏳ Đang khởi tạo dữ liệu EPL...'))

        if not Stadium.objects.exists():
            self.stdout.write(self.style.ERROR('❌ Lỗi: Không tìm thấy Sân vận động nào trong DB.'))
            return

        try:
            with transaction.atomic():
                self.load_master_data()
                self.create_teams()
                self.create_season(
                    name="Premier League 24/25", 
                    start_date=datetime(2024, 8, 17),
                    end_date=datetime(2025, 5, 25),
                    is_finished=False 
                )

            self.stdout.write(self.style.SUCCESS('✅ THÀNH CÔNG! Dữ liệu đã được tạo an toàn.'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'❌ Lỗi hệ thống: {e}'))
            import traceback
            traceback.print_exc()

    def load_master_data(self):
        print("1. Đang tải dữ liệu Sân bãi & Tạo khách hàng...")
        self.sport, _ = Sport.objects.get_or_create(sport_name="Bóng đá", defaults={'description': 'King Sport'})
        
        # Load sân có sẵn
        self.stadiums_list = list(Stadium.objects.all())
        print(f"   -> Tìm thấy {len(self.stadiums_list)} sân vận động.")

        # Cache ghế
        self.stadium_seats_map = {}
        for std in self.stadiums_list:
            self.stadium_seats_map[std.stadium_id] = {}
            sections = Section.objects.filter(stadium=std)
            for sec in sections:
                seats = list(Seat.objects.filter(section=sec)) # Lấy tất cả ghế (bỏ qua status để demo cho nhiều)
                self.stadium_seats_map[std.stadium_id][sec.section_id] = seats

        # Tạo khách hàng
        self.customers = []
        for i in range(1, 51):
            c, _ = Customer.objects.get_or_create(
                email=f"fan{i}@epl.com",
                defaults={
                    'full_name': f"EPL Fan {i}",
                    'phone_number': f"09{i:08d}",
                    'created_at': timezone.now(),
                    'updated_at': timezone.now()
                }
            )
            self.customers.append(c)

    def create_teams(self):
        print("2. Đang chiêu mộ 20 đội bóng EPL...")
        teams_data = [
            ("Manchester City", 10), ("Arsenal", 9), ("Liverpool", 9), ("Manchester United", 9),
            ("Chelsea", 8), ("Tottenham", 8), ("Newcastle United", 8), ("Aston Villa", 7),
            ("Brighton", 7), ("West Ham", 6), ("Wolves", 6), ("Fulham", 5),
            ("Bournemouth", 5), ("Crystal Palace", 5), ("Brentford", 5), ("Everton", 5),
            ("Nottingham Forest", 4), ("Luton Town", 3), ("Burnley", 3), ("Sheffield United", 3)
        ]
        self.teams_obj = []
        for name, rating in teams_data:
            t, _ = Team.objects.get_or_create(
                team_name=name,
                sport=self.sport,
                defaults={'head_coach': "Head Coach", 'description': "EPL Team", 'rating': rating}
            )
            self.teams_obj.append(t)

    def create_season(self, name, start_date, end_date, is_finished):
        print(f"3. Đang tổ chức giải: {name}...")
        league, _ = League.objects.get_or_create(
            league_name=name,
            defaults={'league_type': 'National', 'start_date': start_date, 'end_date': end_date, 'sport': self.sport}
        )

        matchups = list(itertools.combinations(self.teams_obj, 2))
        random.shuffle(matchups)
        selected_matchups = matchups[:150] # Tạo 150 trận

        current_date = start_date
        match_count = 0

        for team1, team2 in selected_matchups:
            # Logic tính chất
            is_hot = False
            importance = 3
            if team1.rating + team2.rating >= 17: 
                is_hot = True; importance = 5
            elif "Manchester" in team1.team_name and "Manchester" in team2.team_name:
                is_hot = True; importance = 5
            elif abs(team1.rating - team2.rating) > 4:
                importance = 2

            # --- LOGIC CHỐNG TRÙNG LỊCH (QUAN TRỌNG) ---
            stadium = random.choice(self.stadiums_list)
            
            # Tính ngày cơ bản
            days_offset = match_count // 5
            base_date = start_date + timedelta(days=days_offset * 3)
            
            # Random giờ ban đầu
            match_time = base_date.replace(hour=random.choice([17, 19, 21]), minute=0, second=0, microsecond=0)
            match_time = timezone.make_aware(match_time)

            # Vòng lặp kiểm tra trùng: Nếu trùng giờ trùng sân -> Dời sang 2 tiếng sau
            # Thử tối đa 10 lần dời lịch
            for _ in range(10):
                if Match.objects.filter(match_time=match_time, stadium=stadium).exists():
                    match_time += timedelta(hours=2) # Dời 2 tiếng
                    # Nếu khuya quá (qua 23h) thì sang ngày hôm sau đá sớm
                    if match_time.hour >= 23:
                        match_time += timedelta(days=1)
                        match_time = match_time.replace(hour=14)
                else:
                    break # Không trùng -> Thoát vòng lặp, chốt giờ này

            # Tạo Match
            match = Match.objects.create(
                match_time=match_time,
                description=f"Vòng {match_count // 10 + 1}",
                round=f"Vòng {match_count // 10 + 1}",
                league=league,
                stadium=stadium,
                team_1=team1,
                team_2=team2,
                is_hot_match=is_hot,
                importance=importance
            )

            # Tạo giá vé
            base_price = 200000 if is_hot else 100000
            match_prices = []
            sections_dict = self.stadium_seats_map.get(stadium.stadium_id, {})
            
            if not sections_dict:
                match_count += 1; continue

            for sec_id, seats in sections_dict.items():
                sec_obj = Section.objects.get(pk=sec_id)
                final_price = base_price * 1.5 if "A" in sec_obj.section_name else base_price
                
                sp = SectionPrice.objects.create(
                    price=final_price,
                    available_seats=sec_obj.capacity,
                    is_closed=False,
                    sell_date=match_time - timedelta(days=14),
                    created_at=timezone.now(),
                    match=match,
                    section=sec_obj
                )
                match_prices.append((sp, seats))

            # Bán vé
            if match_time < timezone.now() + timedelta(days=7):
                fill_rate = random.uniform(0.9, 1.0) if is_hot else random.uniform(0.4, 0.8)
                self.simulate_sales(match, match_prices, fill_rate)

            match_count += 1
            if match_count % 10 == 0: current_date += timedelta(days=7)

    def simulate_sales(self, match, match_prices, fill_rate):
        for sp, seats in match_prices:
            qty = int(len(seats) * fill_rate)
            if qty == 0: continue
            
            # Đảm bảo không lấy quá số ghế có sẵn
            qty = min(qty, len(seats))
            seats_sold = random.sample(seats, qty)
            
            # Cập nhật available
            sp.available_seats -= qty
            sp.save()

            while len(seats_sold) > 0:
                chunk_size = min(random.randint(1, 4), len(seats_sold))
                chunk = seats_sold[:chunk_size]
                seats_sold = seats_sold[chunk_size:]
                
                customer = random.choice(self.customers)
                
                order = Order.objects.create(
                    order_id=uuid.uuid4().hex,
                    total_amount=sp.price * len(chunk),
                    order_status="SUCCESS",
                    order_method="ONLINE",
                    created_at=match.match_time - timedelta(days=random.randint(1, 5)),
                    user_id=customer.id
                )
                
                Payment.objects.create(
                    payment_method=random.choice(['VISA', 'MOMO']),
                    payment_status='SUCCESS',
                    transaction_code=f"PAY_{uuid.uuid4().hex[:8].upper()}",
                    created_at=order.created_at,
                    expiration_time=order.created_at + timedelta(minutes=15),
                    order=order
                )

                details = [OrderDetail(
                    price=sp.price, updated_at=order.created_at, order_id=order.order_id,
                    pricing=sp, seat_id=s.seat_id
                ) for s in chunk]
                OrderDetail.objects.bulk_create(details)