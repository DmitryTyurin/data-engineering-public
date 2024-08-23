--Задание 1. Вывести имена всех людей, которые есть в базе данных авиакомпаний
SELECT name
FROM passenger


--Задание 2. Вывести названия всеx авиакомпаний

SELECT name
FROM Company


--Задание 3. Вывести все рейсы, совершенные из Москвы

SELECT *
FROM trip
WHERE town_from = 'Moscow'


--Задание 4. Вывести имена людей, которые заканчиваются на "man"

SELECT name
FROM passenger
WHERE name LIKE '%man'


--Задание 5. Вывести количество рейсов, совершенных на TU-134

SELECT COUNT(*) AS count
FROM trip
WHERE plane = 'TU-134'


--Задание 6. Какие компании совершали перелеты на Boeing

SELECT DISTINCT cp.name
FROM company cp
         JOIN trip tr ON cp.id = tr.company
WHERE plane = 'Boeing'


--Задание 7. Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)

SELECT DISTINCT plane
FROM trip
WHERE town_to = 'Moscow'


--Задание 8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?

SELECT town_to,
       TIMEDIFF(time_in, time_out) AS flight_time
FROM trip
WHERE town_from = 'Paris'


--Задание 9. Какие компании организуют перелеты из Владивостока (Vladivostok

SELECT name
FROM trip tr
         JOIN company cp ON tr.company = cp.id
WHERE town_from = 'Vladivostok'


--Задание 10. Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.

SELECT *
FROM trip
WHERE DATE(time_out) = '1900-01-01'
  AND TIME_FORMAT(time_out, '%H:%i') >= '10:00'
  AND TIME_FORMAT(time_out, '%H:%i') <= '14:00'


--Задание 11. Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.

select name
from passenger
ORDER by LENGTH(name) desc
LIMIT 2


--Задание 12. Вывести id и количество пассажиров для всех прошедших полётов

SELECT trip,
	COUNT(passenger) as count
FROM Pass_in_trip
group by trip


--Задание 13. Вывести имена людей, у которых есть полный тёзка среди пассажиров

SELECT name
FROM passenger
GROUP BY name
HAVING COUNT(*) > 1;


--Задание 14. В какие города летал Bruce Willis

SELECT town_to
FROM passenger ps
         JOIN Pass_in_trip pt ON ps.id = pt.passenger
         JOIN trip tr ON tr.id = pt.trip
WHERE name = 'Bruce Willis';


--Задание 15. Выведите дату и время прилёта пассажира Стив Мартин (Steve Martin) в Лондон (London)

SELECT time_in
FROM trip tr
         JOIN Pass_in_trip pt ON tr.id = pt.trip
         JOIN passenger ps ON pt.passenger = ps.id
WHERE name = 'Steve Martin'
  AND town_to = 'London';


--Задание 16. Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров,
--совершивших хотя бы 1 полет.

SELECT name,
       COUNT(name) AS count
FROM passenger ps
         JOIN Pass_in_trip pt ON ps.id = pt.passenger
         JOIN trip tr ON pt.trip = tr.id
GROUP BY name
ORDER BY count DESC,
         name ASC;


--Задание 17. Определить, сколько потратил в 2005 году каждый из членов семьи. В результирующей выборке не выводите тех членов
--семьи, которые ничего не потратили.

SELECT member_name,
       status,
       SUM(unit_price * amount) AS costs
FROM FamilyMembers fm
         JOIN Payments ps ON fm.member_id = ps.family_member
WHERE YEAR(DATE) = 2005
GROUP BY member_name,
         status;


--Задание 18. Узнать, кто старше всех в семьe

SELECT member_name
FROM FamilyMembers
ORDER BY birthday ASC
LIMIT 1;


--Задание 19. Определить, кто из членов семьи покупал картошку (potato)

SELECT status
FROM FamilyMembers fm
         JOIN Payments ps ON fm.member_id = ps.family_member
         JOIN Goods gs ON ps.good = gs.good_id
WHERE good_name = 'potato'
GROUP BY status;


--Задание 20. Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму

SELECT status,
       member_name,
       (amount * unit_price) AS costs
FROM FamilyMembers fm
         JOIN Payments ps ON fm.member_id = ps.family_member
         JOIN Goods gs ON ps.good = gs.good_id
         JOIN GoodTypes gt ON gs.type = gt.good_type_id
WHERE good_type_name = 'entertainment';


--Задание 21. Определить товары, которые покупали более 1 раза

SELECT good_name
FROM Goods gs
         JOIN Payments ps ON gs.good_id = ps.good
GROUP BY good
HAVING COUNT(*) > 1;


--Задание 22. Найти имена всех матерей (mother)

SELECT member_name
FROM FamilyMembers
WHERE status = 'mother';


--Задание 23. Найдите самый дорогой деликатес (delicacies) и выведите его цену

SELECT good_name,
       unit_price
FROM Goods gs
         JOIN GoodTypes gt ON gs.type = gt.good_type_id
         JOIN Payments ps ON gs.good_id = ps.good
WHERE good_type_name = 'delicacies'
ORDER BY unit_price DESC
LIMIT 1;


--Задание 24. Определить кто и сколько потратил в июне 2005

SELECT member_name,
       (amount * unit_price) AS costs
FROM FamilyMembers fm
         JOIN Payments ps ON fm.member_id = ps.family_member
WHERE YEAR(date) = 2005
  AND MONTH(date) = 6;


--Задание 25. Определить, какие товары не покупались в 2005 году

SELECT good_name
FROM Goods
WHERE good_id NOT IN (
    SELECT good
    FROM Payments
    WHERE YEAR(date) = 2005
);


--Задание 26. Определить группы товаров, которые не приобретались в 2005 году

SELECT good_type_name
FROM GoodTypes
WHERE good_type_id NOT IN (
    SELECT type
    FROM Goods gs
             JOIN Payments ps ON gs.good_id = ps.good
    WHERE YEAR(date) = 2005
    GROUP BY good_id
);


--Задание 27. Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму

SELECT good_type_name,
       SUM(amount * unit_price) AS costs
FROM GoodTypes gt
         JOIN Goods gs ON gt.good_type_id = gs.type
         JOIN Payments ps ON gs.good_id = ps.good
WHERE YEAR(date) = 2005
GROUP BY good_type_name;


--Задание 28. Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow)

