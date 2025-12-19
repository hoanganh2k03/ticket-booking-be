# reports/views.py
from django.db.models import Sum, F, Value, ExpressionWrapper, DecimalField, Func, DateTimeField, DateField, Case, When, Value, CharField, Count
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import *
from apps.orders.models import Order, OrderDetail
from apps.returns.models import TicketReturn
from apps.tickets.models import SectionPrice

from django.db.models.functions import Concat, TruncDate
from django.utils.dateparse import parse_date
from rest_framework.views import APIView
from rest_framework.response import Response

from apps.tickets.models import SectionPrice
from .serializers import TicketStatusReportSerializer



from django.db.models import F, Value, Sum
from django.db.models.functions import Concat, TruncDate
from django.utils.timezone import get_current_timezone

from datetime import datetime, time
from django.utils import timezone
from django.conf import settings

from django.db.models import Count
from django.db.models.functions import TruncDate

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .serializers import DailyTicketSalesSerializer


from datetime import datetime, time
from django.utils import timezone
from django.db.models import Sum, F, Value
from django.db.models.functions import Concat, TruncDate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import RevenueReportSerializer
from apps.orders.models import Order
from io import BytesIO
from django.http import HttpResponse
import urllib.parse
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Table, TableStyle, Spacer

import pandas as pd
from io import BytesIO
from django.http import HttpResponse

from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase import pdfmetrics
# Đăng ký font hỗ trợ tiếng Việt (đảm bảo đã copy file DejaVuSans.ttf và DejaVuSans-Bold.ttf vào đúng path)
pdfmetrics.registerFont(TTFont('Nunito-Medium', settings.FONT_URL[0]))
pdfmetrics.registerFont(TTFont('Nunito-Bold', settings.FONT_URL[1]))

styles = getSampleStyleSheet()
info_style = ParagraphStyle(
    'info',
    parent=styles['Normal'],
    spaceAfter=12,
    fontName='Nunito-Medium',
    fontSize=14,
    wordWrap='CJK'
)

header_style = ParagraphStyle(
    'info',
    parent=styles['Normal'],
    spaceAfter=12,
    fontName='Nunito-Bold',
    fontSize=18,
    wordWrap='CJK'  # hoặc thử 'LTR'
)    

# Tiêu đề
title_style = ParagraphStyle(
    'Title',
    parent=styles['Title'],
    fontName='Nunito-Bold',
    fontSize=24,
    spaceAfter=12
)

def export_revenue_pdf(request, by_match, by_section):
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4, rightMargin=40, leftMargin=40, topMargin=60, bottomMargin=40)
    
    start = request.query_params.get('start_date')
    end   = request.query_params.get('end_date')
    elems = []
    elems.append(Paragraph(f"Báo cáo doanh thu<br/>{start} đến {end}", style=title_style))

    raw_user = request.query_params.get('employee_name', '')
    user = urllib.parse.unquote(raw_user)
    now_str = timezone.localtime(timezone.now()).strftime("%d/%m/%Y %H:%M")

    elems.append(Paragraph(f"Người xuất: {user}", info_style))
    elems.append(Paragraph(f"Thời gian: {now_str}", info_style))
    elems.append(Spacer(1, 12))

    # Bảng By Match
    elems.append(Paragraph("1. Doanh thu theo trận", header_style ))
    data_match = [["Match ID", "Thời gian", "Tên trận", "Doanh thu"]]
    for row in by_match:
        data_match.append([row['match_id'], row['match_time'].strftime("%d/%m/%Y %H:%M"), row['match_name'], f"{row['revenue']:,}"])
    tbl_match = Table(data_match, repeatRows=1)
    tbl_match.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#4F81BD")),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('GRID', (0,0), (-1,-1), 0.5, colors.gray),
        ('FONTNAME', (0,0), (-1,0), 'Nunito-Bold'),
        ('FONTNAME', (0,1), (-1,-1), 'Nunito-Medium'),
    ]))
    elems.append(tbl_match)
    elems.append(Spacer(1, 24))

    # Bảng By Section
    elems.append(Paragraph("2. Doanh thu theo khu vực", header_style))
    data_sec = [["Section ID", "Tên khu vực", "Doanh thu"]]
    for row in by_section:
        data_sec.append([row['section_id'], row['section_name'], f"{row['revenue']:,}"])
    tbl_sec = Table(data_sec, repeatRows=1)
    tbl_sec.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#C0504D")),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('GRID', (0,0), (-1,-1), 0.5, colors.gray),
        ('FONTNAME', (0,0), (-1,0), 'Nunito-Bold'),
        ('FONTNAME', (0,1), (-1,-1), 'Nunito-Medium'),
    ]))
    elems.append(tbl_sec)

    doc.build(elems)
    buffer.seek(0)
    return HttpResponse(buffer, content_type='application/pdf', headers={
        'Content-Disposition': 'attachment; filename="revenue_report.pdf"'
    })

