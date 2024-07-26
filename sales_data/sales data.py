from sales_data.module import (
    read_sales_data,
    total_sales_per_product,
    sales_over_time,
    max_total_sales,
    plt_sales_data,
)

PATH = "sales_data.csv"

sales_data = read_sales_data(PATH)

total_sales_per_product = total_sales_per_product(sales_data)
sales_over_time = sales_over_time(sales_data)

max_product = max_total_sales(total_sales_per_product)
max_date = max_total_sales(sales_over_time)

print(f"Наибольшая выручка у продукта: {max_product}")
print(f"Наибольшая сумма продаж: {max_date}")

plt_sales_data(total_sales_per_product, "Общая сумма продаж по каждому продукту")
plt_sales_data(sales_over_time, "Общая сумма продаж по дням")