SELECT COUNT(*) AS COUNT
FROM Trip
WHERE town_from = 'Rostov'
  AND town_to = 'Moscow';


--Задание 29. Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134

SELECT name
FROM Passenger ps
         JOIN Pass_in_trip pt ON ps.id = pt.passenger
         JOIN Trip tr ON pt.trip = tr.id
WHERE plane = 'TU-134'
  AND town_to = 'Moscow'
GROUP BY name;


--Задание 30. Выведите нагруженность (число пассажиров) каждого рейса (trip). Результат вывести в отсортированном виде по убыванию
--нагруженности.

SELECT trip,
       COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip
ORDER BY count DESC;


--Задание 31. Вывести всех членов семьи с фамилией Quincey

SELECT *
FROM FamilyMembers
WHERE member_name LIKE '% Quincey';


--Задание 32. Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.

SELECT FLOOR(
               AVG(TIMESTAMPDIFF(YEAR, birthday, CURRENT_TIMESTAMP))
           ) AS age
FROM FamilyMembers;


--Задание 33. Найдите среднюю стоимость икры. В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black
--caviar)

SELECT AVG(unit_price) AS cost
FROM Payments ps
         JOIN Goods gs ON ps.good = gs.good_id
WHERE good_name = 'red caviar'
   OR good_name = 'black caviar';


--Задание 34. Сколько всего 10-ых классов

SELECT COUNT(name) AS count
FROM Class
WHERE name LIKE '10 %';


--Задание 35. Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях ?

SELECT COUNT(DISTINCT classroom) AS count
FROM Student_in_class sc
         JOIN Class cl ON sc.class = cl.id
         JOIN Schedule sh ON sh.class = cl.id
WHERE DATE_FORMAT(date, '%e.%m.%Y') = '2.09.2019';


--Задание 36. Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?

SELECT *
FROM Student
WHERE address RLIKE 'Pushkina';


