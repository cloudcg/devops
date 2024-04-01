# 数据库配置
databases = [
    {
        'type': 'mysql',
        'config': {
            'host': 'localhost',
            'username': 'root',
            'password': 'password',
            'database': 'example_db'
        },
        'backup_type': 'full',  # 支持 'full' 或 'incremental'
        # 'backup_file': '/path/to/backup_file.sql'  # 还原时使用，可选
    },
    {
        'type': 'oracle',
        'config': {
            'username': 'system',
            'password': 'oracle',
            'sid': 'ORCL'
        },
        'backup_type': 'full',  # 支持 'full' 或 'incremental'
        # 'backup_file': '/path/to/backup_file.dmp'  # 还原时使用，可选
    },
    {
        'type': 'mongodb',
        'config': {
            'host': 'localhost',
            'port': 27017,
            'username': 'admin',
            'password': 'password',
            'database': 'example_db'
        },
        'backup_type': 'full',  # 支持 'full' 或 'incremental'
        # 'backup_file': '/path/to/backup_dir'  # 还原时使用，可选
    }
]

# 并发线程数
num_threads = 3

# 备份目录
backup_dir = '/path/to/backup_directory'

# 备份保留天数
backup_retention_days = 7
