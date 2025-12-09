import random
import uuid
import itertools
from datetime import timedelta, datetime
from django.core.management.base import BaseCommand
from django.utils import timezone
from django.db import transaction

# Import Models
from apps.events.models import Match, League, Sport, Stadium, Team
from apps.tickets.models import Section, SectionPrice, Seat
from apps.orders.models import Order, OrderDetail, Payment
from apps.accounts.models import Customer

class Command(BaseCommand):
    help = 'Tạo 250 trận đấu QUÁ KHỨ (Final Fix: Bỏ updated_at)'

    def handle(self, *args, **kwargs):
        self.stdout.write(self.style.WARNING('⏳ Đang tạo dữ liệu lịch sử... Vui lòng đợi!'))

        if not Stadium.objects.exists():
            self.stdout.write(self.style.ERROR('❌ Lỗi: Không tìm thấy Sân vận động nào trong DB.'))
            return

        try:
            with transaction.atomic():
                self.upgrade_stadiums()
                self.ensure_teams_and_customers()
                self.create_historical_season()

            self.stdout.write(self.style.SUCCESS('✅ THÀNH CÔNG! Đã tạo xong 250 trận đấu quá khứ.'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'❌ Lỗi hệ thống: {e}'))
            import traceback
            traceback.print_exc()

    def upgrade_stadiums(self):
        print("1. Đang chuẩn bị cơ sở vật chất (Sân bãi)...")
        self.stadiums_list = list(Stadium.objects.all())
        self.stadium_seats_map = {} 

        for std in self.stadiums_list:
            self.stadium_seats_map[std.stadium_id] = {}
            
            # Thêm section mới
            expansion_plan = [("Khán đài C", 200), ("Khán đài D", 200), ("Khu vực VIP", 100)]
            
            added_capacity = 0
            for sec_name, sec_cap in expansion_plan:
                section, created = Section.objects.get_or_create(
                    section_name=sec_name, stadium=std, defaults={'capacity': sec_cap}
                )
                if created:
                    prefix = sec_name.split(" ")[-1]
                    seats = [
                        Seat(
                            seat_code=f"{std.stadium_code}-{prefix}-{i}", 
                            seat_number=str(i), status=0, section=section
                        ) for i in range(1, sec_cap + 1)
                    ]
                    Seat.objects.bulk_create(seats)
                    added_capacity += sec_cap

            if added_capacity > 0:
                std.capacity = (std.capacity or 0) + added_capacity
                std.save()

            all_sections = Section.objects.filter(stadium=std)
            for sec in all_sections:
                seats = list(Seat.objects.filter(section=sec))
                self.stadium_seats_map[std.stadium_id][sec.section_id] = seats

    def ensure_teams_and_customers(self):
        print("2. Đang tải danh sách Đội bóng & Khách hàng...")
        self.sport, _ = Sport.objects.get_or_create(sport_name="Bóng đá")

        self.customers = []
        for i in range(1, 101):
            c, _ = Customer.objects.get_or_create(
                email=f"user{i}@history.com",
                defaults={'full_name': f"User {i}", 'phone_number': f"09{i:08d}", 'created_at': timezone.now(), 'updated_at': timezone.now()}
            )
            self.customers.append(c)

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
                defaults={'sport': self.sport, 'head_coach': 'Coach', 'description': 'EPL', 'rating': rating}
            )
            self.teams_obj.append(t)

    def create_historical_season(self):
        print(f"3. Đang tái hiện lịch sử mùa giải 2023-2024...")
        
        league, _ = League.objects.get_or_create(
            league_name="Premier League 2023/2024 (History)",
            defaults={'league_type': 'National', 'start_date': '2023-08-12', 'end_date': '2024-05-19', 'sport': self.sport}
        )

        matchups = list(itertools.permutations(self.teams_obj, 2))
        random.shuffle(matchups)
        selected_matchups = matchups[:250] 

        end_date_limit = timezone.now() - timedelta(days=1)
        start_date_sim = end_date_limit - timedelta(days=300)
        
        match_count = 0
        for team1, team2 in selected_matchups:
            r1, r2 = team1.rating, team2.rating
            total = r1 + r2
            diff = abs(r1 - r2)

            # Logic Hotness V2 (Đồng bộ với Model)
            is_hot = False
            importance = 3

            if total >= 17: # Super Match
                is_hot = True; importance = 5
            elif "Manchester" in team1.team_name and "Manchester" in team2.team_name: # Derby
                is_hot = True; importance = 5
            elif total >= 14: # High tier
                importance = 4
            elif abs(team1.rating - team2.rating) >= 5:
                # Nếu có đội mạnh (Rating >= 9) đá với đội yếu
                if max(team1.rating, team2.rating) >= 9:
                    importance = 4 # Khách vẫn đến xem Man City 'hủy diệt' đội bạn
                else:
                    importance = 2 # Trận này mới thực sự chán
            elif total <= 8: # Low tier (Burnley vs Luton)
                importance = 1
            else:
                importance = 3 # Mid tier

            # --- 2. Thời gian ---
            days_add = int((match_count / 250) * 300) 
            base_date = start_date_sim + timedelta(days=days_add)
            match_time = base_date.replace(hour=random.choice([14, 17, 19, 20]), minute=0, second=0, microsecond=0)
            
            if timezone.is_naive(match_time):
                match_time = timezone.make_aware(match_time)
            
            stadium = random.choice(self.stadiums_list)
            for _ in range(5):
                if Match.objects.filter(match_time=match_time, stadium=stadium).exists():
                    match_time += timedelta(hours=2)
                else: break

            # --- 3. Tạo Match (ĐÃ XÓA updated_at) ---
            created_time = match_time - timedelta(days=30)
            
            match = Match(
                match_time=match_time,
                description=f"History Match {match_count+1}",
                round=f"Vòng {match_count // 10 + 1}",
                league=league, stadium=stadium, team_1=team1, team_2=team2,
                is_hot_match=is_hot, importance=importance,
                created_at=created_time # Chỉ giữ created_at
            )
            match.save_base(raw=True)

            # --- 4. Tạo Giá ---
            base_price = 200000 if is_hot else (100000 if importance >= 3 else 50000)
            match_prices = []
            sections_dict = self.stadium_seats_map.get(stadium.stadium_id, {})
            if not sections_dict: continue

            for sec_id, seats in sections_dict.items():
                sec_obj = Section.objects.get(pk=sec_id)
                price = base_price
                if "VIP" in sec_obj.section_name: price *= 2.5 
                elif "A" in sec_obj.section_name: price *= 1.5 
                elif "C" in sec_obj.section_name: price *= 0.8 
                price = round(price, -3)

                sp = SectionPrice.objects.create(
                    price=price,
                    available_seats=sec_obj.capacity,
                    is_closed=True,
                    sell_date=match_time - timedelta(days=14),
                    created_at=created_time,
                    match=match,
                    section=sec_obj
                )
                match_prices.append((sp, seats))

            # --- 5. Mua Vé ---
            if is_hot: fill = random.uniform(0.90, 1.00)
            elif importance <= 2: fill = random.uniform(0.20, 0.50)
            else: fill = random.uniform(0.50, 0.85)
            
            if match_time.weekday() >= 5: fill = min(1.0, fill + 0.1)

            self.simulate_sales(match, match_prices, fill)
            match_count += 1

    def simulate_sales(self, match, match_prices, fill_rate):
        for sp, seats in match_prices:
            actual_fill = min(1.0, fill_rate * random.uniform(0.9, 1.1))
            qty = int(len(seats) * actual_fill)
            if qty == 0: continue
            qty = min(qty, len(seats))
            
            seats_sold = random.sample(seats, qty)
            
            sp.available_seats -= qty
            sp.save()

            orders = []
            payments = []
            details = []
            
            while len(seats_sold) > 0:
                chunk_size = min(random.randint(1, 4), len(seats_sold))
                chunk = seats_sold[:chunk_size]
                seats_sold = seats_sold[chunk_size:]
                
                customer = random.choice(self.customers)
                
                # Xử lý ngày mua vé
                order_time = match.match_time - timedelta(days=random.randint(1, 7), hours=random.randint(0,10))
                if timezone.is_naive(order_time):
                    order_time = timezone.make_aware(order_time)

                order = Order(
                    order_id=uuid.uuid4().hex,
                    total_amount=sp.price * len(chunk),
                    order_status="SUCCESS",
                    order_method="ONLINE",
                    created_at=order_time,
                    user_id=customer.id
                )
                orders.append(order)

                payments.append(Payment(
                    payment_method=random.choice(['VISA', 'MOMO', 'ATM']),
                    payment_status='SUCCESS',
                    transaction_code=f"PAY_{uuid.uuid4().hex[:8].upper()}",
                    created_at=order_time,
                    expiration_time=order_time + timedelta(minutes=15),
                    order=order
                ))

                for s in chunk:
                    details.append(OrderDetail(
                        price=sp.price,
                        updated_at=order_time,
                        order_id=order.order_id,
                        pricing=sp,
                        seat_id=s.seat_id
                    ))
            
            Order.objects.bulk_create(orders)
            Payment.objects.bulk_create(payments)
            OrderDetail.objects.bulk_create(details)