--Задание 37. Сколько лет самому молодому обучающемуся ?

SELECT TIMESTAMPDIFF(YEAR, birthday, CURRENT_TIMESTAMP) AS year
FROM Student
ORDER BY year ASC
LIMIT 1;


--Задание 38. Сколько Анн (Anna) учится в школе ?

SELECT COUNT(*) AS count
FROM Student
WHERE first_name = 'Anna';


--Задание 39. Сколько обучающихся в 10 B классе ?

SELECT COUNT(*) AS count
FROM Student_in_class sc
         JOIN Class cl ON sc.class = cl.id
WHERE name = '10 B';


--Задание 40. Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.) ?

SELECT name AS subjects
FROM Subject sj
         JOIN Schedule sc ON sj.id = sc.subject
         JOIN Teacher tc ON tc.id = sc.teacher
WHERE last_name = 'Romashkin'
  AND first_name LIKE 'P%'
  AND middle_name LIKE 'P%';


--Задание 41. Во сколько начинается 4-ый учебный предмет по расписанию ?

SELECT start_pair
FROM Timepair
WHERE id = 4;


--Задание 42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет?

SELECT TIMEDIFF(MAX(end_pair), MIN(start_pair)) AS time
FROM Timepair
WHERE id BETWEEN 2 AND 4;


--Задание 43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отсортируйте преподавателей
--по фамилии в алфавитном порядке.

SELECT last_name
FROM Teacher tc
         JOIN Schedule sc ON tc.id = sc.teacher
         JOIN Subject sj ON sj.id = sc.subject
WHERE name = 'Physical Culture'
ORDER BY last_name;


--Задание 44. Найдите максимальный возраст (колич. лет) среди обучающихся 10 классов

SELECT TIMESTAMPDIFF(YEAR, birthday, CURRENT_TIMESTAMP) AS max_year
FROM Student st
         JOIN Student_in_class sc ON sc.student = st.id
         JOIN Class cl ON cl.id = sc.class
WHERE name LIKE '10 %'
ORDER BY max_year DESC
LIMIT 1;


--Задание 45. Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались максимальное
--количество раз.

SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING count(classroom) = (
    SELECT COUNT(*) AS count
    FROM Schedule
    GROUP BY classroom
    ORDER BY count DESC
    LIMIT 1
);


--Задание 46. В каких классах введет занятия преподаватель "Krauze"

SELECT name
FROM Schedule sc
         JOIN Teacher tc ON tc.id = sc.teacher
         JOIN Class cl ON cl.id = sc.class
WHERE last_name = 'Krauze'
GROUP BY name;


--Задание 47. Сколько занятий провел Krauze 30 августа 2019 г.?

SELECT COUNT(*) AS count
FROM Schedule sc
         JOIN Teacher tc ON tc.id = sc.teacher
WHERE DATE_FORMAT(date, '%e %M %Y') = '30 August 2019'
  AND last_name = 'Krauze';


--Задание 48. Выведите заполненность классов в порядке убывания

SELECT name,
       COUNT(student) AS count
FROM Class cl
         JOIN Student_in_class sc ON sc.class = cl.id
GROUP BY name
ORDER BY count DESC;


--Задание 49. Какой процент обучающихся учится в "10 A" классе? Выведите ответ в диапазоне от 0 до 100 без округления, например,
--96.0201

SELECT COUNT(*) * 100 / (
    SELECT COUNT(*)
    FROM Student_in_class
) AS percent
FROM Student_in_class sc
         JOIN Class cs ON cs.id = sc.class
WHERE name = '10 A';


--Задание 50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.

SELECT FLOOR(
                       COUNT(*) * 100 / (
                   SELECT COUNT(*)
                   FROM Student_in_class
               )
           ) AS percent
FROM Student_in_class sc
         JOIN Student st ON st.id = sc.student
WHERE YEAR(birthday) = 2000;


--Задание 51. Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods).

INSERT INTO Goods
SET good_id   = (
    SELECT COUNT(*) + 1
    FROM Goods AS gs
),
    good_name = 'Cheese',
    type      = (
        SELECT good_type_id
        FROM GoodTypes
        WHERE good_type_name = 'food'
    );