def export_revenue_xlsx(request, by_match, by_section):
    from io import BytesIO
    import pandas as pd
    import urllib.parse
    from django.http import HttpResponse
    from django.utils import timezone

    output = BytesIO()
    with pd.ExcelWriter(output, engine='xlsxwriter') as writer:
        workbook = writer.book
        title_format = workbook.add_format({'bold': True, 'font_size': 14, 'align': 'center'})

        # Lấy thông tin người xuất và thời gian hiện tại
        raw_user = request.query_params.get('employee_name', '')
        employee = urllib.parse.unquote(raw_user)
        now_str = timezone.localtime(timezone.now()).strftime("%d/%m/%Y %H:%M")
        start = request.query_params.get('start_date', '')
        end   = request.query_params.get('end_date', '')

        # Sheet: By Match
        df_match = pd.DataFrame(by_match)

        if 'match_time' in df_match.columns:
            df_match['match_time'] = df_match['match_time'].apply(lambda x: x.replace(tzinfo=None) if pd.notnull(x) else x)

        df_match.to_excel(writer, sheet_name='By Match', startrow=4, index=False)
        ws_match = writer.sheets['By Match']
        ws_match.merge_range('A1:D1', f'Báo cáo doanh thu {start} → {end}', title_format)
        ws_match.write('A2', f"Người xuất: {employee}")
        ws_match.write('A3', f"Thời gian: {now_str}")

        header_format = workbook.add_format({
            'bold': True, 'font_color': 'white',
            'bg_color': '#4F81BD', 'align': 'center'
        })
        for col_num, col_name in enumerate(df_match.columns):
            ws_match.write(4, col_num, col_name, header_format)

        # Sheet: By Section
        df_sec = pd.DataFrame(by_section)
        df_sec.to_excel(writer, sheet_name='By Section', startrow=4, index=False)
        ws_sec = writer.sheets['By Section']
        ws_sec.merge_range('A1:C1', f'Báo cáo doanh thu {start} → {end}', title_format)
        ws_sec.write('A2', f"Người xuất: {employee}")
        ws_sec.write('A3', f"Thời gian: {now_str}")
        header_format_sec = workbook.add_format({
            'bold': True, 'font_color': 'white',
            'bg_color': '#C0504D', 'align': 'center'
        })
        for col_num, col_name in enumerate(df_sec.columns):
            ws_sec.write(4, col_num, col_name, header_format_sec)

    output.seek(0)
    response = HttpResponse(
         output.getvalue(),
         content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    response['Content-Disposition'] = 'attachment; filename="revenue_report.xlsx"'
    return response

# ─── Helper xuất PDF cho TicketStatus ────────────────────────────────────
def export_ticket_status_pdf(request, matches, sections):
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4,
                            rightMargin=40, leftMargin=40,
                            topMargin=60, bottomMargin=40)
    styles = getSampleStyleSheet()
    elems = []
    start = request.query_params.get('start_date')
    end   = request.query_params.get('end_date')

    # Tiêu đề chung
    elems.append(Paragraph(f"Báo cáo tình trạng vé<br/>{start} đến {end}", style=title_style))
    raw_user = request.query_params.get('employee_name', '')
    user = urllib.parse.unquote(raw_user)
    now_str = timezone.localtime(timezone.now()).strftime("%d/%m/%Y %H:%M")
    elems.append(Paragraph(f"Người xuất: {user}", info_style))
    elems.append(Paragraph(f"Thời gian: {now_str}", info_style))
    elems.append(Spacer(1, 12))

    # 1) Bảng theo trận
    elems.append(Paragraph("1. Tình trạng vé theo trận", header_style))
    data_m = [["Match ID","Tên trận","Ngày trận","Sức chứa","Đã bán","Còn lại","Tỷ lệ lấp đầy (%)"]]
    for r in matches:
        data_m.append([
            r['match_id'],
            r['match_name'],
            r['match_date'].strftime("%d/%m/%Y %H:%M"),
            int(r['total_capacity']),
            int(r['sold_tickets']),
            int(r['available_tickets']),
            f"{r['fill_rate']:.2f}"
        ])
    tbl_m = Table(data_m, repeatRows=1)
    tbl_m.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,0),colors.HexColor("#4BACC6")),
        ('TEXTCOLOR',(0,0),(-1,0),colors.white),
        ('ALIGN',(0,0),(-1,-1),'CENTER'),
        ('GRID',(0,0),(-1,-1),0.5,colors.gray),
        ('FONTNAME',(0,0),(-1,0),'Nunito-Bold'),
        ('FONTNAME',(0,1),(-1,-1),'Nunito-Medium'),
    ]))
    elems.append(tbl_m)
    elems.append(Spacer(1, 24))

    # 2) Bảng theo khu vực
    elems.append(Paragraph("2. Tình trạng vé theo khu vực", header_style))
    data_s = [["Section ID","Tên khu vực","Sức chứa","Còn lại"]]
    for r in sections:
        data_s.append([
            r['section_id'],
            r['section_name'],
            int(r['capacity']),
            int(r['available_seats']),
        ])
    tbl_s = Table(data_s, repeatRows=1)
    tbl_s.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,0),colors.HexColor("#F79646")),
        ('TEXTCOLOR',(0,0),(-1,0),colors.white),
        ('ALIGN',(0,0),(-1,-1),'CENTER'),
        ('GRID',(0,0),(-1,-1),0.5,colors.gray),
        ('FONTNAME',(0,0),(-1,0),'Nunito-Bold'),
        ('FONTNAME',(0,1),(-1,-1),'Nunito-Medium'),
    ]))
    elems.append(tbl_s)

    doc.build(elems)
    buffer.seek(0)
    return HttpResponse(
        buffer,
        content_type='application/pdf',
        headers={'Content-Disposition':'attachment; filename="ticket_status_report.pdf"'}
    )

