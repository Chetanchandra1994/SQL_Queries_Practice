

-- There are 2 tables, 1st table has 5 records and 2nd table has 10 records.
-- you can assume any value in each tables.
-- How many maximum and minimum records are possible in case of inner join, left join, right join and full outer join.


create table T1( id_1 int);

INSERT INTO T1 (id_1)
VALUES (1)
INSERT INTO T1 (id_1)
VALUES (1)
INSERT INTO T1 (id_1)
VALUES (1)
INSERT INTO T1 (id_1)
VALUES (1)
INSERT INTO T1 (id_1)
VALUES (1)

create table T2( id_2 int);

INSERT INTO T2(id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)
INSERT INTO T2(id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)
INSERT INTO T2 (id_2)
VALUES (1)

create table T3( id_3 int);

INSERT INTO T3(id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)
INSERT INTO T3(id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)
INSERT INTO T3 (id_3)
VALUES (2)

select * from t1;
select * from t2;
select * from t3;

------------------------------------------------------------------------------------------------------


select count(*) from t1 inner join t2 on t1.id_1 = t2.id_2;
/* OUTPUT
(No column name)
50
*/

select count(*) from t1 left join t2 on t1.id_1 = t2.id_2;
/* OUTPUT
(No column name)
50
*/

select count(*) from t1 right join t2 on t1.id_1 = t2.id_2;
/* OUTPUT
(No column name)
50
*/

select count(*) from t1 full outer join t2 on t1.id_1 = t2.id_2;
/* OUTPUT
(No column name)
50
*/

--------------------------------------------------------------------------------------------------
-- Maximum and minimum records = 50 if each records are same in both tables.
--------------------------------------------------------------------------------------------------

select count(*) from t1 inner join t3 on t1.id_1 = t3.id_3;
/* OUTPUT
(No column name)
0
*/

select count(*) from t1 left join t3 on t1.id_1 = t3.id_3;
/* OUTPUT
(No column name)
5
*/

select count(*) from t1 right join t3 on t1.id_1 = t3.id_3;
/* OUTPUT
(No column name)
10
*/

select count(*) from t1 full outer join t3 on t1.id_1 = t3.id_3;
/* OUTPUT
(No column name)
15
*/


--------------------------------------------------------------------------------------------------
-- Maximum record is 15 and minimum records is 0 if each both tables have no matching records.
--------------------------------------------------------------------------------------------------