--Задание 52. Добавьте в список типов товаров (GoodTypes) новый тип "auto".

INSERT INTO GoodTypes
SET good_type_id   = (
    SELECT COUNT(*) + 1
    FROM GoodTypes AS gt
),
    good_type_name = 'auto';


--Задание 53. Измените имя "Andie Quincey" на новое "Andie Anthony".

UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_name = 'Andie Quincey';


--Задание 54. Удалить всех членов семьи с фамилией "Quincey".

DELETE
FROM FamilyMembers
WHERE member_name LIKE '% Quincey';


--Задание 55. Удалить компании, совершившие наименьшее количество рейсов.

DELETE
FROM company
WHERE id IN (
    SELECT company
    FROM trip
    GROUP BY company
    HAVING COUNT(*) = (
        SELECT COUNT(*) AS count
        FROM trip
        GROUP BY company
        ORDER BY count
        LIMIT 1
    )
);


--Задание 56. Удалить все перелеты, совершенные из Москвы (Moscow).

DELETE
FROM trip
WHERE town_from = 'Moscow';


--Задание 57. Перенести расписание всех занятий на 30 мин. вперед.

UPDATE Timepair
SET start_pair = ADDTIME(start_pair, '00:30:00'),
    end_pair   = ADDTIME(end_pair, '00:30:00');


--Задание 58. Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218, Friel Place, New York", от имени "George
--Clooney"

INSERT INTO Reviews
SET id             = (
    SELECT COUNT(*) + 1
    FROM Reviews rw
),
    reservation_id = (
        SELECT rs.id
        FROM Reservations rs
                 JOIN Rooms rm ON rm.id = rs.room_id
                 JOIN Users us ON rs.user_id = us.id
        WHERE address = '11218, Friel Place, New York'
          AND name = 'George Clooney'
    ),
    rating         = 5;


--Задание 59. Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375.

SELECT *
FROM Users
WHERE phone_number LIKE '+375 %';


--Задание 60. Выведите идентификаторы преподавателей, которые хотя бы один раз за всё время преподавали в каждом из одиннадцатых
--классов.

SELECT teacher
FROM Schedule sc
         JOIN Class cl ON sc.class = cl.id
WHERE name LIKE '11 %'
GROUP BY teacher
HAVING COUNT(DISTINCT name) = 2;


--Задание 61. Выведите список комнат, которые были зарезервированы хотя бы на одни сутки в 12-ую неделю 2020 года. В данной задаче
--в качестве одной недели примите период из семи дней, первый из которых начинается 1 января 2020 года. Например, первая
--неделя года — 1–7 января, а третья — 15–21 января.

SELECT Rooms.*
FROM Reservations
         JOIN Rooms ON Rooms.id = Reservations.room_id
WHERE WEEK(start_date, 1) = 12
  AND YEAR(start_date) = 2020;


--Задание 62. Вывести в порядке убывания популярности доменные имена 2-го уровня, используемые пользователями для электронной
--почты. Полученный результат необходимо дополнительно отсортировать по возрастанию названий доменных имён.

SELECT SUBSTRING_INDEX(email, '@', -1)        AS domain,
       COUNT(substring_index(email, '@', -1)) AS count
FROM Users
GROUP BY domain
ORDER BY count DESC,
         domain;


--Задание 63. Выведите отсортированный список (по возрастанию) фамилий и имен студентов в виде Фамилия.И.

SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.') AS name
FROM Student
ORDER BY name;


--Задание 64. Вывести количество бронирований по каждому месяцу каждого года, в которых было хотя бы 1 бронирование. Результат
--отсортируйте в порядке возрастания даты бронирования.

SELECT YEAR(start_date)  AS year,
       MONTH(start_date) AS month,
       COUNT(*)          AS amount
FROM Reservations
GROUP BY YEAR(start_date),
         MONTH(start_date)
ORDER BY year,
         month;


--Задание 65. Необходимо вывести рейтинг для комнат, которые хоть раз арендовали, как среднее значение рейтинга отзывов
--округленное до целого вниз.

SELECT room_id,
       FLOOR(AVG(rating)) AS rating