# ─── Helper xuất Excel cho TicketStatus ─────────────────────────────────
def export_ticket_status_xlsx(request, matches, sections):
    output = BytesIO()
    start_date = request.query_params.get('start_date', '')
    end_date   = request.query_params.get('end_date', '')
    with pd.ExcelWriter(output, engine='xlsxwriter') as writer:

        # Sheet “By Match”
        df_m = pd.DataFrame(matches)
        raw_user = request.query_params.get('employee_name', '')
        employee = urllib.parse.unquote(raw_user)
        if 'match_date' in df_m.columns:
            df_m['match_date'] = df_m['match_date'].dt.tz_localize(None)

        df_m.to_excel(writer, sheet_name='By Match', startrow=4, index=False)

        # Sheet “By Section”
        df_s = pd.DataFrame(sections)
        df_s.to_excel(writer, sheet_name='By Section', startrow=4, index=False)

        wb = writer.book
        header_fmt = wb.add_format({
            'bold': True, 'font_color':'white',
            'bg_color':'#4BACC6','align':'center'
        })

        for sheet_name, df in [('By Match', df_m), ('By Section', df_s)]:
            ws = writer.sheets[sheet_name]
            # Tiêu đề & thông tin
            ws.merge_range('A1:G1', f'Báo cáo tình trạng vé\n{start_date} → {end_date}', wb.add_format({
                'align':'center','bold':True,'font_size':14
            }))
            ws.write('A2','Người xuất:')
            ws.write('B2', employee)
            ws.write('A3','Thời gian:')
            ws.write('B3', timezone.now().strftime('%d/%m/%Y %H:%M'))
            # Áp dụng style header
            for col_num in range(len(df.columns)):
                ws.write(4, col_num, df.columns[col_num], header_fmt)

    output.seek(0)
    return HttpResponse(
        output.getvalue(),
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        headers={'Content-Disposition':'attachment; filename="ticket_status_report.xlsx"'
        }
    )

