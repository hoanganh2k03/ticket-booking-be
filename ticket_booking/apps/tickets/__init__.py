# apps/tickets/__init__.py
from __future__ import absolute_import, unicode_literals

# Đảm bảo Celery app được khởi tạo đúng
from ticket_booking.celery import app as celery_app

__all__ = ('celery_app',)
