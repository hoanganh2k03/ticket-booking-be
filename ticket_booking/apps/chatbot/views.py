from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Q
from apps.accounts.models import Customer
from ticket_booking.apps.accounts.permissions import IsCustomer
from .models import ChatHistory
from .serializers import ChatHistorySerializer
from .services.faq_service import get_faq_answer
from .services.db_service import search_chroma, build_chroma_index
from .services.nlp_service import generate_ai_response, rewrite_query_with_context
from rest_framework.permissions import IsAuthenticated

class ChatbotAPIView(APIView):
    """
    Chatbot Hybrid: FAQ → RAG (FAISS) → OpenAI/Groq GPT
    """

    def post(self, request):
        user_message = request.data.get("message", "").strip()
        customer_id = request.data.get("customer_id")
        session_id = request.data.get("session_id")

        if not user_message:
            return Response(
                {"error": "Thiếu nội dung tin nhắn."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # 1️⃣ Xác định khách hàng (nếu có)
        customer = None
        if customer_id:
            try:
                customer = Customer.objects.get(id=customer_id)
            except Customer.DoesNotExist:
                customer = None

        # 2️⃣ Thử tìm câu trả lời trong FAQ
        answer = get_faq_answer(user_message)

        # 3️⃣ Nếu không có trong FAQ → tìm dữ liệu từ Chroma (RAG)
        if not answer:
            # 3a. Diễn giải lại câu hỏi nếu có session_id (có ngữ cảnh)
            refined_query = rewrite_query_with_context(user_message, session_id=session_id)

            # 3b. Tìm dữ liệu liên quan trong Chroma
            results = search_chroma(refined_query)
            if results:
                context, top_match_id = results
            else:
                context, top_match_id = "", None

            # 3c. Gọi AI để sinh câu trả lời dựa trên ngữ cảnh tìm được
            answer = generate_ai_response(
                user_message,
                customer=customer,
                session_id=session_id,
                context=context,
                top_match_id=top_match_id
            )

        return Response({"reply": answer}, status=status.HTTP_200_OK)


class ChatHistoryAPIView(APIView):
    permission_classes = [IsCustomer]
    """
    API để lấy lịch sử chat của một phiên hội thoại
    GET: /api/chat/history/?session_id=<session_id>&customer_id=<customer_id>
    """

    def get(self, request):
        session_id = request.query_params.get("session_id", "").strip()
        customer_id = request.query_params.get("customer_id")

        # Nếu không truyền session_id, cố gắng lấy phiên gần nhất của customer
        if not session_id:
            if not customer_id:
                return Response({"messages": [], "session_id": None}, status=status.HTTP_200_OK)

            try:
                customer = Customer.objects.get(id=customer_id)
            except Customer.DoesNotExist:
                return Response({"messages": [], "session_id": None}, status=status.HTTP_200_OK)

            latest_session = (
                ChatHistory.objects.filter(customer=customer)
                .exclude(session_id__isnull=True)
                .exclude(session_id__exact="")
                .order_by("-created_at")
                .values_list("session_id", flat=True)
                .first()
            )

            if not latest_session:
                return Response({"messages": [], "session_id": None}, status=status.HTTP_200_OK)

            # dùng session_id tìm chi tiết
            session_id = latest_session

        # Kiểm tra customer_id nếu có
        customer = None
        if customer_id:
            try:
                customer = Customer.objects.get(id=customer_id)
            except Customer.DoesNotExist:
                customer = None

        # Lấy lịch sử chat của phiên này
        query = Q(session_id=session_id)
        if customer:
            query &= Q(customer=customer)

        chat_history = ChatHistory.objects.filter(query).order_by('created_at')

        if not chat_history.exists():
            return Response({"messages": [], "session_id": session_id}, status=status.HTTP_200_OK)

        serializer = ChatHistorySerializer(chat_history, many=True)
        return Response({"messages": serializer.data, "session_id": session_id}, status=status.HTTP_200_OK)
