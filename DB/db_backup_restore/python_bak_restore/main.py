# main.py

import threading
import time
import os
import logging
from DB.python_backup_restore.python_bak_restore.config import databases, num_threads
from DB.python_backup_restore.python_bak_restore.backup import backup_mysql, backup_oracle, backup_mongodb
from DB.python_backup_restore.python_bak_restore.restore import restore_mysql, restore_oracle, restore_mongodb
from DB.python_backup_restore.python_bak_restore.utils import compress_backup_files, clean_old_backups

def backup_all_databases():
    threads = []
    for i in range(num_threads):
        for db in databases:
            thread = threading.Thread(target=backup_database, args=(db,))
            threads.append(thread)
            thread.start()
    
    for thread in threads:
        thread.join()

def backup_database(db):
    db_type = db['type']
    config = db['config']
    backup_type = db['backup_type']

    if db_type == 'mysql':
        backup_mysql(**config, backup_type=backup_type)
    elif db_type == 'oracle':
        backup_oracle(**config, backup_type=backup_type)
    elif db_type == 'mongodb':
        backup_mongodb(**config, backup_type=backup_type)

def restore_all_databases():
    for db in databases:
        db_type = db['type']
        config = db['config']
        backup_file = db.get('backup_file', None)

        if backup_file:
            if db_type == 'mysql':
                restore_mysql(**config, backup_file=backup_file)
            elif db_type == 'oracle':
                restore_oracle(**config, backup_file=backup_file)
            elif db_type == 'mongodb':
                restore_mongodb(**config, backup_dir=backup_file)

def main():
    # 备份所有数据库
    backup_all_databases()

    # 压缩备份文件
    compress_backup_files()

    # 清理旧备份文件
    clean_old_backups()
    
    # 还原所有数据库
    restore_all_databases()

if __name__ == "__main__":
    main()
