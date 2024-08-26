--Выведите пользователя (таблица users) номер 11 вместе со списком идентификаторов каналов (таблица channel_subscribers), на которые он подписан.
--Учитывайте также статус подписки (поле status = 'joined').
--Отсортируйте результат по номеру канала.

SELECT users.firstname, users.lastname, channel_subscribers.channel_id
FROM users
    JOIN channel_subscribers ON users.id = channel_subscribers.user_id
WHERE users.id = 11 AND  status = 'joined'
ORDER BY channel_subscribers.channel_id;


--Решите предыдущую задачу, используя именно CROSS JOIN объединение.
--Выведите пользователя (таблица users) номер 11 вместе со списком идентификаторов каналов (таблица channel_subscribers), на которые он подписан.
--Учитывайте также статус подписки (поле status = 'joined').
--Отсортируйте результат по номеру канала.

SELECT users.firstname, users.lastname, channel_subscribers.channel_id
FROM users
    CROSS JOIN channel_subscribers ON users.id = channel_subscribers.user_id
WHERE users.id = 11 AND  status = 'joined'
ORDER BY channel_subscribers.channel_id;


--Менеджеры попросили сделать выборку из предыдущей задачи более информативной.
--А именно: вместо идентификатора канала необходимо отображать его название (поле title таблицы channels).
--Отобразить необходимо только следующие поля: users.firstname users.lastname channels.title
--Для получения данных используйте объединение трех таблиц (JOIN): users, channel_subscribers, channels
--Учитывайте также статус подписки (поле status = 'joined').
--Отсортируйте результат по номеру канала.

SELECT users.firstname, users.lastname, channels.title
FROM users
    JOIN channel_subscribers ON users.id = channel_subscribers.user_id
    JOIN channels ON channel_subscribers.channel_id = channels.id
WHERE users.id = 11 AND  status = 'joined'
ORDER BY channel_subscribers.channel_id;


--\Выведите список пользователей, которые не подписались ни на какие каналы.
--Отобразить необходимо только следующие поля: firstname lastname email

SELECT users.firstname, users.lastname, users.email
FROM users
    LEFT JOIN channel_subscribers ON users.id = channel_subscribers.user_id
WHERE channel_subscribers.user_id IS NULL;


--Предыдущую задачу решите с помощью RIGHT OUTER JOIN объединения.
--Выведите список пользователей, которые не подписались ни на какие каналы.

SELECT users.firstname, users.lastname, users.email
FROM channel_subscribers
    RIGHT JOIN users ON users.id = channel_subscribers.user_id
WHERE channel_subscribers.user_id IS NULL;


--Получите список историй, которые не получили ни одного лайка.
--Вывести необходимо только идентификаторы (поле id) записей в таблице stories.

SELECT stories.id
FROM stories
    LEFT JOIN stories_likes ON stories.id = stories_likes.story_id
WHERE stories_likes.story_id IS NULL;


--В процессе миграции на новое железо возникла задача: проверить данные на отсутствие коллизий.
--Проверьте: есть ли в таблице stories_likes строки, ссылающиеся значением в поле story_id на несуществующие stories.

SELECT stories_likes.story_id
FROM stories_likes
    LEFT JOIN stories ON stories_likes.story_id = stories.id
WHERE stories.id IS NULL;


--Аналитики хотят знать: какая реакция (эмодзи) самая популярная вне зависимости от того, где она использовалась (сообщения в каналах, в группах, в личных сообщениях).
--Подсчитайте суммарное количество реакций каждого типа, которые использовались во всех сообщениях (во всех таблицах).
--Отсортируйте результат по идентификатору реакции (поле reaction_id).

with sum_reaction as
(
    select reaction_id, count(reaction_id) as count_reaction
    from private_message_reactions
    group by reaction_id

    union all

    select reaction_id, count(reaction_id) as count_reaction
    from channel_message_reactions
    group by reaction_id

    union all

    select reaction_id, count(reaction_id) as count_reaction
    from group_message_reactions
    group by reaction_id
)

select reaction_id, sum(count_reaction) as count
from sum_reaction
group by reaction_id
order by reaction_id asc


--Необходимо узнать: кто из пользователей владеет наибольшим количеством пабликов (суммарно: группами и каналами).
--Вывести идентификаторы топ 5 таких пользователей (поле owner_user_id в соответствующих таблицах) и суммарное количество пабликов у каждого из них.
--Не забывайте название таблицы `groups` обрамлять обратными кавычками. Слово входит в число зарезервированных.

with sum_count_public_cte as
(
    select owner_user_id
    from channels

    union all

    select owner_user_id
    from `groups`
)

select owner_user_id, count(owner_user_id) as cnt
from sum_count_public_cte
group by owner_user_id
order by cnt desc
limit 5;