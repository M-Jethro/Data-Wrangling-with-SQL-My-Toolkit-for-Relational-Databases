select * from paintings;
select * from artists;
select * from collectors;
select * from sales;

-- WORKING WITH DUPLICATE DATA

insert into artists values (5,'Kate','Smith');
insert into artists values (6,'Natali','Wein');
	
-- Identify the duplicate data. the count (id) allows us see how many times an entry is duplicated

select first_name, last_name, count(id)
from artists
group by first_name, last_name

-- we now select the duplicated entries

select first_name, last_name, max(id)
from artists
group by first_name, last_name
having count(id)>1;

-- Once identified, then delete move the duplicate data.

delete from artists
where id in (select max(id)
             from artists
             group by first_name, last_name
             having count(id)>1)

-- the method above works when there is one duplicate value. 

-- Method 2: when there are multiple duplicate records
insert into artists values (5,'Kate','Smith');
insert into artists values (6,'Natali','Wein');
insert into artists values (7,'Kate','Smith');
insert into artists values (8,'Natali','Wein');
	
	select * from artists;
	
	delete from artists 
	where id not in (select min(id) -- This subquery returns all unique records, we keep the minimum record and delete the rest
					from artists 
					group by first_name, last_name);
					

-- Method 3: When there is huge dataset, we can create a duplicate table that carries the unique values.
	select * from artists;

	create table artists_bkp 
	as
	select min(id) as id, first_name, last_name
	from artists 
	group by first_name, last_name;
	
	select * from artists_bkp;
	
-- Sub method 2: Using Truncate
	insert into artists values (1,'Thomas','Black');
	insert into artists values (2,'Kate','Smith');
	insert into artists values (3,'Natali','Wein');
	insert into artists values (4,'Francesco','Benelli');
	insert into artists values (5,'Kate','Smith');
	insert into artists values (6,'Natali','Wein');
	insert into artists values (7,'Kate','Smith');
	insert into artists values (8,'Natali','Wein');

	select * from artists;
	select * from artists_bkp;
	
	truncate table artists;
	
	insert into artists 
	select * from artists_bkp;
	
	drop table artists_bkp;
	
select * from paintings;
select * from artists;
select * from collectors;
select * from sales;




































select * from paintings;
select * from artists;
select * from collectors;
select * from sales;