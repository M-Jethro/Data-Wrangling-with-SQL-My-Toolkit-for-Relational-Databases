	drop table employee;
	create table employee
	( emp_ID int
	, emp_NAME varchar(50)
	, DEPT_NAME varchar(50)
	, SALARY int);

	insert into employee values(101, 'Mohan', 'Admin', 4000);
	insert into employee values(102, 'Rajkumar', 'HR', 3000);
	insert into employee values(103, 'Akbar', 'IT', 4000);
	insert into employee values(104, 'Dorvin', 'Finance', 6500);
	insert into employee values(105, 'Rohit', 'HR', 3000);
	insert into employee values(106, 'Rajesh',  'Finance', 5000);
	insert into employee values(107, 'Preet', 'HR', 7000);
	insert into employee values(108, 'Maryam', 'Admin', 4000);
	insert into employee values(109, 'Sanjay', 'IT', 6500);
	insert into employee values(110, 'Vasudha', 'IT', 7000);
	insert into employee values(111, 'Melinda', 'IT', 8000);
	insert into employee values(112, 'Komal', 'IT', 10000);
	insert into employee values(113, 'Gautham', 'Admin', 2000);
	insert into employee values(114, 'Manisha', 'HR', 3000);
	insert into employee values(115, 'Chandni', 'IT', 4500);
	insert into employee values(116, 'Satya', 'Finance', 6500);
	insert into employee values(117, 'Adarsh', 'HR', 3500);
	insert into employee values(118, 'Tejaswi', 'Finance', 5500);
	insert into employee values(119, 'Cory', 'HR', 8000);
	insert into employee values(120, 'Monica', 'Admin', 5000);
	insert into employee values(121, 'Rosalin', 'IT', 6000);
	insert into employee values(122, 'Ibrahim', 'IT', 8000);
	insert into employee values(123, 'Vikram', 'IT', 8000);
	insert into employee values(124, 'Dheeraj', 'IT', 11000);
	COMMIT;


	select * from employee


-- 1) Fetch the first 2 employees from each department to join the company.
	 SELECT*
	 FROM
		(
		 SELECT *, ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY emp_id) as row_number
		 FROM employee
		) EMP_TABLE
	WHERE EMP_TABLE.row_number IN (1,2)


-- 2) Fetch the top 3 employees in each department earning the max salary.
 SELECT*
	 FROM
		(
		 SELECT *, RANK() OVER (PARTITION BY dept_name ORDER BY salary desc) as rank
		 FROM employee
		) EMP_TABLE
	WHERE EMP_TABLE.rank IN (1,2,3)


-- Practice Excercise1


	create table fb_eu_energy
		(
			date            date,
			consumption     int
		);

	drop table fb_asia_energy;
	create table fb_asia_energy
		(
			date            date,
			consumption     int
		);

	drop table fb_na_energy;
	create table fb_na_energy
		(
			date            date,
			consumption     int
		);

	insert into fb_eu_energy values ('2020-01-01',400);
	insert into fb_eu_energy values ('2020-01-02',350);
	insert into fb_eu_energy values ('2020-01-03',500);
	insert into fb_eu_energy values ('2020-01-04',500);
	insert into fb_eu_energy values ('2020-01-07',600);

	insert into fb_asia_energy values ('2020-01-01',400);
	insert into fb_asia_energy values ('2020-01-02',400);
	insert into fb_asia_energy values ('2020-01-04',675);
	insert into fb_asia_energy values ('2020-01-05',1200);
	insert into fb_asia_energy values ('2020-01-06',750);
	insert into fb_asia_energy values ('2020-01-07',400);

	insert into fb_na_energy values ('2020-01-01',250);
	insert into fb_na_energy values ('2020-01-02',375);
	insert into fb_na_energy values ('2020-01-03',600);
	insert into fb_na_energy values ('2020-01-06',500);
	insert into fb_na_energy values ('2020-01-07',250);


	select * from fb_eu_energy;
	select * from fb_asia_energy;
	select * from fb_na_energy;

/* Find the date with the highest total energy consumption from the Meta/Facebook data centers.
Output the date along with the total energy consumption across all data centers.
If there are multiple days with same highest energy consumption then display both dates.
*/
	 WITH CTE AS
	    (
		SELECT * FROM fb_eu_energy
		UNION ALL
		SELECT * FROM fb_asia_energy
		UNION ALL
		SELECT * FROM fb_na_energy
	    ),

	  CTE2 AS
	   (
		SELECT date, SUM(consumption) AS total_consumption, 
			  DENSE_RANK() OVER (ORDER BY SUM(consumption) DESC) RNK
		FROM CTE
		GROUP BY date 
		ORDER BY date desc
	   )

	 SELECT *
	 FROM CTE2
	 WHERE RNK = 1

-- PRACTICE EXERCISE 2
-- From the students table, write a SQL query to interchange the adjacent student names.
-- Note: If there are no adjacent student then the student name should stay the same.

	drop table students;
	create table students
		(
			id              int primary key,
			student_name    varchar(50) not null
		);
	insert into students values
		(1, 'James'),
		(2, 'Michael'),
		(3, 'George'),
		(4, 'Stewart'),
		(5, 'Robin');

select * from students;

	SELECT
		*,
		CASE
			-- If the 'id' is odd, use the next student's name (LEAD).
			WHEN id % 2 <> 0 THEN LEAD(student_name, 1, student_name) OVER (ORDER BY id)
			-- If the 'id' is even, use the previous student's name (LAG).
			ELSE LAG(student_name) OVER (ORDER BY id)
		END AS new_student
	FROM students;
















































