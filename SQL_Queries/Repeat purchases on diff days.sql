
-- Obtain no of users who purchased same product on 2 or more diff days. 
-- Output number of unique users

create table purchases(
	user_id int,
	product_id int,
	quantity int,
	purchase_date datetime
);

insert into purchases values(536, 3223, 6, '01/11/2022 12:33:44');
insert into purchases values(827, 3585, 35, '02/20/2022 14:05:26');
insert into purchases values(536, 3223, 5, '03/02/2022 09:33:28');
insert into purchases values(536, 1435, 10, '03/02/2022 08:40:00');
insert into purchases values(827, 2452, 45, '04/09/2022 00:00:00');
insert into purchases values(333, 1122, 9, '2022-02-06 01:00:00');
insert into purchases values(333, 1122, 10, '2022-02-06 02:00:00');
insert into purchases values(333, 1122, 8, '2022-02-06 14:46:00');

select * from purchases order by user_id;

select convert(date, purchase_date) from purchases order by user_id;

select cast(purchase_date as date) from purchases order by user_id;

select 
	user_id, product_id,  
	count(distinct cast(purchase_date as date)) as p_date_count
from purchases 
group by user_id, product_id
order by user_id;

select * from purchases order by user_id;

-- now lets filter for only those products purchased on more than 1 days and get user count


select count(distinct user_id) as user_count from 
(
select 
	user_id, product_id,  
	count(distinct cast(purchase_date as date)) as p_date_count
from purchases 
group by user_id, product_id
having count(distinct cast(purchase_date as date)) >1) a;