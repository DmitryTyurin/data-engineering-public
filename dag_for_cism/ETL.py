import pandas as pd
import numpy as np
import glob
from airflow_dag_for_cism.module.config import (
    URL_DATASET,
    PATH,
    PATH_TO_FILE,
    FILE_NAME,
    CHUNK_SIZE,
    MCC_LIST,
    CLICKHOUSE_TABLE,
)
from airflow_dag_for_cism.module.extract import get_dataset_from_url
from airflow_dag_for_cism.module.transform import transform_dataset
from airflow_dag_for_cism.module.load import (
    get_clickhouse_connection,
    load_dataset,
    delete_folder,
)


from airflow.decorators import dag, task


@task()
def ETL():
    get_dataset_from_url(URL_DATASET, PATH, PATH_TO_FILE, FILE_NAME, CHUNK_SIZE)

    client = get_clickhouse_connection("default")

    count = 0
    for file in glob.glob(f"{PATH_TO_FILE}/*{FILE_NAME}*.pkl"):
        count += 1
        try:
            print(f"Dataset {count}: {file}")

            raw_dataframe = pd.read_pickle(file)
            transform_dataframe = transform_dataset(raw_dataframe, "mcc", MCC_LIST)
            load_dataset(client, CLICKHOUSE_TABLE, transform_dataframe)

        except Exception as e:
            print(f"Error: Dataset {count} завершено с ошибкой {e}. \n {file}")

    delete_folder(PATH_TO_FILE)
