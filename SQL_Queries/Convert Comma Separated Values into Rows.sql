
-- Convert Comma Separated Values into Rowsusing string_split function 
-- Find rooms that are searched mst number of times
-- Output the Room Types alongside the no of searches for it
-- If the filter for room type has more than one room type , consider each unique room type as separate row
-- Sort the result based on the number of searches  in descending order


create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);


insert into airbnb_searches values
 (1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')
;

select * from airbnb_searches;

-- string_split

select value from string_split('entire home,private room', ',')

-- applying in in table

select * from airbnb_searches
cross apply string_split(filter_room_types, ',')
;

-- applying logic to requirement

select value as room_type, count(*) as number_of_searches from airbnb_searches
cross apply string_split(filter_room_types, ',')
group by value
order by count(*) desc
;