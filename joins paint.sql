create table paintings
(
    id              int,
    name            varchar(40),
    artist_id       int,
    listed_price    float
);

create table artists
(
    id              int,
    first_name      varchar(40),
    last_name       varchar(40)
);

create table collectors
(
    id              int,
    first_name      varchar(40),
    last_name       varchar(40)
);

create table sales
(
    id                  int,
    sale_date           date,
    painting_id         int,
    artist_id           int,
    collector_id        int,
    sales_price         float
);

insert into paintings values (11,'Miracle',1,300);
insert into paintings values (12,'Sunshine',1,700);
insert into paintings values (13,'Pretty woman',2,2800);
insert into paintings values (14,'Handsome man',2,2300);
insert into paintings values (15,'Barbie',3,250);
insert into paintings values (16,'Cool painting',3,5000);
insert into paintings values (17,'Black square #1000',3,50);
insert into paintings values (18,'Mountains',4,1300);
insert into paintings values (19,'Sunset',10,2300);
insert into paintings values (20,'Sea Front',11,1600);

insert into artists values (1,'Thomas','Black');
insert into artists values (2,'Kate','Smith');
insert into artists values (3,'Natali','Wein');
insert into artists values (4,'Francesco','Benelli');
insert into artists values (5,'Nicholas','Smith');
insert into artists values (6,'Perl','Hoon');

insert into collectors values (101,'Brandon','Cooper');
insert into collectors values (102,'Laura','Fisher');
insert into collectors values (103,'Christina','Buffet');
insert into collectors values (104,'Steve','Stevenson');

insert into sales values (1001,'2021-11-01',13,2,104,2500);
insert into sales values (1002,'2021-11-10',14,2,102,2300);
insert into sales values (1003,'2021-11-10',11,1,102,300);
insert into sales values (1004,'2021-11-15',16,3,103,4000);
insert into sales values (1005,'2021-11-22',15,3,103,200);
insert into sales values (1006,'2021-11-22',17,3,103,50);

  select * from paintings;
  select * from artists;
  select * from collectors;
  select * from sales;


-- 1) Fetch names of all the artists along with their painting name.
--    If an artist does not have a painting yet, display as "NA"

 SELECT a.id, CONCAT(a.first_name,' ', a.last_name) as artist_name, COALESCE(ps.name, 'NA') as painting_name
 FROM artists a
 LEFT JOIN paintings ps ON a.id = ps.artist_id;
 
 
 SELECT a.id, CONCAT(a.first_name,' ', a.last_name) as artist_name, COALESCE(ps.name, 'NA') as painting_name
 FROM paintings ps
 RIGHT JOIN artists a ON a.id = ps.artist_id;
 

-- 2) Find collectors who did not purchase any paintings.

  SELECT cs.id, CONCAT(cs.first_name,' ', cs.last_name) AS collector, s.sales_price
  FROM collectors cs
  LEFT JOIN sales s ON s.collector_id = cs.id 
  WHERE s.sales_price is NULL;

-- 3) Find how much each artist made from sales. And how many paintings did they sell.
	  SELECT CONCAT(a.first_name,' ', a.last_name) AS artist, SUM(s.sales_price) as total_earnings, COUNT(distinct (s.painting_id) )as total_items
	  FROM artists a
	  LEFT JOIN sales s ON a.id = s.artist_id 
	  GROUP BY artist
	  ORDER BY total_earnings asc;
  
--4) 4) Display all the available paintings and all the artist. If a painting was sold then mark them as "Sold".
--    and if more than 1 painting of an artist was sold then display a "**" beside their name.

	SELECT
		p.id AS painting_id,
		p.name AS painting_name,
		a.id AS artist_id,
		CONCAT(a.first_name, ' ', a.last_name, CASE WHEN COUNT(s.painting_id) OVER (PARTITION BY a.id) > 1 THEN '**' END) AS artist_name,
		s.sales_price,
		CASE WHEN s.id IS NOT NULL THEN 'Sold' END AS sold_status
	FROM paintings p
	JOIN artists a ON p.artist_id = a.id
	LEFT JOIN sales s ON s.painting_id = p.id;
	
	

-- CROSS JOIN (everyone record in the left table will match with every other record in the right table) you do not add 'on' because of the nature of the cross join function.

 SELECT ps.name, ats.first_name
 FROM paintings ps
 CROSS JOIN artists ats;

  select * from paintings;
  select * from artists;
  select * from collectors;
  select * from sales;


-- NATURAL JOIN - combines rows from both tables based on columns with the same name and data types
 alter table artists rename column id to artist_id; -- did this to create a mutual column between both tables

  SELECT *
  FROM paintings ps
  NATURAL JOIN artists ats
  
 

-- SELF JOIN

	drop table employee_master;
	create table employee_master
	(
		id          int,
		name        varchar(40),
		salary      int,
		manager_id  int
	);

	insert into employee_master values (1   ,'John Smith',  10000,  3);
	insert into employee_master values (2   ,'Jane Anderson',   12000,  3);
	insert into employee_master values (3   ,'Tom Lanon',   15000,  4);
	insert into employee_master values (4   ,'Anne Connor', 20000,  null);
	insert into employee_master values (5   ,'Jeremy York', 9000,   1);

	select * from employee_master;

-- Write a query to display the employee name and their corresponding manager name.

	select emp.name as emp_name, mng.name as manager_name
	from employee_master emp
	join employee_master mng on emp.manager_id = mng.id;
	
--Display all staff including those without managers 

	select emp.name as emp_name, mng.name as manager_name
	from employee_master emp
	left join employee_master mng on emp.manager_id = mng.id;

















