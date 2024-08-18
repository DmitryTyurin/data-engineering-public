--Напишите запрос возвращающий таблицу значений факториала для целых чисел от 0 до 10.
--Таблица должна содержать две колонки n - число от 0 до 10 и f значение факториала этого числа

WITH RECURSIVE factorials AS (
    SELECT 0 AS n, 1 AS f
    UNION ALL
    SELECT n + 1, (n + 1) * f FROM factorials WHERE n < 10
)
SELECT * FROM factorials;