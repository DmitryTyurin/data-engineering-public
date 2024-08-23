--Для каждого фильма из категории Horror с рейтингом PG-13 найдите первого клиента, который взял этот фильм напрокат.
--Результатом должна быть таблица с двумя столбцами title и first_customer — имя и фамилия клиента, разделенные пробелом, упорядоченная по названию фильма.

with 
    film_customer_wt as
        (
        select f.title, 
            c.name as category_film, 
            r.rental_date, 
            first_value(concat(cus.first_name, ' ', cus.last_name)) over(partition by f.title order by r.rental_date) as first_customer
        from film f
        join film_category fc on fc.film_id = f.film_id
        join category c on c.category_id = fc.category_id
        join inventory i on i.film_id = f.film_id
        join rental r on r.inventory_id = i.inventory_id
        join customer cus on cus.customer_id = r.customer_id
        where c.name = 'Horror' and f.rating = 'PG-13'
        )

select distinct(title), first_customer
from film_customer_wt


--Составьте рейтинг сотрудников в зависимости от их зарплаты так чтобы на первом месте был сотрудник с максимальной зарплатой.
--Выведите результирующую таблицу из трёх колонок FULL_NAME, SALARY и RANK.
--Отсортируйте результат по убыванию рейтинга

select FULL_NAME, SALARY, rank() over(order by  SALARY desc) as RANK
from EMPLOYEE


--Найдите сотрудников имеющих максимальную зарплату в своём подразделении.
--Выведите таблицу с колонками DEPARTMENT - название подразделения, EMP_NO, FIRST_NAME, LAST_NAME - данные сотрудника, SALARY - его зарплата. Отсортируйте данные по убыванию зарплаты.

with salary_employee as
    (
    select  d.DEPARTMENT,  
        e.EMP_NO, 
        e.FIRST_NAME, 
        e.LAST_NAME, 
        e.SALARY,
        dense_rank() over(partition by d.DEPARTMENT order by e.SALARY desc) as RANK
    from  EMPLOYEE e
    left join DEPARTMENT d on e.DEPT_NO = d.DEPT_NO
    )

select DEPARTMENT, EMP_NO, FIRST_NAME, LAST_NAME, SALARY
from salary_employee
where RANK = 1
order by SALARY desc


--Из таблицы payments выберите все платежи за август 2005 г. Выведите результат в четырех столбцах: payment_id, payment_date, amount, rolling_sum - сумма платежей с начала месяца с нарастающим итогом.

SELECT
    p.payment_id,
    p.payment_date,
    p.amount,
    SUM(p.amount) OVER (ORDER BY p.payment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_sum
FROM
    payment p
WHERE
    EXTRACT(MONTH FROM p.payment_date) = 8 AND
    EXTRACT(YEAR FROM p.payment_date) = 2005;

