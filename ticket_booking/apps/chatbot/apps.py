import os
import time
import threading
import socket
import urllib.parse
from django.apps import AppConfig
from django.conf import settings


def _wait_for_server_and_warmup():
    # Only run warm-up in the reloader child process to avoid duplicate work
    if os.environ.get("RUN_MAIN") != "true":
        return

    if not getattr(settings, "CHATBOT_WARMUP_ON_START", True):
        print("⚠️ Chatbot warm-up disabled by settings.CHATBOT_WARMUP_ON_START=False")
        return

    url = getattr(settings, "CHATBOT_WARMUP_URL", "http://127.0.0.1:8000/")
    timeout = getattr(settings, "CHATBOT_WARMUP_WAIT_TIMEOUT", 30)

    parsed = urllib.parse.urlparse(url)
    host = parsed.hostname or "127.0.0.1"
    port = parsed.port or (443 if parsed.scheme == "https" else 80)

    start = time.time()
    print(f"🔁 Waiting for server at {host}:{port} to be available (timeout {timeout}s)")
    while time.time() - start < timeout:
        try:
            with socket.create_connection((host, port), timeout=1):
                print(f"✅ Server {host}:{port} is reachable. Proceeding to warm-up.")
                break
        except Exception:
            time.sleep(0.5)
    else:
        print(f"⚠️ Timed out waiting for server at {host}:{port}; proceeding to warm-up anyway.")

    try:
        from .services.nlp_service import get_client
        from .services.db_service import get_embeddings
        get_client()
        get_embeddings()
        print("✅ Chatbot background warm-up completed.")
    except Exception as e:
        print("⚠️ Chatbot warm-up error:", e)


class ChatbotConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.chatbot'

    def ready(self):
        # Start warm-up in background so runserver returns fast
        threading.Thread(target=_wait_for_server_and_warmup, daemon=True).start()
