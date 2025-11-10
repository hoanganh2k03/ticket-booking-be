from apscheduler.schedulers.background import BackgroundScheduler
from .utils import check_payment_expiration

def startJob():
    scheduler = BackgroundScheduler()
    scheduler.add_job(check_payment_expiration, 'interval', minutes=1)  # Lập lịch mỗi phút
    scheduler.start()
