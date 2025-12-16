import unicodedata

def normalize(text: str) -> str:
    """Chuyển text về dạng không dấu + lowercase + bỏ khoảng trắng dư."""
    text = text.lower().strip()
    text = ''.join(
        c for c in unicodedata.normalize('NFD', text)
        if unicodedata.category(c) != 'Mn'
    )
    return text




def get_faq_answer(user_input: str) -> str | None:
    faq_data = {
    # ===== GENERAL =====
    ("xin chao", "chao", "hello"): 
        "Xin chào! Tôi có thể giúp bạn đặt vé xem thể thao hoặc giải đáp thắc mắc.",

    ("khuyen mai", "uu dai", "co khuyen mai khong"): 
        "Bạn có thể xem các chương trình khuyến mãi hiện tại trên trang chủ.",

    ("gia ve", "ve bao nhieu", "gia ve the nao", "bang gia ve"): 
        "Giá vé tùy thuộc khu vực khán đài và sự kiện.",

    ("mua ve", "dat ve", "cach mua ve", "lam sao mua ve"): 
        "Bạn có thể đặt vé trực tiếp trên website bằng cách chọn trận đấu và khu vực.",

    # ===== SPORTS / ĐẶT VÉ THỂ THAO =====
    ("lich thi dau", "lich tran dau", "lich bong da", "lich thi dau hom nay"): 
        "Bạn có thể xem lịch thi đấu chi tiết trên mục 'Lịch thi đấu' của website.",

    ("san con trong khong", "con ve khong", "ve con khong"): 
        "Vé còn hay hết tùy theo từng khu vực khán đài. Bạn hãy chọn trận để xem chi tiết.",

    ("khu vuc khan dai", "chon ghe", "chuan bi ghe", "chon khu vuc","khu vuc"): 
        "Bạn có thể chọn khu vực khán đài A, B, C hoặc VIP tùy trận đấu.",

    ("phuong thuc thanh toan", "thanh toan bang gi", "tra tien nhu the nao","thanh toan"): 
        "Bạn có thể thanh toán bằng thẻ ngân hàng, ví điện tử hoặc mã QR.",

    ("huy ve", "doi ve", "huy dat ve"): 
        "Bạn có thể hủy hoặc đổi vé trước giờ diễn ra sự kiện nếu thỏa điều kiện.",
}

    normalized = normalize(user_input)

    for questions, answer in faq_data.items():
        if normalized in questions:   # EXACT MATCH (nhưng đã normalize)
            return answer

    return None