class RevenueReportAPIView(APIView):
    """
    Báo cáo doanh thu:
      • total_revenue – tổng doanh thu
      • by_date       – doanh thu theo ngày (theo created_at)
      • by_match      – doanh thu theo trận
      • by_section    – doanh thu theo khu vực
    Hỗ trợ params:
      • league_id     – chỉ lấy data của giải đó
      • match_id      – chỉ lấy data của trận đó
      • start_date    – ngày bắt đầu (YYYY-MM-DD)
      • end_date      – ngày kết thúc (YYYY-MM-DD)
    """
    def get(self, request):
        league_id       = request.query_params.get('league_id')
        match_id        = request.query_params.get('match_id')
        start_date_str  = request.query_params.get('start_date')
        end_date_str    = request.query_params.get('end_date')

        # 1) Parse start/end dates
        start_dt = end_dt = None
        if start_date_str and end_date_str:
            try:
                sd = datetime.strptime(start_date_str, "%Y-%m-%d").date()
                ed = datetime.strptime(end_date_str,   "%Y-%m-%d").date()
                tz = timezone.get_current_timezone()
                start_dt = timezone.make_aware(datetime.combine(sd, time.min), tz)
                end_dt   = timezone.make_aware(datetime.combine(ed, time.max), tz)
            except ValueError:
                return Response(
                    {"status":"error","message":"start_date và end_date phải theo định dạng YYYY-MM-DD"},
                    status=status.HTTP_400_BAD_REQUEST
                )

        # 2) Khởi tạo queryset cơ bản
        qs = Order.objects.filter(
            order_status='received',
            payment__payment_status='success'
        )

        # 2a) Lọc theo league nếu có
        if league_id:
            qs = qs.filter(order_details__pricing__match__league_id=league_id)

        # 2b) Lọc theo match nếu có
        if match_id:
            qs = qs.filter(order_details__pricing__match_id=match_id)

        # 2c) Lọc theo khoảng thời gian created_at
        if start_dt and end_dt:
            qs = qs.filter(created_at__gte=start_dt, created_at__lte=end_dt)

        # 3) Tính tổng doanh thu
        total_revenue = qs.values('order_id').distinct().aggregate(
            total=Sum('total_amount')
        )['total'] or 0

        # 4) Doanh thu theo ngày
        by_date_qs = (
            qs
            .annotate(
                converted=Func(
                    F('created_at'),
                    Value('+00:00'),
                    Value('+07:00'),
                    function='CONVERT_TZ',
                    output_field=DateTimeField()
                )
            )
            .values(
                day=Func(
                    F('converted'),
                    function='DATE',
                    output_field=DateField()
                )
            )
            .filter(day__gte=start_dt, day__lte=end_dt)
            .values('day')
            .annotate(revenue=Sum('total_amount'))
            .order_by('day')
        )


        # 5) Doanh thu theo trận
        qs_with_name = qs.annotate(
            match_name=Concat(
                F('order_details__pricing__match__team_1__team_name'),
                Value(' vs '),
                F('order_details__pricing__match__team_2__team_name'),
            )
        )
        by_match = (
            qs_with_name.values(
                match_id=F('order_details__pricing__match_id'),
                match_time=F('order_details__pricing__match__match_time'),
                match_name=F('match_name'),
            )
            .annotate(revenue=Sum('total_amount'))
            .order_by('match_time')
        )

        # 6) Doanh thu theo khu vực
        by_section = (
            qs.values(
                section_id=F('order_details__pricing__section_id'),
                section_name=F('order_details__pricing__section__section_name')
            )
            .annotate(revenue=Sum('total_amount'))
            .order_by('section_name')
        )

        # Chuyển QuerySet thành list of dict
        list_by_match   = list(by_match)
        list_by_section = list(by_section)

        # Nếu user yêu cầu export
        fmt = request.query_params.get('export_format')
        if fmt == 'pdf':
            return export_revenue_pdf(request, list_by_match, list_by_section)
        elif fmt == 'xlsx':
            return export_revenue_xlsx(request, list_by_match, list_by_section)

        # Ngược lại trả JSON như bình thường
        data = {
            'total_revenue': total_revenue,
            'by_date': list(by_date_qs),
            'by_match':   list_by_match,
            'by_section': list_by_section,
        }
        serializer = RevenueReportSerializer(data)
        return Response({'status':'success', **serializer.data}, status=status.HTTP_200_OK)
import logging
logger = logging.getLogger(__name__)

