#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ticket_booking"

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
echo "Launching start_services.py (spawns daphne, celery, and runs migrations)..."
exec "$PYTHON" start_services.py
