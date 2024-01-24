create table employee
(emp_id integer,
emp_name varchar (50),
dept_name varchar (50),
salary integer);

insert into employee
values ("001", "Jethro", "HR", 5000),
       ("002", "Michael", "Finance", 4000),
       ("003", "Joy", "Admin", 3000),
       ("004", "Calvin", "IT", 7600),
       ("005", "Claire", "HR", 5500),
       ("006", "Paul", "Finance", 2000),
       ("007", "Hannah", "Admin", 6000),
       ("008", "Makarios", "IT", 7000),
       ("009", "Claver", "HR", 8000),
       ("010", "Darrian", "Finance", 9000),
       ("011", "Ciara", "Admin", 10000),
       ("012", "Lyadda", "IT", 11000),
       ("013", "Brenda", "HR", 12000),
       ("014", "Olive", "Finance", 13500),
       ("015", "Shirley", "Admin", 14200),
       ("016", "Monica", "IT", 5000),
       ("017", "Jackie", "HR", 6000),
       ("018", "Lorna", "Finance", 7000),
       ("019", "Faizah", "Admin", 8000),
       ("020", "Winnie", "IT", 9000),
       ("021", "Roy", "HR", 10000),
       ("022", "Patrick", "Finance", 7560),
       ("023", "Matthew", "Admin", 6400),
       ("024", "Samuel", "IT", 8600),
       ("025", "Daniel", "HR", 9500);
       
	select * FROM EMPLOYEE;
    
    -- FINDING THE MAX SALARY
select max(salary) as Maximum_Salary
from employee;

   -- finding maximum salary per department
select dept_name, max(salary) as "Max Salary"
from employee
group by dept_name;

   -- listing all other salaries in comparison to the max per department

select *,
max(salary) over(partition by dept_name) as "Max Salary in Department"
from employee
order by dept_name asc;

  -- getting the first 2 employees hired from each department
  select ad.number, emp_name, dept_name 
  from (
  select *,
row_number () over(partition by dept_name order by emp_id) as number
from employee) ad
  where ad.number < 3;
  
--  the top 3 employees earning the most salary per department
select ad.number, emp_name, dept_name, salary 
  from (
  select *,
rank () over(partition by dept_name order by salary desc) as number
from employee) ad
  where ad.number < 4;
  
  -- a query to find out if the salary of an employee is higher, lower or equal to the previous employee
select emp_name, dept_name, salary,
lag(salary, 1, "Non existent") over(partition by dept_name order by emp_id) as "Previous Salary",
     case when employee.salary > lag(salary, 1, "Non existent") over(partition by dept_name order by emp_id) then "Higher than Previous employee"
           when employee.salary < lag(salary, 1, "Non existent") over(partition by dept_name order by emp_id) then "Lower than Previous employee"
           when employee.salary = lag(salary, 1, "Non existent") over(partition by dept_name order by emp_id) then "Same as Previous employee"
	 end as salary_comparisons
from employee;