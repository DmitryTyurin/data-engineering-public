from airflow_dag_for_cism.ETL import ETL

from datetime import datetime, timedelta

from airflow.decorators import dag, task


@dag(
    dag_id=f"ETL_airflow_dag_for_cism",
    start_date=datetime(2024, 7, 19),
    schedule_interval="10 0 * * 1",
    catchup=False,
    tags=["clickhouse"],
    default_args={
        "retries": 2,
        "retry_delay": timedelta(minutes=5),
        "owner": "Dmitrii Tiurin",
    },
)
def taskflow():
    ETL()


taskflow()
