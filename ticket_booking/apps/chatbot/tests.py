from rest_framework.test import APITestCase, APIClient
from rest_framework import status
from apps.accounts.models import Customer


class ChatbotAPITestCase(APITestCase):
    def setUp(self):
        self.client = APIClient()
        # Tạo customer test
        self.customer = Customer.objects.create(
            id=1,
            full_name="Test Customer",
            email="test@example.com",
            phone_number="0123456789"
        )

    def test_send_message_with_customer(self):
        """Test gửi tin nhắn với customer_id hợp lệ"""
        data = {
            "message": "Xin chào",
            "customer_id": 1,
            "session_id": "test-session"
        }
        response = self.client.post('/api/chat/', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("reply", response.data)
        self.assertIn("session_id", response.data)

    def test_send_empty_message(self):
        """Test gửi tin nhắn rỗng"""
        data = {
            "message": "",
            "customer_id": 1,
            "session_id": "test-session"
        }
        response = self.client.post('/api/chat/', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_faq_response(self):
        """Test câu hỏi FAQ"""
        data = {
            "message": "Khuyến mãi",
            "customer_id": 1,
            "session_id": "test-session"
        }
        response = self.client.post('/api/chat/', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("Bạn có thể xem các chương trình khuyến mãi", response.data["reply"])
