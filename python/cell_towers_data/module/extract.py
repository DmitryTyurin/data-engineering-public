import pandas as pd
import requests
import lzma
import os
import io
import time


def get_dataset_from_url(
    url: str, path: str, path_to_files: str, file_name: str, chunk_size: int
):
    print(f"ПОЛУЧЕНИЕ ДАННЫХ:")
    start_time = time.time()

    # Скачиваем файл в формате xz
    print(f"Скачиваем файл из {url}...")

    response = requests.get(url)

    if not response.ok:
        print(f"Ошибка при загрузке файла.")
        return None

    # Сохраняем файл
    print(f"Сохраняем {file_name} в {path}...")

    with open(f"{path}{file_name}.xz", "wb") as f:
        f.write(response.content)

    # Распаковываем файл
    print(f"Распаковываем {file_name} в {path}...")

    with lzma.open(f"{path}{file_name}.xz", "rb") as f_in:
        decompressed_data = f_in.read()

    if not os.path.exists(path_to_files):
        os.makedirs(path_to_files)
        print(f"Создана папка {path_to_files}...")

    # Чтение CSV-файла в DataFrame
    print(f"Чтение {file_name} в DataFrame...")

    with pd.read_csv(
        io.StringIO(decompressed_data.decode("utf-8")), chunksize=chunk_size
    ) as reader:

        for i, dataframe in enumerate(reader, start=1):
            print(f"dataset {i}:\n {dataframe.head(10)}")
            dataframe.to_pickle(f"{path_to_files}/{i}_{file_name}.pkl")

    # Удаляем файл .xz
    print(f"Удаляем файл {file_name} из {path}...")
    os.remove(f"{path}{file_name}.xz")

    end_time = time.time()
    execution_time = end_time - start_time
    print(f"Время получения данных: {execution_time} сек.\n")
