import json
from channels.generic.websocket import AsyncWebsocketConsumer
from django.db import models
from channels.db import database_sync_to_async
from asgiref.sync import sync_to_async

from .models import Order
from apps.events.models import Match
from apps.tickets.models import SectionPrice


class OrderConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        # Lấy match_id từ URL
        self.match_id = self.scope['url_route']['kwargs']['match_id']
        self.room_group_name = f"match_{self.match_id}"

        # Tham gia vào group (để nhận các tin nhắn của trận đấu)
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

        # Kiểm tra và lấy thông tin trận đấu từ cơ sở dữ liệu
        match = await self.get_match_info(self.match_id)
        if not match:
            # Nếu không tìm thấy trận đấu, từ chối kết nối WebSocket
            print("Khong tim thay tran dau")
            await self.close()
            return
        
        tickets = await self.get_all_ticket(self.match_id)

        if not tickets:
            print("Khong tim thay ve")
            await self.close()
            return
        
        # Lấy số vé đã bán từ cơ sở dữ liệu
        # sold_tickets = await self.get_sold_tickets(self.match_id)

        # Gửi thông tin trận đấu và số vé đã bán đến client khi kết nối
        await self.send(text_data=json.dumps({
            "status": "success",
            "message": "Connection established",
            "match": match,
            "tickets": tickets
        }))


    async def disconnect(self, close_code):
        # Rời group khi kết nối WebSocket bị ngắt
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    # Nhận thông tin từ client qua WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        action = text_data_json.get('action')

        if action == 'order_ticket':
            await self.handle_ticket_order(text_data_json)
            

    async def handle_ticket_order(self, data):
    # Xử lý đặt vé (Ví dụ: tạo mới đơn đặt vé)
        # user = self.scope["user"]
        ticket_quantity = data.get("ticket_quantity")
        section_id = data.get("section_id")  # Lấy section_id từ dữ liệu gửi đến

        # Kiểm tra xem section_id có hợp lệ không
        section = await self.get_section_price(self.match_id, section_id)
        if not section:
            await self.send(text_data=json.dumps({
                "status": "error",
                "message": "Invalid section ID"
            }))
            return

        # Kiểm tra số lượng vé còn lại trong section của trận đấu
        available_tickets_in_section = section['available_seats']

        if ticket_quantity > available_tickets_in_section:
            # Nếu không đủ vé trong section
            await self.send(text_data=json.dumps({
                "status": "error",
                "message": f"Not enough tickets available in this section. Only {available_tickets_in_section} left."
            }))
            return

        # Tạo đơn đặt vé
        # order = await database_sync_to_async(Order.objects.create)(
        #     # user=user,
        #     match_id=self.match_id,  # Sử dụng match_id đã có trong instance
        #     section_id=section_id,  # Thêm thông tin section vào order
        #     quantity=ticket_quantity
        # )

        # Giảm số lượng vé còn lại trong section
        section = await self.update_available_seats(self.match_id, section_id, ticket_quantity)

        # Gửi phản hồi tới client
        await self.channel_layer.group_send(
            self.room_group_name,  # Tên nhóm WebSocket của trận đấu
            {
                "type": "send_ticket_update",  # Loại thông báo (có thể tùy chỉnh)
                "section_id": section['section_id'],  # ID khu vực vé
                "remaining_tickets_in_section": section['available_seats']  # Số vé còn lại trong khu vực
            }
        )
        
        # await self.send(text_data=json.dumps({
        #     "status": "success",
        #     "message": "Ticket order successful!",
        #     # "order_id": order.id,
        #     "section_id": section['section_id'],
        #     "remaining_tickets_in_section": section['available_seats']
        # }))


    async def send_ticket_update(self, event):
    # Nhận thông tin vé đã thay đổi từ group (bao gồm section_id và remaining_tickets_in_section)
        section_id = event["section_id"]
        remaining_tickets_in_section = event["remaining_tickets_in_section"]

        # Cập nhật lại số lượng vé còn lại trong phần tử section trên giao diện
        await self.send(text_data=json.dumps({
            "status": "success",
            "message": "Ticket data updated",
            "section_id": section_id,
            "remaining_tickets_in_section": remaining_tickets_in_section
        }))


    @sync_to_async
    def get_match_info(self, match_id):
        try:
            match = Match.objects.get(match_id=match_id)
            return {
                "match_id": match.match_id,
                "match_time": str(match.match_time),  # Chuyển datetime thành chuỗi
                "round": match.round
            }
        except Match.DoesNotExist:
            return None
        
    @sync_to_async
    def get_all_ticket(self, match_id):
        try:
            section_prices = SectionPrice.objects.filter(match_id=match_id)
            tickets_data = [{
                "section_id": section_price.section.section_id,
                "price": float(section_price.price),
                "available_seats": section_price.available_seats
            } for section_price in section_prices]
            return tickets_data
        except SectionPrice.DoesNotExist:
            return None
        
    @sync_to_async
    def get_section_price(self, match_id, section_id):
        try:
            section_price = SectionPrice.objects.get(match_id=match_id, section_id=section_id)
            return {
                "section_id": section_price.section_id,
                "price": float(section_price.price),
                "available_seats": section_price.available_seats
            }
        except SectionPrice.DoesNotExist:
            return None
        
    @sync_to_async
    def update_available_seats(section, match_id, section_id, ticket_quantity):
        try:
            section_price = SectionPrice.objects.get(match_id=match_id, section_id=section_id)
            section_price.available_seats -= ticket_quantity
            section_price.save()
            return {
                "section_id": section_price.section_id,
                "price": float(section_price.price),
                "available_seats": section_price.available_seats
            }
        except SectionPrice.DoesNotExist:
            return None

    @sync_to_async
    def get_sold_tickets(self, match_id):
        # Tính số vé đã bán
        sold_tickets = Order.objects.filter(match_id=match_id).aggregate(sold=models.Sum('quantity'))['sold']
        return sold_tickets if sold_tickets else 0