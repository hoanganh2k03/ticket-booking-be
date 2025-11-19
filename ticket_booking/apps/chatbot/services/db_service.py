
import os
from django.conf import settings
from langchain_chroma import Chroma
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_core.documents import Document

# Cố định CHROMA_PATH trong thư mục chatbot
CHROMA_PATH = os.path.join(settings.BASE_DIR, "apps", "chatbot", "chroma_index")

embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2")


def build_chroma_index():
    """
    Xây dựng Chroma index từ dữ liệu sự kiện/vé trong DB.
    """
    try:
        from apps.events.models import Match
        from apps.tickets.models import Section, SectionPrice
        from apps.promotions.models import Promotion, PromotionDetail
    except ImportError as e:
        print(f"⚠️ Lỗi import models: {e}")
        return

    # 🧹 Xoá index cũ nếu có
    if os.path.exists(CHROMA_PATH):
        try:
            db = Chroma(persist_directory=CHROMA_PATH, embedding_function=embeddings)
            if hasattr(db, "reset_collection"):
                db.reset_collection()
                print("✅ Đã reset toàn bộ dữ liệu trong collection.")
            else:
                print("⚠️ Phiên bản Chroma hiện tại chưa hỗ trợ .reset_collection().")
        except Exception as e:
            print(f"⚠️ Lỗi khi reset collection: {e}")

    # Lấy dữ liệu từ DB
    try:
        matches = Match.objects.select_related("team_1", "team_2", "league")
    except Exception as e:
        print(f"⚠️ Lỗi khi query Match: {e}")
        return

    docs = []
    
    for m in matches:
        try:
            match_id = m.match_id if hasattr(m, 'match_id') else m.id
            team_1_name = m.team_1.team_name if m.team_1 else "Đội 1"
            team_2_name = m.team_2.team_name if m.team_2 else "Đội 2"
            match_name = f"{team_1_name} vs {team_2_name}"
            match_time = m.match_time.strftime('%H:%M %d/%m/%Y') if hasattr(m, 'match_time') and m.match_time else "Chưa xác định"
            
            league_name = m.league.league_name if m.league else "Giải không xác định"
            sport_type = m.league.sport.sport_name if m.league and m.league.sport else "Thể thao"

            # Duyệt qua từng khu vực trong sân
            section_prices = SectionPrice.objects.filter(match=m, is_closed=0).select_related("section")
            
            for sp in section_prices:
                section = sp.section.section_name if sp.section else "Khu vực không xác định"
                price = int(sp.price) if sp.price else 0
                seats = sp.available_seats if sp.available_seats else 0

                # Xác định trạng thái vé
                status = "còn vé" if seats > 0  else "hết vé"

                # Kiểm tra khuyến mãi
                promo_text = ""
                try:
                    promo_detail = PromotionDetail.objects.filter(
                        match=m, section=sp.section
                    ).select_related("promo").first()

                    if promo_detail and promo_detail.promo:
                        promo = promo_detail.promo
                        if promo.discount_type == "percentage":
                            promo_text = f", khuyến mãi {promo.promo_code}: giảm {promo.discount_value}%"
                        else:
                            promo_text = f", khuyến mãi {promo.promo_code}: giảm {int(promo.discount_value):,}đ"
                except Exception as e:
                    print(f"⚠️ Lỗi khi query promotion: {e}")

                # Text mô tả đầy đủ
                text = (
                    f"match_id {match_id}, "
                    f"Giải {league_name} ({sport_type}), "
                    f"Trận {match_name}, Thời gian {match_time}, "
                    f"Khu vực {section}, giá {price:,}đ, {status}{promo_text}, còn {seats} chỗ."
                )

                docs.append(
                    Document(page_content=text, metadata={"match_id": match_id})
                )
        except Exception as e:
            print(f"⚠️ Lỗi xử lý match: {e}")
            continue

    if not docs:
        print("⚠️ Không có dữ liệu để tạo index.")
        return

    try:
        db = Chroma.from_documents(
            docs, embedding=embeddings, persist_directory=CHROMA_PATH
        )
        print(f"✅ Chroma index đã được tạo tại {CHROMA_PATH}")
    except Exception as e:
        print(f"❌ Lỗi khi tạo Chroma index: {e}")


def search_chroma(user_message: str, k: int = 3):
    """
    Truy vấn dữ liệu gần nhất trong Chroma.
    """
    try:
        # Build index trước khi search
        build_chroma_index()

        db = Chroma(persist_directory=CHROMA_PATH, embedding_function=embeddings)
        results = db.similarity_search(user_message, k=k)
        print(results)
        if not results:
            print("⚠️ Không tìm thấy kết quả liên quan.")
            return None

        top_match_id = results[0].metadata.get("match_id")
        context_text = "\n".join([r.page_content for r in results])

        print(f"✅ Tìm thấy {len(results)} kết quả liên quan.")
        return context_text, top_match_id

    except Exception as e:
        print(f"❌ Lỗi khi search Chroma: {e}")
        return None

