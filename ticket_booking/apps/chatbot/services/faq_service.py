def get_faq_answer(user_input: str) -> str | None:
    """Trả về câu trả lời cố định cho các câu hỏi thường gặp."""
    faq_data = {
        "xin chào": "Xin chào! Tôi có thể giúp bạn tra cứu vé, lịch thi đấu hoặc khuyến mãi.",
        "khuyến mãi": "Bạn có thể xem các chương trình khuyến mãi hiện tại trên trang 'Khuyến mãi'.",
        "mua vé": "Bạn có thể đặt vé trực tiếp trên website, hoặc tôi có thể giúp bạn tìm trận đấu phù hợp.",
        "giá vé": "Giá vé tùy vào khu vực sân và loại sự kiện. Bạn có muốn tôi tra giúp không?",
    }

    for key, answer in faq_data.items():
        if key in user_input.lower():
            return answer
    return None
