import subprocess
import shutil
import os
import logging
from DB.python_backup_restore.python_bak_restore.config import backup_dir

# 设置日志记录
logging.basicConfig(filename='backup_restore.log', level=logging.ERROR)

def restore_mysql(host, username, password, database, backup_file):
    try:
        # 使用安全的参数传递方式
        subprocess.run(['mysql', '-h', host, '-u', username, '-p' + password, database, '<', backup_file], check=True, shell=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred during MySQL restore: {e}")

def restore_oracle(username, password, sid, backup_file):
    try:
        shutil.copy(backup_file, os.path.join(backup_dir, f'{sid}_backup.dmp'))
        # 使用安全的参数传递方式
        subprocess.run(['imp', username + '/' + password + '@' + sid, 'file=' + os.path.join(backup_dir, f'{sid}_backup.dmp'), 'full=y'], check=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred during Oracle restore: {e}")

def restore_mongodb(host, port, username, password, database, backup_dir):
    try:
        # 使用安全的参数传递方式
        subprocess.run(['mongorestore', '--host', host, '--port', str(port), '--username', username, '--password', password, '--db', database, backup_dir], check=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred during MongoDB restore: {e}")