class TicketStatusReportAPIView(APIView):
    """
    Báo cáo tình trạng vé:
      • by_match    – sức chứa, vé bán & còn lại, tỷ lệ lấp đầy theo trận
      • by_section  – sức chứa & còn lại theo khu vực
      • daily_sales – số vé bán theo ngày
    """

    def get(self, request, *args, **kwargs):
        league_id      = request.query_params.get('league_id')
        match_id       = request.query_params.get('match_id')
        sport_id       = request.query_params.get('sport_id')
        start_date_str = request.query_params.get('start_date')
        end_date_str   = request.query_params.get('end_date')

        # 1. Xử lý ngày tháng (Chuẩn hóa)
        start_date_obj = None
        end_date_obj = None
        
        # Biến dùng để lọc thời gian trận đấu (datetime)
        filter_match_start = None
        filter_match_end = None

        if start_date_str and end_date_str:
            try:
                # Parse string sang date
                sd = datetime.strptime(start_date_str, "%Y-%m-%d").date()
                ed = datetime.strptime(end_date_str,   "%Y-%m-%d").date()
                
                start_date_obj = sd
                end_date_obj = ed

                # Tạo datetime aware để lọc chính xác
                tz = timezone.get_current_timezone()
                filter_match_start = timezone.make_aware(datetime.combine(sd, time.min), tz)
                filter_match_end   = timezone.make_aware(datetime.combine(ed, time.max), tz)
            except ValueError:
                return Response(
                    {"status": "error", "message": "Ngày phải định dạng YYYY-MM-DD"},
                    status=status.HTTP_400_BAD_REQUEST
                )

        # ─── 2) BY-MATCH & BY-SECTION: từ SectionPrice ──────────────────────────
        # Logic: Lấy tất cả SectionPrice, gom nhóm theo Trận để tính tổng
        sp_qs = SectionPrice.objects.select_related(
            'match__team_1', 'match__team_2', 'section', 'match__league'
        )

        if league_id:
            sp_qs = sp_qs.filter(match__league_id=league_id)

        if match_id:
            sp_qs = sp_qs.filter(match_id=match_id)

        # Nếu người dùng lọc theo môn thể thao
        if sport_id:
            sp_qs = sp_qs.filter(match__league__sport_id=sport_id)

        # FIX LOGIC: Lọc trận đấu theo NGÀY ĐÁ (match_time), không phải ngày mua vé
        if filter_match_start and filter_match_end:
            sp_qs = sp_qs.filter(
                match__match_time__range=(filter_match_start, filter_match_end)
            )

        # Tổng hợp theo trận
        matches = (
            sp_qs.values(
                'match_id',
                match_name=Concat(
                    F('match__team_1__team_name'), Value(' vs '),
                    F('match__team_2__team_name'),
                    output_field=CharField()
                ),
                match_date=F('match__match_time'),
            )
            .annotate(
                total_capacity    = Sum('section__capacity'),
                available_tickets = Sum('available_seats'), # Số ghế còn trống
            )
            .annotate(
                # Vé đã bán = Tổng sức chứa - Số ghế còn trống
                sold_tickets = F('total_capacity') - F('available_tickets'),
                
                # Tỷ lệ lấp đầy
                fill_rate    = ExpressionWrapper(
                    (F('total_capacity') - F('available_tickets')) * 100.0 / F('total_capacity'),
                    output_field=DecimalField(max_digits=5, decimal_places=2)
                )
            )
            .order_by('match_date')
        )

        # Tổng hợp theo khu vực (Chỉ có ý nghĩa khi chọn 1 trận cụ thể)
        # Nếu không chọn match_id, nó sẽ cộng dồn capacity của các trận (hơi vô nghĩa)
        # Nên ta chỉ trả về khi có match_id hoặc chấp nhận cộng dồn
        # Tổng hợp theo khu vực
        sections = (
            sp_qs.values(
                'section_id',
                section_name = F('section__section_name'),
                capacity     = F('section__capacity'),
            )
            .annotate(
                # --- SỬA Ở ĐÂY ---
                # Code cũ: current_available = Sum('available_seats'),
                # Code mới: Đổi tên thành 'available_seats' cho khớp với Frontend
                available_seats = Sum('available_seats'), 
            )
            .annotate(
                # Cập nhật lại công thức tính vé đã bán theo tên biến mới
                sold = F('capacity') - F('available_seats')
            )
            .order_by('section_name')
        )

        # ─── 3) DAILY SALES: từ OrderDetail (Vé thực bán) ────────────────
        # Chỉ lấy vé đã thanh toán thành công
        daily_qs = OrderDetail.objects.filter(
            order__payment__payment_status="SUCCESS" # Chú ý check đúng string trong DB (success/SUCCESS)
            # order__order_status="SUCCESS"
        )
        
        if league_id:
            daily_qs = daily_qs.filter(pricing__match__league_id=league_id)
        if match_id:
            daily_qs = daily_qs.filter(pricing__match_id=match_id)
        if sport_id:
            daily_qs = daily_qs.filter(pricing__match__league__sport_id=sport_id)

        # FIX LOGIC: Dùng TruncDate để group theo ngày (DB Agnostic - không sợ lỗi timezone MySQL)
        daily = (
            daily_qs
            .annotate(day=TruncDate('order__created_at')) # Cắt datetime thành date
            .values('day')
            .annotate(sold=Count('detail_id'))
            .order_by('day')
        )

        # FIX CRASH: Chỉ lọc ngày nếu người dùng có gửi ngày lên
        if start_date_obj and end_date_obj:
            daily = daily.filter(day__range=(start_date_obj, end_date_obj))

        # ─── 4) Build payload & serialize ───────────────────────────────────
        list_matches = list(matches)
        list_sections = list(sections)
        list_daily = list(daily)

        # Export (Nếu có code export)
        fmt = request.query_params.get('export_format')
        if fmt == 'pdf':
            return export_ticket_status_pdf(request, list_matches, list_sections)
        if fmt == 'xlsx':
            return export_ticket_status_xlsx(request, list_matches, list_sections)

        # Serializer thủ công (hoặc dùng serializer class nếu bạn có)
        return Response({
            "status":      "success",
            "filter_info": {
                "sport_id": sport_id,
                "league_id": league_id,
                "match_id": match_id,
                "start_date": start_date_str,
                "end_date": end_date_str
            },
            "payload": {
                "matches": list_matches,
                "sections": list_sections
            },
            "daily_sales": list_daily,
        }, status=status.HTTP_200_OK)

class PromotionUsageReportAPIView(APIView):
    def get(self, request):
        qs = OrderDetail.objects.filter(promotion__isnull=False)
        data = (
            qs.values(code=F('promotion__promo_code'))
              .annotate(
                  usage_count=Count('detail_id'),
                  total_discount=Sum(
                      Case(
                          When(promotion__discount_type='percentage', then=
                               ExpressionWrapper(
                                  F('price') * F('promotion__discount_value') / 100,
                                  output_field=DecimalField()
                               )
                          ),
                          When(promotion__discount_type='amount', then=F('promotion__discount_value')),
                          default=Value(0), output_field=DecimalField()
                      )
                  )
              )
        )
        result = [{'promo_code': x['code'], 'usage_count': x['usage_count'], 'total_discount': x['total_discount']} for x in data]
        serializer = PromotionUsageSerializer(result, many=True)
        return Response(serializer.data)

