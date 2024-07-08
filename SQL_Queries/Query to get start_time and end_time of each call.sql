
-- Query to get start_time and end_time of each call 
-- create a column of call duration in minutes
-- Do not take into account that there will be multiple calls from one phone number 
-- Each entry in start table has a corresponding entry in end table.

create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);

insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')

create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);

insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;

select * from call_start_logs;
select * from call_end_logs;

-----------------------------------------------------------------------------------------------------------------
/*
select 
s.phone_number, 
start_time,
end_time,
datediff(minute, start_time, end_time) as duration,
convert(time, start_time),
convert(time,end_time),
datepart(day, start_time),
datepart(day, end_time)
from call_start_logs s join call_end_logs e
on s.phone_number = e.phone_number and datepart(day, start_time) <= datepart(day, end_time) and convert(time, start_time) < convert(time,end_time)
*/

-----------------------------------------------------------------------------------------------------------------

select *, ROW_NUMBER() over (partition by phone_number order by start_time) as rn1 from call_start_logs;
select *, ROW_NUMBER() over (partition by phone_number order by end_time) as rn1 from call_end_logs;
-----------------------------------------------------------------------------------------------------------------

select a.phone_number, a.start_time, b.end_time, datediff(minute, start_time, end_time) as duration
from 
	(select *, ROW_NUMBER() over (partition by phone_number order by start_time) as rn from call_start_logs) a
join 
	(select *, ROW_NUMBER() over (partition by phone_number order by end_time) as rn from call_end_logs) b
on a.phone_number = b.phone_number and a.rn = b.rn

-----------------------------------------------------------------------------------------------------------------

select phone_number, rn, min(call_time) as start_time, max(call_time) as end_time, datediff(minute, min(call_time),  max(call_time)) as duration from
(
select phone_number, start_time as call_time, ROW_NUMBER() over (partition by phone_number order by start_time) as rn from call_start_logs
union all 
select *, ROW_NUMBER() over (partition by phone_number order by end_time) as rn from call_end_logs) subquery
group by phone_number,rn
order by phone_number