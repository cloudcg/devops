import shutil
import os
import logging
import tarfile
from DB.python_backup_restore.python_bak_restore.config import backup_dir, backup_retention_days

# 设置日志记录
logging.basicConfig(filename='backup_restore.log', level=logging.ERROR)

def compress_backup_files():
    try:
        with tarfile.open('backup_archive.tar.gz', 'w:gz') as tar:
            tar.add(backup_dir)
        logging.info("Backup files compressed successfully")
    except Exception as e:
        logging.error(f"Error occurred during backup compression: {e}")

def clean_old_backups():
    try:
        for filename in os.listdir(backup_dir):
            filepath = os.path.join(backup_dir, filename)
            if os.path.isfile(filepath):
                file_age = time.time() - os.path.getctime(filepath)
                if file_age > backup_retention_days * 24 * 3600:
                    os.remove(filepath)
                    logging.info(f"Old backup file '{filename}' deleted")
    except Exception as e:
        logging.error(f"Error occurred during backup cleanup: {e}")
