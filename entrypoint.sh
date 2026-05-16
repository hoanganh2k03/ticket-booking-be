#!/bin/bash
set -e

cd /app/ticket_booking

echo "Running migrations..."
python manage.py migrate --noinput || echo "Migration failed or already applied"

echo "Collecting static files..."
python manage.py collectstatic --noinput || echo "Static files collection skipped"

echo "Starting Daphne server..."
exec daphne -b 0.0.0.0 -p 10000 ticket_booking.asgi:application
