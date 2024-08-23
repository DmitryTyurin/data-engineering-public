--Известен почтовый адрес пользователя (email = 'mgoyette@example.org'). Нужно показать его ФИО и дату рождения.
--К выборке добавьте язык приложения пользователя. Необходимое поле app_language в таблице user_settings.

select u.firstname,
    u.lastname,
    u.birthday,
    us.app_language
from users u
    left join user_settings us on us.user_id = u.id
where u.email = 'mgoyette@example.org';


--В предыдущей задаче поменялись (к счастью) входные данные. Теперь известен идентификатор пользователя вместо email.
--Получите ту же выборку, что и в предыдущем задании, зная, что id пользователя = 10.

select u.firstname,
    u.lastname,
    u.birthday,
    us.app_language
from users u
    left join user_settings us on us.user_id = u.id
where u.id = 10


--Выведите ФИО всех пользователей, у кого приложение на русском языке.
--Выведите поля firstname и lastname таблицы users, но только для тех пользователей, у кого в поле app_language таблицы user_settings установлено значение 'russian'.
--Дополнительно отсортируйте результаты по фамилии.

select u.firstname, u.lastname
from users u
    left join user_settings us on us.user_id = u.id
where us.app_language in ('russian')
order by lastname


--Выведите все истории (таблица stories) пользователя номер 2 и отсортируйте результат по количеству просмотров (поле views_count) по убыванию.
--К выборке необходимо добавить фамилию и имя пользователя из таблицы users.

select s.user_id,
    s.views_count,
    s.created_at,
    u.firstname,
    u.lastname
from stories s
     left join users u on u.id = s.user_id
where s.user_id = 2
order by s.views_count desc;


--Узнайте: сколько лайков собрала каждая история пользователя номер 2. Информацию можно взять из таблицы stories_likes.
--Результат отсортируйте по убыванию количества лайков.

select s.id, count(sl.user_id) as likes_count
from stories_likes sl
    left join stories s on sl.story_id = s.id
where s.user_id = 2
group by s.id
order by likes_count desc;


--Необходимо вывести все текстовые сообщения в группе номер 11 в хронологическом порядке.
--Напишите запрос, который возвращает из таблицы group_messages все строки, у которых тип сообщения (поле media_type) является текстом (значение text) и которые относятся к группе (поле group_id) номер 11.

select
    gm.id,
    u.firstname as firstname,
    u.lastname as lastname,
    SUBSTRING(gm.body, 1, 30) as body,
    gm.created_at
from group_messages gm
    left join users u ON gm.sender_id = u.id
where gm.media_type = 'text'
    and gm.group_id = 11
order by gm.created_at;
