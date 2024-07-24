import pandas as pd
import clickhouse_connect
import time
import shutil

from airflow_dag_for_cism.module.config import (
    CLICKHOUSE_HOST,
    CLICKHOUSE_PORT,
    CLICKHOUSE_DATABASE,
    CLICKHOUSE_USER,
    CLICKHOUSE_PASSWORD,
)


def get_clickhouse_connection(hook_name: str):
    read_connection = {
        "default": {
            "host": CLICKHOUSE_HOST,
            "port": CLICKHOUSE_PORT,
            "database": CLICKHOUSE_DATABASE,
            "user": CLICKHOUSE_USER,
            "password": CLICKHOUSE_PASSWORD,
        },
    }

    try:
        read_connection_info = read_connection[hook_name]
        client = clickhouse_connect.get_client(**read_connection_info)

        print(f"Подключение к БД: {client}")

    except Exception as e:
        print(f"Error: Не удалось получить соединение с ClickHouse. \n {e}")

    return client


def load_dataset(client, table_name: str, dataframe: pd.DataFrame):
    print(f"ЗАГРУЖАЕМ ДАННЫЕ В CLICKHOUSE:")
    start_time = time.time()

    # Загрузка данных в ClickHouse
    client.insert_df(table=table_name, df=dataframe)
    print(f"Загружено {dataframe.shape[0]} строк данных в ClickHouse.")

    end_time = time.time()
    execution_time = end_time - start_time
    print(f"Время загрузки данных в ClickHouse: {execution_time} сек.")


def delete_folder(path):
    try:
        shutil.rmtree(path)
    except Exception as e:
        print(f"Error: Не удалось удалить папку с данными. \n {path}. {e}")
