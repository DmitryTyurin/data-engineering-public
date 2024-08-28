--Необходимо узнать: кто из пользователей добавился в максимальное количество каналов.
--Информация о членстве пользователей в каналах хранится в таблице channel_subscribers.
-- Необходимо вывести номер пользователя и количество каналов, на которые он подписался.

select distinct user_id, count(channel_id) over(partition by user_id) as channels_count
from channel_subscribers
where status in ('joined')
order by channels_count desc
limit 1;


--Аналитики хотят знать: насколько популярен у пользователей премиум аккаунт.
--Напишите запрос, выводящий оба значения в поле is_premium_account таблицы user_settings и количество пользователей напротив него.

select distinct is_premium_account,
    count(user_id) over(partition by is_premium_account) as users_amount
from user_settings;


--Аналитики хотят проанализировать частоту использования каждого эмодзи (реакции).
--Напишите запрос, выводящий количество использования каждой реакции в личных сообщениях.
--Сколько раз встречается каждый reaction_id в таблице private_message_reactions?
--Выборку отсортировать по убыванию количества строк.

select distinct count(*) over(partition by reaction_id) as count,
    reaction_id
from private_message_reactions
order by count desc;


--Теперь от предыдущей выборки нужно оставить только те строки, в которых значение в поле count > 80 (верхние 5 строк от предыдущей выборки).
--Допишите соответствующим образом предыдущий запрос.
with private_message_reactions_count as
(
    select distinct count(*) over(partition by reaction_id) as count,
        reaction_id
    from private_message_reactions
    order by count desc
)

select *
from private_message_reactions_count
where count > 80


--Необходимо узнать: какое количество просмотров историй (суммарно) набрал каждый пользователь.
--Результат отсортируйте по номеру пользователя (поле user_id).

select distinct sum(views_count) over(partition by user_id) as views_per_user,
    user_id
from stories
order by user_id;


--Добавляем логику к предыдущему заданию.
--От прошлой выборки необходимо оставить топ 5 пользователей, которые набрали наибольшее количество суммарных просмотров.

select distinct sum(views_count) over(partition by user_id) as views_per_user,
            user_id
from stories
order by views_per_user desc
limit 5;


--Узнайте: сколько лайков собрала каждая история пользователя номер 2. Информацию можно взять из таблицы stories_likes.
--Результат отсортируйте по убыванию количества лайков.
--Отобразить нужно только следующие поля: id в таблице stories количество лайков
--В задаче используйте объединение таблиц (JOIN).

select distinct s.id, count(sl.user_id) over(partition by s.id) as likes_count
from stories_likes sl
    left join stories s on sl.story_id = s.id
where s.user_id = 2
order by likes_count desc;


--Аналитики хотят знать: какая реакция (эмодзи) самая популярная вне зависимости от того, где она использовалась (сообщения в каналах, в группах, в личных сообщениях).
--Подсчитайте суммарное количество реакций каждого типа, которые использовались во всех сообщениях (во всех таблицах).
--Отсортируйте результат по идентификатору реакции (поле reaction_id).

with
sum_reaction as
(
    select reaction_id
    from private_message_reactions

    union all

    select reaction_id
    from channel_message_reactions

    union all

    select reaction_id
    from group_message_reactions
)

select distinct reaction_id, count(*) over(partition by reaction_id) as count
from sum_reaction
order by reaction_id;


--Необходимо узнать: кто из пользователей владеет наибольшим количеством пабликов (суммарно: группами и каналами).
--Вывести идентификаторы топ 5 таких пользователей (поле owner_user_id в соответствующих таблицах) и суммарное количество пабликов у каждого из них.

with sum_count_public_cte as
(
    select owner_user_id
    from channels

    union all

    select owner_user_id
    from `groups`
)

select distinct owner_user_id, count(owner_user_id) over(partition by owner_user_id) as cnt
from sum_count_public_cte
order by cnt desc
limit 5