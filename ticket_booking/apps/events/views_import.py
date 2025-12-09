import pandas as pd
from django.db import transaction
from django.utils import timezone
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from rest_framework import serializers

# Import Models (Bỏ Section, SectionPrice vì không tạo giá lúc này nữa)
from .models import Match, Team, Stadium, League

# --- SERIALIZER ---
class MatchScheduleImportSerializer(serializers.Serializer):
    league_id = serializers.IntegerField(help_text="ID của giải đấu cần import")
    file = serializers.FileField(help_text="File Excel lịch thi đấu (.xlsx)")

# --- VIEW XỬ LÝ IMPORT ---
class ImportMatchScheduleView(APIView):
    parser_classes = [MultiPartParser, FormParser]
    serializer_class = MatchScheduleImportSerializer

    def post(self, request):
        # 1. NHẬN DỮ LIỆU
        file_obj = request.FILES.get('file')
        league_id = request.data.get('league_id')

        # Kiểm tra input cơ bản
        if not file_obj:
            return Response({"error": "Vui lòng upload file Excel (.xlsx)"}, status=status.HTTP_400_BAD_REQUEST)
        
        if not league_id:
            return Response({"error": "Vui lòng chọn Giải đấu (league_id)"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Kiểm tra Giải đấu
            try:
                league = League.objects.get(pk=league_id)
            except League.DoesNotExist:
                return Response({"error": "Giải đấu không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

            # 2. ĐỌC FILE EXCEL
            try:
                df = pd.read_excel(file_obj)
                df = df.fillna('') # Xử lý ô trống
            except Exception:
                return Response({"error": "File lỗi hoặc không đúng định dạng Excel."}, status=status.HTTP_400_BAD_REQUEST)

            valid_matches = []
            errors = []
            
            # LẤY MÔN THỂ THAO CỦA GIẢI ĐẤU (Để validate chéo)
            league_sport = league.sport 

            # 3. DUYỆT QUA TỪNG DÒNG
            for index, row in df.iterrows():
                line_num = index + 2
                row_error = []

                # --- Lấy dữ liệu (ĐÃ BỎ CỘT PRICE) ---
                round_val = str(row.get('Round', '')).strip()
                home_name = str(row.get('HomeTeam', '')).strip()
                away_name = str(row.get('AwayTeam', '')).strip()
                stadium_name = str(row.get('Stadium', '')).strip()
                date_val = row.get('Date')
                desc_val = str(row.get('Description', '')).strip()
                
                # --- A. KIỂM TRA DỮ LIỆU TRỐNG ---
                if not round_val: row_error.append("Thiếu Vòng đấu")
                if not home_name: row_error.append("Thiếu Đội nhà")
                if not away_name: row_error.append("Thiếu Đội khách")
                if not stadium_name: row_error.append("Thiếu Sân vận động")

                # --- B. KIỂM TRA ĐỘI NHÀ (Đúng tên + Đúng môn) ---
                home_team = Team.objects.filter(team_name__iexact=home_name, sport=league_sport).first()
                if not home_team and home_name:
                    wrong_sport_team = Team.objects.filter(team_name__iexact=home_name).first()
                    if wrong_sport_team:
                        row_error.append(f"Đội '{home_name}' thuộc môn '{wrong_sport_team.sport.sport_name}', không thể đá giải '{league.sport.sport_name}'")
                    else:
                        row_error.append(f"Đội '{home_name}' chưa có trong DB")

                # --- C. KIỂM TRA ĐỘI KHÁCH (Đúng tên + Đúng môn) ---
                away_team = Team.objects.filter(team_name__iexact=away_name, sport=league_sport).first()
                if not away_team and away_name:
                    wrong_sport_team = Team.objects.filter(team_name__iexact=away_name).first()
                    if wrong_sport_team:
                        row_error.append(f"Đội '{away_name}' thuộc môn '{wrong_sport_team.sport.sport_name}', không thể đá giải '{league.sport.sport_name}'")
                    else:
                        row_error.append(f"Đội '{away_name}' chưa có trong DB")

                # --- D. KIỂM TRA SÂN VẬN ĐỘNG ---
                stadium = Stadium.objects.filter(stadium_name__iexact=stadium_name).first()
                if not stadium and stadium_name:
                    row_error.append(f"Sân '{stadium_name}' chưa có trong DB")

                # --- E. KIỂM TRA LOGIC KHÁC ---
                if home_team and away_team and home_team.pk == away_team.pk:
                    row_error.append("Đội nhà và Đội khách trùng nhau")

                match_time = None
                if date_val:
                    try:
                        match_time = pd.to_datetime(date_val)
                        if pd.isna(match_time): raise ValueError
                    except:
                        row_error.append("Định dạng Ngày giờ sai")
                else:
                    row_error.append("Thiếu thời gian")

                # --- TỔNG HỢP LỖI ---
                if row_error:
                    errors.append(f"Dòng {line_num}: {', '.join(row_error)}")
                else:
                    valid_matches.append({
                        "match_time": match_time,
                        "description": desc_val,
                        "round": round_val,
                        "league": league,
                        "stadium": stadium,
                        "team_1": home_team,
                        "team_2": away_team
                    })

            # 4. QUYẾT ĐỊNH: CÓ LỖI -> DỪNG
            if len(errors) > 0:
                return Response({
                    "status": "failed",
                    "message": "Dữ liệu không hợp lệ. Vui lòng kiểm tra file Excel.",
                    "errors": errors
                }, status=status.HTTP_400_BAD_REQUEST)

            # 5. LƯU VÀO DB (CHỈ TẠO MATCH)
            created_count = 0
            with transaction.atomic():
                for item in valid_matches:
                    Match.objects.create(
                        match_time=item['match_time'],
                        description=item['description'],
                        round=item['round'],
                        league=item['league'],
                        stadium=item['stadium'],
                        team_1=item['team_1'],
                        team_2=item['team_2']
                    )
                    # ĐÃ XÓA ĐOẠN TẠO SECTION PRICE
                    created_count += 1

            return Response({
                "status": "success",
                "message": f"Import thành công {created_count} trận đấu! (Lưu ý: Trận đấu chưa có giá vé)"
            }, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({"error": f"Lỗi hệ thống: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)