import subprocess
import os
import logging
from DB.python_backup_restore.python_bak_restore.config import backup_dir

# 设置日志记录
logging.basicConfig(filename='backup_restore.log', level=logging.ERROR)

def backup_mysql(host, username, password, database, backup_type):
    try:
        # 使用安全的参数传递方式
        cmd = ['mysqldump', '-h', host, '-u', username, '-p' + password, database]
        if backup_type == 'full':
            cmd.extend(['--result-file', os.path.join(backup_dir, f'{database}_backup.sql')])
        elif backup_type == 'incremental':
            cmd.extend(['--result-file', os.path.join(backup_dir, f'{database}_incremental_backup.sql'), '--where="timestamp_column > last_backup_timestamp"'])
        else:
            logging.error("Unsupported backup type for MySQL")
            return
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred during MySQL backup: {e}")

def backup_oracle(username, password, sid, backup_type):
    try:
        # 使用安全的参数传递方式
        cmd = ['exp', username + '/' + password + '@' + sid]
        if backup_type == 'full':
            cmd.extend(['file=' + os.path.join(backup_dir, f'{sid}_backup.dmp'), 'full=y'])
        elif backup_type == 'incremental':
            logging.error("Incremental backup not supported for Oracle")
            return
        else:
            logging.error("Unsupported backup type for Oracle")
            return
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred during Oracle backup: {e}")

def backup_mongodb(host, port, username, password, database, backup_type):
    try:
        # 使用安全的参数传递方式
        cmd = ['mongodump', '--host', host, '--port', str(port), '--username', username, '--password', password, '--db', database]
        if backup_type == 'full':
            cmd.extend(['--out', os.path.join(backup_dir, f'{database}_backup')])
        elif backup_type == 'incremental':
            logging.error("Incremental backup not supported for MongoDB")
            return
        else:
            logging.error("Unsupported backup type for MongoDB")
            return
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred during MongoDB backup: {e}")
