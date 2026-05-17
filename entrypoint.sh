#!/bin/sh
set -e

cd ticket_booking

PYTHON=python
if ! command -v "$PYTHON" >/dev/null 2>&1; then
    PYTHON=python3
fi

printf 'Using Python interpreter: %s\n' "$PYTHON"
command -v "$PYTHON" || true
"$PYTHON" --version || true

echo "Running migrations..."
count=0
while [ "$count" -lt 30 ]; do
    "$PYTHON" manage.py migrate --noinput && break || sleep 2
    count=$((count + 1))
done

echo "Collecting static files..."
"$PYTHON" manage.py collectstatic --noinput

echo "Starting celery worker..."
"$PYTHON" -m celery -A ticket_booking.celery worker -l info &

echo "Starting celery beat..."
"$PYTHON" -m celery -A ticket_booking.celery beat -l info &

echo "Starting daphne on 0.0.0.0:${PORT:-10000}..."
exec "$PYTHON" -m daphne -b 0.0.0.0 -p "${PORT:-10000}" ticket_booking.asgi:application