class ReturnReportAPIView(APIView):
    def get(self, request):
        # 1) Đọc params
        start_date_str = request.query_params.get('start_date')
        end_date_str   = request.query_params.get('end_date')
        league_id      = request.query_params.get('league_id')
        match_id       = request.query_params.get('match_id')

        start_dt = end_dt = None
        if start_date_str and end_date_str:
            try:
                sd = datetime.strptime(start_date_str, "%Y-%m-%d").date()
                ed = datetime.strptime(end_date_str,   "%Y-%m-%d").date()
                tz = timezone.get_current_timezone()
                start_dt = timezone.make_aware(datetime.combine(sd, time.min), tz)
                end_dt   = timezone.make_aware(datetime.combine(ed, time.max), tz)
            except ValueError:
                return Response(
                    {"status": "error", "message": "start_date và end_date phải theo định dạng YYYY-MM-DD"},
                    status=status.HTTP_400_BAD_REQUEST
                )

        # 2) Build queryset
        qs = TicketReturn.objects.select_related(
            'detail__pricing__match__league'
        )

        # 2a) Lọc theo league nếu có
        if league_id:
            qs = qs.filter(
                detail__pricing__match__league__league_id=league_id
            )
        # 2b) Lọc theo match nếu có
        if match_id:
            qs = qs.filter(
                detail__pricing__match__match_id=match_id
            )
        # 2c) Lọc theo khoảng ngày của match_time
        # if start_dt and end_dt:
        #     qs = qs.filter(
        #         detail__pricing__match__match_time__gte=start_dt,
        #         detail__pricing__match__match_time__lte=end_dt
        #     )

        if start_dt and end_dt:
            qs = qs.filter(
                detail__order__created_at__gte=start_dt,
                detail__order__created_at__lte=end_dt
            )

        # 3) Tính toán và trả về
        total_returns = qs.count()
        total_refund  = qs.aggregate(total=Sum('refund_amount'))['total'] or 0
        returns       = qs.order_by('-detail__pricing__match__match_time')

        serializer = ReturnReportSerializer({
            'total_returns': total_returns,
            'total_refunded_amount': total_refund,
            'returns': returns
        })
        return Response(serializer.data)


# Viết view cho quản lý đơn đặt hàng (admin, staff)
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from apps.orders.models import Order
from .serializers import OrderSerializer

