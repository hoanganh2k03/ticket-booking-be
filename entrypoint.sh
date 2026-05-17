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

echo "Testing MySQL connectivity..."
"$PYTHON" - <<'PY'
import os, sys
import pymysql
try:
    conn = pymysql.connect(
        host=os.environ['MYSQL_HOST'],
        port=int(os.environ['MYSQL_PORT']),
        user=os.environ['MYSQL_USER'],
        password=os.environ['MYSQL_PASSWORD'],
        database=os.environ['MYSQL_DATABASE'],
        connect_timeout=5,
    )
    conn.close()
    print('MySQL connection OK')
except Exception as exc:
    print('MySQL connectivity test failed:', exc)
    sys.exit(1)
PY

echo "Testing Redis connectivity..."
"$PYTHON" - <<'PY'
import os, sys
import redis
try:
    client = redis.from_url(os.environ['REDIS_URL'], socket_connect_timeout=5, socket_timeout=5)
    client.ping()
    print('Redis connection OK')
except Exception as exc:
    print('Redis connectivity test failed:', exc)
    sys.exit(1)
PY

echo "Starting migration and static collection in background..."
"$PYTHON" manage.py migrate --noinput &
MIGRATE_PID=$!

echo "Started migrate (pid=$MIGRATE_PID)"

"$PYTHON" manage.py collectstatic --noinput &
COLLECTSTATIC_PID=$!

echo "Started collectstatic (pid=$COLLECTSTATIC_PID)"

echo "Starting celery worker..."
"$PYTHON" -m celery -A ticket_booking.celery worker -l info &
CELERY_WORKER_PID=$!

echo "Started celery worker (pid=$CELERY_WORKER_PID)"

echo "Starting celery beat..."
"$PYTHON" -m celery -A ticket_booking.celery beat -l info &
CELERY_BEAT_PID=$!

echo "Started celery beat (pid=$CELERY_BEAT_PID)"

echo "Starting daphne on 0.0.0.0:${PORT:-10000}..."
exec "$PYTHON" -m daphne -b 0.0.0.0 -p "${PORT:-10000}" ticket_booking.asgi:application
