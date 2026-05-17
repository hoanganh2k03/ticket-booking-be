#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ticket_booking"

export DJANGO_SETTINGS_MODULE="${DJANGO_SETTINGS_MODULE:-ticket_booking.settings}"
export PYTHONPATH="$SCRIPT_DIR/ticket_booking"

PYTHON=python
if ! command -v "$PYTHON" >/dev/null 2>&1; then
    PYTHON=python3
fi

printf 'Using Python interpreter: %s\n' "$PYTHON"
exec "$PYTHON" -m celery -A ticket_booking.celery worker -l info --concurrency=1 --pool=solo
