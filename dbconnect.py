import psycopg2
import psycopg2.extras

'''Connection mit DBMS PostgreSQL'''

def get_connection():
    return psycopg2.connect(
        dbname="zahnrad_db",      # 你的数据库名
        user="admin",             # 数据库用户名
        password="admin",         # 数据库密码
        host="127.0.0.1",         # 数据库地址（本地）
        port="5432"               # 端口号（默认 PostgreSQL）
    )