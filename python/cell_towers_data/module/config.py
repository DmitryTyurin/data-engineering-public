from airflow.models import Variable

# url dataset из открытого источника
URL_DATASET = "https://datasets.clickhouse.com/cell_towers.csv.xz"

# путь к файлу с данными
PATH = "/opt/clickhouse/cism/"

# название файла с данными
FILE_NAME = "cell_towers"

# путь к файлам с партиями данных в формате pkl
PATH_TO_FILE = f"{PATH}raw_data_{FILE_NAME}"

# размер партии данных
CHUNK_SIZE = 10**5

# соответствующий код для фильтрации данных
MCC_LIST = [262, 460, 310, 208, 510, 404, 250, 724, 234, 311]

CLICKHOUSE_HOST = Variable.get("clickhouse_host")  # IP-адрес сервера ClickHouse
CLICKHOUSE_PORT = Variable.get("clickhouse_port")  # порт сервера ClickHouse
CLICKHOUSE_DATABASE = "default"  # имя базы данных
CLICKHOUSE_USER = Variable.get("clickhouse_user")  # имя пользователя
CLICKHOUSE_PASSWORD = Variable.get("clickhouse_password")  # пароль пользователя
CLICKHOUSE_TABLE = "stage1_cell_towers"  # имя таблицы
