#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

export SKIP_CELERY=1
export DJANGO_SETTINGS_MODULE="${DJANGO_SETTINGS_MODULE:-ticket_booking.settings}"
export PORT="${PORT:-10000}"

exec "$SCRIPT_DIR/entrypoint.sh"
