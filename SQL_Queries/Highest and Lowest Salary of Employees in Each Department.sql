
-- Print Highest and Lowest Salary of Employees in Each Department

-- drop table employee

create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);

INSERT INTO employee (emp_name, dep_id, salary)
VALUES 
    ('Siva', 1, 30000),
    ('Ravi', 2, 40000),
    ('Prasad', 1, 50000),
    ('Sai', 2, 20000);


--------------------------------------------------------------------------------------------------------------

select * from  employee;

/*
emp_name	dep_id	salary
Siva	1	30000
Ravi	2	40000
Prasad	1	50000
Sai		2	20000
*/

-- first find max and min sal in each dept
select dep_id, min(salary) as min_sal, max(salary) as max_sal from  employee group by dep_id;

/*
dep_id	min_sal	max_sal
1		30000	50000
2		20000	40000
*/

-- join the output with employee table to get full data

with cte as 
	(select dep_id, min(salary) as min_sal, max(salary) as max_sal from  employee group by dep_id)
select e.*, min_sal, max_sal from employee e
inner join cte on e.dep_id = cte.dep_id;

/*
emp_name	dep_id	salary	min_sal	 max_sal
Siva		 1		 30000	 30000	  50000
Prasad		 1		 50000	 30000	  50000
Sai			 2		 20000	 20000	  40000
Ravi		 2		 40000	 20000	  40000
*/

-- filter out desired output

with cte as 
	(select dep_id, min(salary) as min_sal, max(salary) as max_sal from  employee group by dep_id)
select 
	e.dep_id, 
	max(case when salary=min_sal then e.emp_name end) as emp_min_sal, 
	max(case when salary=max_sal then e.emp_name end) as emp_max_sal
from employee e
inner join cte on e.dep_id = cte.dep_id
group by e.dep_id;

/*
dep_id	emp_min_sal	 emp_max_sal
	1		Siva	  Prasad
	2		Sai		  Ravi
*/

--------------------------------------------------------------------------------------------------------------

WITH EmpRanked AS (
    SELECT 
        emp_name,
        dep_id,
        salary,
        ROW_NUMBER() OVER (PARTITION BY dep_id ORDER BY salary DESC) AS emp_rank_max_sal,
        ROW_NUMBER() OVER (PARTITION BY dep_id ORDER BY salary ASC) AS emp_rank_min_sal
    FROM 
        employee
)
SELECT 
    dep_id,
    MAX(CASE WHEN emp_rank_max_sal = 1 THEN emp_name END) AS emp_max_sal,
    MAX(CASE WHEN emp_rank_min_sal = 1 THEN emp_name END) AS emp_min_sal
FROM 
    EmpRanked
GROUP BY 
    dep_id;
