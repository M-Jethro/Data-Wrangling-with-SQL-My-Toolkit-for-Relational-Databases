--  In this project, the goal was to use the ANSI and the non-ANSI types of joins
-- To do this, I created 4 different tables to use EMPLOYEE, DEPARTMENT, MANAGER and PROJECTS

create table employee
( 
  emp_id varchar(20),
  emp_name varchar (50),
  salary integer,
  dept_id varchar (20),
  manager_id varchar (20)
);

insert into employee
values
("E1","Jethro","15000","D1","M1"),
("E2","Roy","18000","D1", "M1"),
("E3","Matthew","15000","D5","M2"),
("E4","Patrick","25000","D5","M2"),
("E5","Faizah","65000","D2","M3"),
("E6","Winnie","35000","D2","M3"),
("E7","Andrew","19000","D4","M4"),
("E8","Conrad","106000","D3","M4"),
("E9","Arnold","67000","D4","M5"),
("E10","Samuel","35000","D3","M5");

create table department
(
  dept_id varchar (20),
  dept_name varchar (50)
);

insert into department
values
("D1", "IT"),
("D2", "HR"),
("D3", "Finance"),
("D4", "Admin"),
("D5", "Legal");

create table manager
(
  manager_id varchar (20),
  manager_name varchar (50),
  dept_id varchar (20)
);

insert into manager
values
("M1", "Joy", "D1"),
("M1", "Jackie", "D2"),
("M1", "Beyonce", "D3"),
("M1", "Nicole", "D4"),
("M1", "Porsche", "D5");

create table projects
(
  project_id varchar (20),
  project_name varchar (50),
  team_member_id varchar (20)
);

insert into projects
values
("P1", "Data Cleaning", "E1"),
("P2", "Data Analysis", "M2"),
("P3", "Data Visualization", "E3"),
("P4", "Data Manipulation", "M4"),
("P5", "Data Migration", "E5");

-- I LOOK AT THE TABLES THAT I CREATED ABOVE

select * from employee;
select * from department;
select * from manager;
select * from projects;

-- I NOW WRITE A QUERY THAT FETCHES THE EMPLOYEE AND THE DEPARTMENT THAT THEY BELONG TO
-- Option1 ANSI joins

select e.emp_name, d.dept_name
from employee e
join department d
on e.dept_id = d.dept_id;

-- Option2 NON-ANSI joins (we remove the 'join' and 'on')

select e.emp_name, d.dept_name
from employee e
     , department d
where e.dept_id = d.dept_id;

-- assuming we only want results from the legal department
-- using joins
select e.emp_name, d.dept_name
from employee e
join department d
on e.dept_id = d.dept_id
where d.dept_name ="Legal";

-- Option2 NON-ANSI joins

select e.emp_name, d.dept_name
from employee e
     , department d
where e.dept_id = d.dept_id
and d.dept_name ="Legal";

select e.emp_name, d.dept_name
from employee e
left join department d
on e.dept_id = d.dept_id
