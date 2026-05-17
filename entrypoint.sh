#!/bin/bash
set -e

cd ticket_booking

echo "Running migrations..."
for i in {1..30}; do
    python manage.py migrate --noinput && break || sleep 2
done

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting celery worker..."
python -m celery -A ticket_booking.celery worker -l info &

echo "Starting celery beat..."
python -m celery -A ticket_booking.celery beat -l info &

echo "Starting daphne on 0.0.0.0:${PORT:-10000}..."
exec python -m daphne -b 0.0.0.0 -p "${PORT:-10000}" ticket_booking.asgi:application
