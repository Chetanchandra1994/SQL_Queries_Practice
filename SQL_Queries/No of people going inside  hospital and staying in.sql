
use demo;

-- no of people going inside  hospital and staying in

create table hospital ( emp_id int
, action varchar(10)
, time datetime);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');

select * from hospital;

-- Using group by and having
select count(*) from 
(
select emp_id,
	max(case when action = 'in' then time end) as In_time,
	max(case when action = 'out' then time end) as Out_time
from hospital
group by emp_id
having max(case when action = 'in' then time end) > max(case when action = 'out' then time end) or max(case when action = 'out' then time end) is null
) as in_emp;


-- Using CTE
with res as 
	(
	select emp_id,
		max(case when action = 'in' then time end) as In_time,
		max(case when action = 'out' then time end) as Out_time
	from hospital
	group by emp_id)
select count(*) from res
where In_time > Out_time or Out_time is null;

select count(emp_id)
from hospital
where concat(emp_id, time) in 
	(select concat(emp_id, max(time)) 
	from hospital
	group by emp_id) 
	and action = 'in'