FROM Reservations rs
         JOIN Reviews rw ON rw.reservation_id = rs.id
GROUP BY room_id;


--Задание 66. Вывести список комнат со всеми удобствами (наличие ТВ, интернета, кухни и кондиционера), а также общее количество
--дней и сумму за все дни аренды каждой из таких комнат.

SELECT home_type,
       address,
       IFNULL(SUM(total / rs.price), 0) AS days,
       IFNULL(SUM(total), 0)            AS total_fee
FROM Rooms rm
         LEFT JOIN Reservations rs ON rs.room_id = rm.id
WHERE has_tv = 1
  AND has_internet = 1
  AND has_kitchen = 1
  AND has_air_con = 1
GROUP BY home_type,
         address;


--Задание 67. Вывести время отлета и время прилета для каждого перелета в формате "ЧЧ:ММ, ДД.ММ - ЧЧ:ММ, ДД.ММ", где часы и минуты
--с ведущим нулем, а день и месяц без.

SELECT CONCAT(
               DATE_FORMAT(time_out, '%H:%i, %e.%c'),
               ' - ',
               DATE_FORMAT(time_in, '%H:%i, %e.%c')
           ) AS flight_time
FROM Trip;


--Задание 68. Для каждой комнаты, которую снимали как минимум 1 раз, найдите имя человека, снимавшего ее последний раз, и дату,
--когда он выехал

SELECT rs.room_id,
       name,
       date AS end_date
FROM (
         SELECT room_id,
                MAX(end_date) AS date
         FROM Reservations
         GROUP BY room_id
     ) rs
         JOIN Reservations rsv ON rs.room_id = rsv.room_id
    AND rs.date = rsv.end_date
         JOIN Users us ON rsv.user_id = us.id;


--Задание 69. Вывести идентификаторы всех владельцев комнат, что размещены на сервисе бронирования жилья и сумму, которую они
--заработали


SELECT owner_id,
       IFNULL(SUM(total), 0) AS total_earn
FROM Rooms rm
         LEFT JOIN Reservations rs ON rm.id = rs.room_id
GROUP BY owner_id;


--Задание 70. Необходимо категоризовать жилье на economy, comfort, premium по цене соответственно <= 100,
--100 < цена < 200, >= 200. В качестве результата вывести таблицу с названием категории и количеством жилья, попадающего в
--данную категорию

SELECT CASE
           WHEN price <= 100 THEN 'economy'
           WHEN price > 100
               AND price < 200 THEN 'comfort'
           WHEN price >= 200 THEN 'premium'
           END      AS category,
       COUNT(price) AS count
FROM Rooms
GROUP BY category;


--Задание 71. Найдите какой процент пользователей, зарегистрированных на сервисе бронирования, хоть раз арендовали или сдавали в
--аренду жилье. Результат округлите до сотых.

SELECT ROUND(
                       (
                           SELECT COUNT(*)
                           FROM (
                                    SELECT DISTINCT owner_id
                                    FROM Rooms rm
                                             JOIN Reservations rs ON rm.id = rs.room_id
                                    UNION
                                    SELECT user_id
                                    FROM Reservations
                                ) active_users
                       ) * 100 / (
                           SELECT COUNT(*)
                           FROM Users
                       ),
                       2
           ) AS percent;


--Задание 72. Выведите среднюю стоимость бронирования для комнат, которых бронировали хотя бы один раз. Среднюю стоимость
--необходимо округлить до целого значения вверх.

SELECT room_id,
       CEILING(AVG(price)) AS avg_price
FROM Reservations
GROUP BY room_id;


--Задание 73. Выведите id тех комнат, которые арендовали нечетное количество раз

SELECT room_id,
       COUNT(*) AS count
FROM Reservations
GROUP BY room_id
HAVING count % 2 != 0;


--Задание 74. Выведите идентификатор и признак наличия интернета в помещении. Если интернет в сдаваемом жилье присутствует, то
--выведите «YES», иначе «NO».

SELECT id,
       IF(has_internet = 1, 'YES', 'NO') AS has_internet
FROM Rooms;


--Задание 75. Выведите фамилию, имя и дату рождения студентов, кто был рожден в мае.