class OrderViewSet(viewsets.ReadOnlyModelViewSet):
    """
    list:
        GET /orders/ → Danh sách đơn với filter:
          - ?status=pending|received|cancelled
          - ?method=offline|online
          - ?from_date=YYYY-MM-DD
          - ?to_date=YYYY-MM-DD
          - ?season=<league_id>
          - ?match=<match_id>
          - ?search=...   (search trên order_id hoặc user.full_name)
    retrieve:
        GET /orders/{pk}/ → Chi tiết đơn đặt hàng
    """
    queryset = Order.objects.all().order_by('-created_at')
    serializer_class = OrderSerializer
    
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['order_id', 'user__full_name']
    ordering_fields = ['created_at', 'total_amount']
    # permission_classes = [IsAuthenticated]

    def get_queryset(self):
        qs = Order.objects.all().order_by('-created_at')

        # Defensive: exclude rows with malformed primary keys (non-UUIDs).
        # Use a DB-specific strategy: MySQL often has issues with the regex translation, so use a length check there.
        from django.db import connection
        engine = connection.settings_dict.get('ENGINE', '').lower()
        if 'mysql' in engine:
            try:
                qs = qs.extra(where=["LENGTH(REPLACE(order_id,'-','')) = 32"])  # MySQL compatible
            except Exception:
                # best-effort: if extra fails, continue without the defensive filter
                pass
        else:
            try:
                qs = qs.filter(order_id__regex=r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
            except Exception:
                try:
                    qs = qs.extra(where=["LENGTH(REPLACE(order_id,'-','')) = 32"])  # Fallback
                except Exception:
                    pass

        season_id = self.request.query_params.get('season')
        match_id  = self.request.query_params.get('match')
        params = self.request.query_params

        if season_id:
            # nối qua order_details → SectionPrice → Section → Match → Season
            qs = qs.filter(
                order_details__pricing__match__league__league_id=season_id
            )
        if match_id:
            # nếu muốn chỉ lấy order của 1 trận đấu cụ thể
            qs = qs.filter(
                order_details__pricing__match__match_id=match_id
            )

        status_param = params.get('status')
        if status_param:
            qs = qs.filter(order_status=status_param)

        # filter theo method
        method_param = params.get('method')
        if method_param:
            qs = qs.filter(order_method=method_param)

        # filter theo ngày tạo đơn
        qs = qs.annotate(created_date=TruncDate('created_at'))
        from_date = params.get('from_date')
        to_date   = params.get('to_date')
        if from_date:
            d = parse_date(from_date)
            # bắt đầu ngày (00:00:00) theo tz hiện tại
            start_dt = timezone.make_aware(datetime.combine(d, time.min), timezone.get_current_timezone())
            qs = qs.filter(created_at__gte=start_dt)
        if to_date:
            d = parse_date(to_date)
            # kết thúc ngày (23:59:59.999999)
            end_dt = timezone.make_aware(datetime.combine(d, time.max), timezone.get_current_timezone())
            qs = qs.filter(created_at__lte=end_dt)
        return qs.distinct().order_by('-created_at')
    
    def list(self, request, *args, **kwargs):
        """Return paginated list of orders (clean, no debug prints)."""
        return super().list(request, *args, **kwargs)
    
    def retrieve(self, request, *args, **kwargs):
        order = self.get_object()

        # Lấy tất cả order details, đồng thời select_related pricing→match và các quan hệ con
        details_qs = (
            OrderDetail.objects
            .filter(order=order)
            .select_related(
                'pricing__match__league',
                'pricing__match__stadium',
                'pricing__match__team_1',
                'pricing__match__team_2',
            )
        )

        # Build danh sách chi tiết vé
        details = []
        for d in details_qs:
            pr = d.pricing
            m = pr.match
            details.append({
                'detail_id': d.detail_id,
                'seat': d.seat.seat_number if d.seat else None,
                'section': d.pricing.section.section_name if d.pricing.section else None,
                'price': str(d.price),
                'promotion': d.promotion.promo_code if d.promotion else None,
                'qr_code': d.qr_code,
                'updated_at': d.updated_at.isoformat(),
            })

        # Thông tin trận đấu (lấy từ detail đầu tiên, nếu có)
        if details_qs:
            m = details_qs[0].pricing.match
            match_info = {
                'match_id': m.match_id,
                'description': m.description,
                'league': m.league.league_name,
                'stadium': m.stadium.stadium_name,
                'team_1': m.team_1.team_name,
                'team_2': m.team_2.team_name,
                'round': m.round,
                'match_time': m.match_time.isoformat(),
            }
        else:
            match_info = {}

        if order.order_status == 'cancelled':
            payment_info = {}
        else:
            payment = order.payment if order.payment else None
            payment_info = {
                'payment_method': payment.payment_method if payment else None,
                'payment_status': payment.payment_status if payment else None,
                'transaction_code': payment.transaction_code if payment else None,
            }
        
        # print("Payment", payment)
        

        # Build response
        data = {
            'order_id': order.order_id,
            'user': order.user.full_name + ' - ' + order.user.phone_number,
            'total_amount': str(order.total_amount),
            'order_status': order.order_status,
            'order_status_display': order.get_order_status_display(),
            'order_method': order.order_method,
            'order_method_display': order.get_order_method_display(),
            'created_at': order.created_at.isoformat(),
            'match': match_info,
            'details': details,
            'payments': payment_info,
        }

        return Response(data, status=status.HTTP_200_OK)
    
# Viết view cho lấy danh sách giải
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from apps.events.models import League, Match
from .serializers import LeagueListSerializer

class LeagueListAPIView(APIView):
    """
    GET /api/leagues/ → trả về danh sách các giải đấu (chỉ id + tên)
    """
    # permission_classes = [IsAuthenticatedOrReadOnly]

    def get(self, request):
        leagues = League.objects.all().order_by('start_date')

        active = request.query_params.get('active')
        if active and active.lower() in ('true', '1', 'yes'):
            leagues = leagues.filter(end_date__gte=timezone.now().date())

        # Lọc theo môn thể thao nếu có
        sport_id = request.query_params.get('sport_id')
        if sport_id:
            leagues = leagues.filter(sport_id=sport_id)

        serializer = LeagueListSerializer(leagues, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class MatchListByLeagueAPIView(APIView):
    """
    GET /api/leagues/<int:league_id>/matches/
    Trả về danh sách các trận của giải đấu với league_id
    """

    def get(self, request, league_id, format=None):

        matches = Match.objects.filter(
            league_id=league_id,
        ).order_by('match_time')

        upcoming = request.query_params.get('upcoming')
        if upcoming and upcoming.lower() in ('true', '1', 'yes'):
            matches = matches.filter(match_time__gte=timezone.now())

        result = [
            {
                "match_id":        m.match_id,
                "display":         str(m),
                "match_time":      m.match_time,
                "match_time_fmt":  m.match_time.strftime("%d %b %Y, %H:%M"),
            }
            for m in matches
        ]

        return Response(result, status=status.HTTP_200_OK)


# Viết view cho quản lý giao dịch (admin, staff)
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import generics, filters
from apps.orders.models import Payment
from .serializers import PaymentSerializer

class PaymentListAPIView(generics.ListAPIView):
    """
    API cho danh sách giao dịch.
    - GET /api/reports/payments/
    - Params:
        * status: lọc theo payment_status
        * payment_method: lọc theo hình thức
        * start_date, end_date: lọc theo khoảng ngày (YYYY-MM-DD)
        * search: tìm kiếm theo order_id hoặc transaction_code
    """
    queryset = Payment.objects.all().select_related('order')
    serializer_class = PaymentSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['payment_status', 'payment_method']
    search_fields = ['order__order_id', 'transaction_code']

    def get_queryset(self):
        qs = super().get_queryset().filter(payment_status='success')
        params = self.request.query_params
        start_str = params.get('start_date')
        end_str   = params.get('end_date')
        
        tz = timezone.get_current_timezone()

        # Xây dựng datetime-aware cho từng trường hợp
        if start_str:
            sd = datetime.strptime(start_str, "%Y-%m-%d").date()
            # 00:00:00 local
            start_local = datetime.combine(sd, time.min)
            start_aware = timezone.make_aware(start_local, tz).astimezone(timezone.utc)
            qs = qs.filter(created_at__gte=start_aware)

        if end_str:
            ed = datetime.strptime(end_str, "%Y-%m-%d").date()
            # 23:59:59.999999 local
            end_local = datetime.combine(ed, time.max)
            end_aware = timezone.make_aware(end_local, tz).astimezone(timezone.utc)
            qs = qs.filter(created_at__lte=end_aware)
            
        return qs.order_by('-created_at')


class PaymentDetailAPIView(generics.RetrieveAPIView):
    """
    API cho chi tiết giao dịch.
    - GET /api/orders/payments/{payment_id}/
    """
    queryset = Payment.objects.all()
    serializer_class = PaymentSerializer
    lookup_field = 'payment_id'
# Hệ thống dự báo
import os
import joblib
import numpy as np
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime

class PredictDemandView(APIView):
    """
    API Dự báo nhu cầu vé sử dụng Machine Learning.
    Endpoint: /api/reports/predict-demand/
    Method: POST
    Body: { "date": "2025-11-20 19:00", "price": 200000 }
    """
    def post(self, request):
        try:
            # 1. Lấy dữ liệu đầu vào
            date_str = request.data.get('date')
            price = request.data.get('price')

            if not date_str or price is None:
                return Response(
                    {"error": "Vui lòng gửi đủ 'date' (YYYY-MM-DD HH:MM) và 'price'"}, 
                    status=status.HTTP_400_BAD_REQUEST
                )

            # 2. Xử lý dữ liệu (Feature Engineering) giống hệt lúc Train
            try:
                dt = datetime.strptime(date_str, '%Y-%m-%d %H:%M')
            except ValueError:
                 return Response({"error": "Định dạng ngày sai. Hãy dùng YYYY-MM-DD HH:MM"}, status=status.HTTP_400_BAD_REQUEST)

            day_of_week = dt.weekday() # Thứ 2=0 ... CN=6
            hour = dt.hour
            price = float(price)

            # 3. Load Model (Đảm bảo bạn đã chạy lệnh train_model trước đó)
            model_path = os.path.join(settings.BASE_DIR, 'ml_models', 'ticket_demand_model.pkl')
            
            if not os.path.exists(model_path):
                 return Response(
                     {"error": "Chưa tìm thấy Model. Vui lòng chạy lệnh 'python manage.py train_model' trước."}, 
                     status=status.HTTP_503_SERVICE_UNAVAILABLE
                 )
            
            # Load model (có thể cache model này để tối ưu hiệu năng, nhưng demo thì load trực tiếp cũng được)
            model = joblib.load(model_path)

            # 4. Dự đoán
            # Input phải là mảng 2 chiều [[feature1, feature2, feature3]]
            features = np.array([[day_of_week, hour, price]])
            predicted_sold = model.predict(features)[0] # Lấy kết quả đầu tiên

            # Xử lý kết quả (không lấy số âm, làm tròn số nguyên)
            predicted_sold = int(max(0, round(predicted_sold)))

            # 5. Đưa ra gợi ý chiến lược (Business Insight) - Phần này ăn điểm Đồ Án
            suggestion = ""
            if predicted_sold >= 80: # Trước đây là 150 (quá cao), giờ giảm xuống 80
                suggestion = "Nhu cầu CAO. Có thể TĂNG giá vé để tối ưu doanh thu."
            elif predicted_sold <= 40: # Trước đây là 30
                suggestion = "Nhu cầu THẤP. Nên chạy chương trình KHUYẾN MÃI."
            else:
                suggestion = "Nhu cầu ỔN ĐỊNH."

            return Response({
                "input": {
                    "date": date_str,
                    "day_of_week": "Cuối tuần" if day_of_week >= 5 else "Trong tuần",
                    "hour": f"{hour} giờ",
                    "price": f"{price:,.0f} VNĐ"
                },
                "prediction": {
                    "estimated_ticket_sold": predicted_sold,
                    "revenue_forecast": f"{predicted_sold * price:,.0f} VNĐ",
                    "suggestion": suggestion
                }
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": f"Lỗi Server: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)