FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY ticket_booking/requirements.txt /app/

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

COPY . /app/

RUN chmod +x /app/entrypoint.sh

ENV DJANGO_SETTINGS_MODULE=ticket_booking.settings
ENV PORT=10000

WORKDIR /app/ticket_booking

EXPOSE 10000

ENTRYPOINT ["/app/entrypoint.sh"]
