use demo;

-- Business Days Excluding Weekends and Public Holidays

create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);

delete from tickets;

insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');


select * , DATEDIFF(day, create_date, resolved_date) as no_of_days from tickets;


create table holidays
(
holiday_date date
,reason varchar(100)
);

delete from holidays;

insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select * from tickets;
select * from holidays;

WITH cte AS (
    SELECT 
        t.ticket_id,
        t.create_date,
        t.resolved_date,
        h.holiday_date
    FROM 
        tickets t
    LEFT JOIN 
        holidays h 
	ON h.holiday_date >= t.create_date AND h.holiday_date <= t.resolved_date AND DATENAME(WEEKDAY, h.holiday_date) NOT IN ('Saturday', 'Sunday')
)
SELECT 
    ticket_id,
    create_date,
    resolved_date,
    DATEDIFF(DAY, create_date, resolved_date) + 1 
    - 2 * (DATEDIFF(WEEK, create_date, resolved_date) + 1) 
    - COUNT(holiday_date) AS actual_biz_days
FROM 
    cte
GROUP BY 
    ticket_id, create_date, resolved_date;

/*

Explanation of Changes:
CTE (Common Table Expression):

Selected necessary columns (ticket_id, create_date, resolved_date, and holiday_date).
Joined tickets and holidays based on the condition that holiday_date falls between create_date and resolved_date and is not a weekend day (Saturday or Sunday).
Main Query:

Corrected the calculation of actual_biz_days.
DATEDIFF(DAY, create_date, resolved_date) + 1: Calculates the total days between create_date and resolved_date, inclusive.
- 2 * (DATEDIFF(WEEK, create_date, resolved_date) + 1): Calculates the number of weekends (Saturdays and Sundays) between create_date and resolved_date and subtracts them.
- COUNT(holiday_date): Counts the number of holidays falling between create_date and resolved_date and subtracts them from actual_biz_days.
Grouping:

Groups by ticket_id, create_date, and resolved_date to ensure each ticket's calculation is independent and accurate.
Key Points to Note:
Date Functions:

Uses DATENAME(WEEKDAY, h.holiday_date) to check if holiday_date is a weekend day (Saturday or Sunday).
DATEDIFF(WEEK, create_date, resolved_date) calculates the number of full weeks between create_date and resolved_date.
Business Days Calculation:

Combines the total days with adjustments for weekends and subtracts holidays to compute actual_biz_days.
This revised query should work correctly in SQL Server Management Studio (SSMS) and give you the desired count of business days (actual_biz_days) between create_date and resolved_date for each ticket.

*/

WITH cte AS (
    SELECT 
        t.ticket_id,
        t.create_date,
        t.resolved_date,
        h.holiday_date
    FROM 
        tickets t
    LEFT JOIN 
        holidays h ON h.holiday_date >= t.create_date 
                   AND h.holiday_date <= t.resolved_date
)
SELECT 
    ticket_id,
    create_date,
    resolved_date,
    DATEDIFF(DAY, create_date, resolved_date) + 1 
    - 2 * (DATEDIFF(WEEK, create_date, resolved_date) + 1) 
    - SUM(CASE WHEN DATENAME(WEEKDAY, holiday_date) = 'Saturday' THEN 1
               WHEN DATENAME(WEEKDAY, holiday_date) = 'Sunday' THEN 1
               ELSE 0 END) AS actual_biz_days
FROM 
    cte
WHERE 
    DATENAME(WEEKDAY, holiday_date) NOT IN ('Saturday', 'Sunday') OR holiday_date IS NULL
GROUP BY 
    ticket_id, create_date, resolved_date;
