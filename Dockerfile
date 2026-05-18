FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY ticket_booking/requirements.txt /app/

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt -f https://download.pytorch.org/whl/cpu/torch_stable.html

COPY . /app/

RUN chmod +x /app/entrypoint-web.sh /app/entrypoint-worker.sh /app/entrypoint-beat.sh

ENV DJANGO_SETTINGS_MODULE=ticket_booking.settings
ENV PORT=10000

EXPOSE 10000

CMD ["sh", "entrypoint-web.sh"]
