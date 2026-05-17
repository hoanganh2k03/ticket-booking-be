import os
import sys
import signal
import subprocess
import time
import threading

PROJECT_ROOT = os.path.dirname(__file__)
sys.path.insert(0, PROJECT_ROOT)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ticket_booking.settings')


def run_manage_commands():
    try:
        import django
        from django.core.management import call_command

        django.setup()
        call_command('migrate', '--noinput')
        call_command('collectstatic', '--noinput')
    except Exception:
        raise


def start_process(cmd, env=None):
    return subprocess.Popen(cmd, env=env, cwd=PROJECT_ROOT)


def terminate_process(p):
    try:
        if p.poll() is None:
            p.terminate()
            # fallback kill after short wait
            time.sleep(3)
            if p.poll() is None:
                p.kill()
    except Exception:
        pass


def main():
    port = os.environ.get('PORT', '8000')

    processes = []

    env = os.environ.copy()
    env['PYTHONPATH'] = PROJECT_ROOT
    env.setdefault('DJANGO_SETTINGS_MODULE', 'ticket_booking.settings')
    python = sys.executable

    # Start daphne first so web responds quickly
    daphne_cmd = [python, '-m', 'daphne', '-b', '0.0.0.0', '-p', str(port), 'ticket_booking.asgi:application']
    daphne_proc = start_process(daphne_cmd, env=env)
    processes.append(('daphne', daphne_proc))

    # Run migrations/collectstatic in background so startup is faster
    mgmt_thread = threading.Thread(target=run_manage_commands, daemon=True)
    mgmt_thread.start()

    # Optionally skip starting celery (useful when running dedicated worker/beat services)
    skip_celery = os.environ.get('SKIP_CELERY', '0').lower() in ('1', 'true', 'yes')

    if not skip_celery:
        # Start celery processes (they will run alongside daphne)
        cmds = [
            ('celery_worker', [python, '-m', 'celery', '-A', 'ticket_booking.celery', 'worker', '-l', 'info']),
            ('celery_beat', [python, '-m', 'celery', '-A', 'ticket_booking.celery', 'beat', '-l', 'info']),
        ]

        for name, cmd in cmds:
            p = start_process(cmd, env=env)
            processes.append((name, p))

    def handle_exit(signum, frame):
        for _name, p in processes:
            terminate_process(p)
        sys.exit(0)

    signal.signal(signal.SIGTERM, handle_exit)
    signal.signal(signal.SIGINT, handle_exit)

    try:
        # Monitor child processes; if any exits, shut down others and exit
        while True:
            for name, p in processes:
                rc = p.poll()
                if rc is not None:
                    for _n, _p in processes:
                        if _p is not p:
                            terminate_process(_p)
                    sys.exit(rc if rc >= 0 else 1)
            time.sleep(1)
    except KeyboardInterrupt:
        handle_exit(None, None)


if __name__ == '__main__':
    main()
