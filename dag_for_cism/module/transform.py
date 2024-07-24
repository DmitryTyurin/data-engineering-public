import pandas as pd
import time


def transform_date_column(dataframe: pd.DataFrame) -> pd.DataFrame:
    if "created" in dataframe.columns:
        dataframe["created"] = pd.to_datetime(dataframe["created"], errors="coerce")

    if "updated" in dataframe.columns:
        dataframe["updated"] = pd.to_datetime(dataframe["updated"], errors="coerce")

    print("Преобразования даты")

    return dataframe


def select_values_by_list(
    dataframe: pd.DataFrame, column: str, select_list: list
) -> pd.DataFrame:
    dataframe = dataframe.loc[dataframe[column].isin(select_list)]

    print(f"Выбранные значения в столбце {column} по списку {select_list}")

    return dataframe


def transform_dataset(
    dataframe: pd.DataFrame, column: str, select_list: list
) -> pd.DataFrame:
    print(f"ОБРАБОТКА ДАННЫХ:")
    start_time = time.time()

    before_transform = dataframe.shape[0]

    dataframe = transform_date_column(dataframe)
    dataframe = select_values_by_list(dataframe, column, select_list)

    after_transform = dataframe.shape[0]

    print(f"Получено {before_transform} строк на обработку.")
    print(f"Получено {after_transform} строк после обработки.")
    print(f"Скип {before_transform - after_transform} строк.")

    end_time = time.time()
    execution_time = end_time - start_time
    print(f"Время обработки данных: {execution_time} сек.\n")

    return dataframe
