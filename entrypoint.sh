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

echo "PORT=${PORT:-10000}"
echo "DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE:-ticket_booking.settings}"
echo "MYSQL_HOST=${MYSQL_HOST:-<missing>}"
echo "MYSQL_PORT=${MYSQL_PORT:-<missing>}"
echo "MYSQL_DATABASE=${MYSQL_DATABASE:-<missing>}"
echo "MYSQL_USER=${MYSQL_USER:-<missing>}"
echo "REDIS_URL=${REDIS_URL:-<missing>}"

echo "Checking required environment variables..."
if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_PORT" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$REDIS_URL" ]; then
    echo "ERROR: Missing required database or Redis environment variables."
    echo "Set MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, and REDIS_URL in Render."
    exit 1
fi

echo "Running migrations..."
count=0
while [ "$count" -lt 30 ]; do
    "$PYTHON" manage.py migrate --noinput && break || {
        echo "migrate attempt $((count + 1)) failed, retrying..."
        sleep 2
        count=$((count + 1))
    }
done

if [ "$count" -ge 30 ]; then
    echo "ERROR: manage.py migrate failed after 30 attempts."
    exit 1
fi

echo "Collecting static files..."
"$PYTHON" manage.py collectstatic --noinput

echo "Starting celery worker..."
"$PYTHON" -m celery -A ticket_booking.celery worker -l info &

echo "Starting celery beat..."
"$PYTHON" -m celery -A ticket_booking.celery beat -l info &

echo "Starting daphne on 0.0.0.0:${PORT:-10000}..."
exec "$PYTHON" -m daphne -b 0.0.0.0 -p "${PORT:-10000}" ticket_booking.asgi:application
