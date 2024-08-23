--Известен почтовый адрес пользователя (email). Нужно показать его ФИО и дату рождения.
--Выведите из таблицы users строку, у которой email = 'mgoyette@example.org'.
--Отобразить нужно только следующие поля:
--фамилия
--имя
--дата рождения

select firstname, lastname, birthday
from users
where email = 'mgoyette@example.org'


--К предыдущей выборке добавьте язык приложения пользователя.
--Необходимое поле app_language в таблице user_settings.
--Задачу решите с помощью скоррелированного вложенного запроса.

select firstname,
    lastname,
    birthday,
    (SELECT app_language FROM user_settings WHERE user_id = users.id) AS app_language
from users
where email = 'mgoyette@example.org'


--В предыдущей задаче поменялись (к счастью) входные данные. Теперь известен идентификатор пользователя вместо email.
--Получите ту же выборку, что и в предыдущем задании, зная, что id пользователя = 10.
--Постарайтесь избежать корреляции во вложенном запросе.

select firstname,
    lastname,
    birthday,
    (SELECT app_language FROM user_settings WHERE user_id = 10) AS app_language
from users
 WHERE id = 10


--Выведите ФИО всех пользователей, у кого приложение на русском языке.
--Используйте вложенный запрос для фильтрации.
--Выведите поля firstname и lastname таблицы users, но только для тех пользователей, у кого в поле app_language таблицы user_settings установлено значение 'russian'. Дополнительно отсортируйте результаты по фамилии.

select firstname, lastname
from users
where id in
    (
        select user_id
        from user_settings
        where app_language = 'russian'
    )
order by lastname


--К предыдущей выборке необходимо добавить фамилию и имя пользователя
--Используя вложенные запросы, добавьте следующие поля (из таблицы users) к результатам выборки: firstname lastname

select id,
    views_count,
    created_at,
    (
        select firstname
        from users
        where id = 2
    ) as firstname,
    (
        select lastname
        from users
        where id = 2
    ) as lastname
from stories
where user_id = 2
order by views_count desc;


--Теперь к предыдущей выборке добавьте суммарное количество лайков, которое получила каждая история.
--Используя вложенный запрос, добавьте поле с подсчитанным количеством лайков у каждой истории. Информацию можно взять из таблицы stories_likes.

select id,
    views_count,
    created_at,
    (
        select firstname
        from users
        where id = 2
    ) as firstname,
    (
        select lastname
        from users
        where id = 2
    ) as lastname,
    (
        select count(user_id)
        from stories_likes
        where stories_likes.story_id = stories.id
    ) as count
from stories
where user_id = 2
order by views_count desc;


--Необходимо вывести все текстовые сообщения в группе номер 11 в хронологическом порядке.
--Напишите запрос, который возвращает из таблицы group_messages все строки, у которых тип сообщения (поле media_type) является текстом (значение text) и которые относятся к группе (поле group_id) номер 11.

SELECT
    id,
    sender_id,
    SUBSTRING(body, 1, 30) AS body,
    created_at
FROM
    group_messages
WHERE
    media_type = 'text'
    AND group_id = 11
ORDER BY created_at;