SELECT last_name,
       first_name,
       birthday
FROM Student
WHERE MONTHNAME(birthday) = 'May'


--Задание 76. Вывести имена всех пользователей сервиса бронирования жилья, а также два признака: является ли пользователь
--собственником какого-либо жилья (is_owner) и является ли пользователь арендатором (is_tenant). В случае наличия у
--пользователя признака необходимо вывести в соответствующее поле 1, иначе 0.

SELECT name,
       IF(
                   id IN (
                   SELECT owner_id
                   FROM Rooms
               ),
                   1,
                   0
           ) AS is_owner,
       IF(
                   id IN (
                   SELECT user_id
                   FROM Reservations
               ),
                   1,
                   0
           ) AS is_tenant
FROM Users


--Задание 77. Создайте представление с именем "People", которое будет содержать список имен (first_name) и фамилий (last_name)
--всех студентов (Student) и преподавателей(Teacher)

CREATE VIEW People AS
SELECT first_name,
       last_name
FROM Student
UNION
SELECT first_name,
       last_name
FROM Teacher


--Задание 78. Выведите всех пользователей с электронной почтой в «hotmail.com»

SELECT *
FROM Users
WHERE email RLIKE '@hotmail.com'


--Задание 79. Выведите поля id, home_type, price у всех комнат из таблицы Rooms. Если комната имеет телевизор и интернет
--одновременно, то в качестве цены в поле price выведите цену, применив скидку 10%

SELECT id,
       home_type,
       IF(has_tv AND has_internet, price * 0.9, price) AS price
FROM Rooms


--Задание 80. Создайте представление «Verified_Users» с полями id, name и email, которое будет показывает только тех
--пользователей, у которых подтвержден адрес электронной почты.

CREATE VIEW Verified_Users AS
SELECT id, name, email
FROM Users
WHERE email_verified_at IS NOT NULL


--Задание 93. Какой средний возраст клиентов, купивших Smartwatch (использовать наименование товара product.name) в 2024 году?

SELECT AVG(c.age) as average_age
FROM customer c
WHERE EXISTS (SELECT 1
              FROM Product b
              JOIN Purchase p on b.product_key = p.product_key
              WHERE b.name='Smartwatch' AND YEAR(date) = 2024  AND p.customer_key = c.customer_key) 

SELECT AVG(c.age) as average_age
FROM customer c
WHERE c.customer_key IN (SELECT DISTINCT p.customer_key
                     FROM Product b
                     JOIN Purchase p on b.product_key = p.product_key
                      WHERE b.name='Smartwatch' 
                      AND YEAR(date) = 2024) 


--Задание 94. Вывести имена покупателей, каждый из которых приобрёл Laptop и Monitor (использовать наименование товара product.name) в марте 2024 года?

SELECT name
FROM Customer 
WHERE customer_key in (              
        SELECT customer_key
        FROM ( SELECT DISTINCT customer_key,product_key
                    FROM Product 
                    JOIN Purchase USING (product_key) 
                	WHERE YEAR(date) = 2024 AND MONTH(date) = 3
                    AND (name = 'Laptop' or name = 'Monitor')) t
        GROUP BY customer_key
        HAVING COUNT(product_key) > 1)


--Задание 97. Посчитать количество работающих складов на текущую дату по каждому городу. Вывести только те города, у которых количество складов более 80.
--Данные на выходе - город, количество складов.

SELECT city,
	COUNT(warehouse_id) as warehouse_count
FROM Warehouses
where date_close is null
group by city
HAVING warehouse_count > 80


--Задание 99. Посчитай доход с женской аудитории (доход = сумма(price * items)). Обратите внимание, что в таблице женская аудитория имеет поле user_gender «female» или «f».

SELECT SUM(items * price) as income_from_female
FROM Purchases
WHERE user_gender in ('female', 'f')


--Задание 101. Выведи для каждого пользователя первое наименование, которое он заказал (первое по времени транзакции).

SELECT user_id,
	    item
from Transactions
where transaction_ts in (
		SELECT MIN(transaction_ts)
		FROM Transactions
		GROUP BY user_id
	)


