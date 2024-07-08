
use demo;

-- query to return all emp whose sal is same in same dept

CREATE TABLE [emp_salary]
(
    [emp_id] INTEGER  NOT NULL,
    [name] NVARCHAR(20)  NOT NULL,
    [salary] NVARCHAR(30),
    [dept_id] INTEGER
);

INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

select * from [emp_salary];

select 
e1.dept_id, e1.salary, count(e1.emp_id) as emps
from emp_salary e1 join emp_salary e2
on e1.emp_id = e2.emp_id
group by e1.dept_id, e1.salary
having count(e1.emp_id) >1

/*

dept_id	salary	emps
11	3000	2
12	4000	2

*/

with sal_dept as(
	select salary, dept_id
	from emp_salary
	group by salary, dept_id
	having count(1) > 1)
select emp_salary.* from emp_salary join sal_dept
on emp_salary.dept_id = sal_dept.dept_id and emp_salary.salary = sal_dept.salary

