#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ticket_booking"

export DJANGO_SETTINGS_MODULE="${DJANGO_SETTINGS_MODULE:-ticket_booking.settings}"
export PYTHONPATH="$SCRIPT_DIR/ticket_booking"
export PORT="${PORT:-10000}"

PYTHON=python
if ! command -v "$PYTHON" >/dev/null 2>&1; then
    PYTHON=python3
fi

printf 'Using Python interpreter: %s\n' "$PYTHON"
echo "PORT=$PORT"
echo "DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE"

echo 'Starting web server...'
if command -v "$PYTHON" >/dev/null 2>&1 && "$PYTHON" -m uvicorn --help >/dev/null 2>&1; then
    exec "$PYTHON" -m uvicorn ticket_booking.asgi:application --host 0.0.0.0 --port "$PORT" --proxy-headers
else
    exec "$PYTHON" -m daphne -b 0.0.0.0 -p "$PORT" ticket_booking.asgi:application
fi
