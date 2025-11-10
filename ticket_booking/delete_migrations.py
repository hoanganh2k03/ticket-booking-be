import os
import shutil

# Thư mục gốc của dự án Django
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Hàm để xóa tất cả các file migration trong các app
def delete_all_migrations():
    for root, dirs, files in os.walk(BASE_DIR):
        # Kiểm tra nếu thư mục chứa "migrations"
        if 'migrations' in dirs:
            migration_dir = os.path.join(root, 'migrations')
            for file_name in os.listdir(migration_dir):
                file_path = os.path.join(migration_dir, file_name)
                # Xóa các file trong thư mục migrations, nhưng không xóa file __init__.py
                if file_name != '__init__.py' and os.path.isfile(file_path):
                    os.remove(file_path)
                    print(f"Đã xóa: {file_path}")

# Chạy hàm xóa migrations
delete_all_migrations()
