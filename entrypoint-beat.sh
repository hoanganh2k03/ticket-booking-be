#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ticket_booking"

export DJANGO_SETTINGS_MODULE="${DJANGO_SETTINGS_MODULE:-ticket_booking.settings}"
export PYTHONPATH="$SCRIPT_DIR/ticket_booking"

if [ -n "$REDIS_URL" ]; then
  if [ -z "$CELERY_BROKER_URL" ] || [ "$CELERY_BROKER_URL" = '${REDIS_URL}' ] || [ "$CELERY_BROKER_URL" = '$REDIS_URL' ]; then
    export CELERY_BROKER_URL="$REDIS_URL"
  fi
  if [ -z "$BROKER_URL" ] || [ "$BROKER_URL" = '${REDIS_URL}' ] || [ "$BROKER_URL" = '$REDIS_URL' ]; then
    export BROKER_URL="$REDIS_URL"
  fi
fi

PYTHON=python
if ! command -v "$PYTHON" >/dev/null 2>&1; then
    PYTHON=python3
fi

printf 'Using Python interpreter: %s\n' "$PYTHON"
printf 'CELERY_BROKER_URL=%s\n' "$CELERY_BROKER_URL"
exec "$PYTHON" -m celery -A ticket_booking.celery beat -l info
