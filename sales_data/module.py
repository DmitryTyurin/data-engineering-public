import csv
import matplotlib.pyplot as plt


def read_sales_data(file_path: str) -> list:
    """
    Принимает путь к файлу и возвращает список продаж.
    Продажи в свою очередь являются словарями с ключами product_name, quantity, price, date
    (название, количество, цена, дата).
    """

    sales_data = []

    with open(
            file_path,
            mode="r",
            encoding="utf-8-sig",
    ) as file:
        fieldnames = ["product_name", "quantity", "price", "date"]
        reader = csv.DictReader(file, fieldnames=fieldnames)

        for row in reader:
            row = {
                key.replace(" ", ""): value.replace(" ", "")
                for key, value in row.items()
            }
            sales_data.append(row)

    print(sales_data)
    return sales_data


def total_sales_per_product(sales_data: list) -> dict:
    """
    Принимает список продаж и возвращает словарь,
    где ключ - название продукта, а значение - общая сумма продаж этого продукта.
    """

    total_sales = {}
    for sale in sales_data:
        product_name = sale["product_name"]
        price = float(sale["price"])
        quantity = int(sale["quantity"])
        if product_name in total_sales:
            total_sales[product_name] += price * quantity
        else:
            total_sales[product_name] = price * quantity

    print(total_sales)
    return total_sales


def sales_over_time(sales_data: list) -> dict:
    """
    Принимает список продаж и возвращает словарь,
    где ключ - дата, а значение общая сумма продаж за эту дату.
    """

    sales_over_time = {}
    for sale in sales_data:
        product_name = sale["date"]
        price = float(sale["price"])
        quantity = int(sale["quantity"])
        if product_name in sales_over_time:
            sales_over_time[product_name] += price * quantity
        else:
            sales_over_time[product_name] = price * quantity

    print(sales_over_time)
    return sales_over_time


def max_total_sales(total_sales: dict) -> str:
    max_total_sales = max(total_sales.values())
    max_sales = [k for k, v in total_sales.items() if v == max_total_sales]

    max_sales = ", ".join(max_sales)

    return max_sales


def plt_sales_data(total_sales: dict, title: str):
    """
    Принимает словарь, где ключ - название продукта, а значение - общая сумма продаж этого продукта.
    Функция рисует график продаж.
    """

    x = list(total_sales.keys())
    y = list(total_sales.values())

    plt.bar(x, y)

    plt.xlabel("")
    plt.ylabel("")

    plt.xticks(rotation=15)

    plt.title(title)
    plt.show()
