-- SQL dialect: MySQL 8.0+
-- Window-function practice: ranking, LAG/LEAD, and conditional row pairing.
-- Run only in a disposable practice database; this script recreates its demo tables.

DROP TABLE IF EXISTS employee_window_demo;
DROP TABLE IF EXISTS fb_eu_energy, fb_asia_energy, fb_na_energy;
DROP TABLE IF EXISTS students;

CREATE TABLE employee_window_demo (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_name VARCHAR(50) NOT NULL,
    salary INT NOT NULL
);

INSERT INTO employee_window_demo (emp_id, emp_name, dept_name, salary)
VALUES
    (101, 'Mohan', 'Admin', 4000),
    (102, 'Rajkumar', 'HR', 3000),
    (103, 'Akbar', 'IT', 4000),
    (104, 'Dorvin', 'Finance', 6500),
    (105, 'Rohit', 'HR', 3000),
    (106, 'Rajesh', 'Finance', 5000),
    (107, 'Preet', 'HR', 7000),
    (108, 'Maryam', 'Admin', 4000),
    (109, 'Sanjay', 'IT', 6500),
    (110, 'Vasudha', 'IT', 7000),
    (111, 'Melinda', 'IT', 8000),
    (112, 'Komal', 'IT', 10000),
    (113, 'Gautham', 'Admin', 2000),
    (114, 'Manisha', 'HR', 3000),
    (115, 'Chandni', 'IT', 4500),
    (116, 'Satya', 'Finance', 6500),
    (117, 'Adarsh', 'HR', 3500),
    (118, 'Tejaswi', 'Finance', 5500),
    (119, 'Cory', 'HR', 8000),
    (120, 'Monica', 'Admin', 5000),
    (121, 'Rosalin', 'IT', 6000),
    (122, 'Ibrahim', 'IT', 8000),
    (123, 'Vikram', 'IT', 8000),
    (124, 'Dheeraj', 'IT', 11000);

SELECT * FROM employee_window_demo ORDER BY emp_id;

-- 1. Maximum salary in the entire sample.
SELECT MAX(salary) AS maximum_salary
FROM employee_window_demo;

-- 2. Maximum salary by department.
SELECT
    dept_name,
    MAX(salary) AS maximum_department_salary
FROM employee_window_demo
GROUP BY dept_name
ORDER BY dept_name;

-- 3. Show each employee beside the maximum salary in their department.
SELECT
    emp_id,
    emp_name,
    dept_name,
    salary,
    MAX(salary) OVER (PARTITION BY dept_name) AS maximum_department_salary
FROM employee_window_demo
ORDER BY dept_name, emp_id;

-- 4. First two employees by ID in each department.
SELECT emp_id, emp_name, dept_name, row_num
FROM (
    SELECT
        emp_id,
        emp_name,
        dept_name,
        ROW_NUMBER() OVER (
            PARTITION BY dept_name
            ORDER BY emp_id
        ) AS row_num
    FROM employee_window_demo
) AS ranked_employees
WHERE row_num <= 2
ORDER BY dept_name, row_num;

-- 5. Employees whose salary ranks in the top three within their department.
-- RANK() retains ties, so a department can return more than three employees.
SELECT emp_id, emp_name, dept_name, salary, salary_rank
FROM (
    SELECT
        emp_id,
        emp_name,
        dept_name,
        salary,
        RANK() OVER (
            PARTITION BY dept_name
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employee_window_demo
) AS ranked_salaries
WHERE salary_rank <= 3
ORDER BY dept_name, salary_rank, emp_id;

-- 6. Compare each employee's salary with the previous employee by ID
-- within the same department.
WITH salary_history AS (
    SELECT
        emp_id,
        emp_name,
        dept_name,
        salary,
        LAG(salary) OVER (
            PARTITION BY dept_name
            ORDER BY emp_id
        ) AS previous_salary
    FROM employee_window_demo
)
SELECT
    emp_id,
    emp_name,
    dept_name,
    salary,
    previous_salary,
    CASE
        WHEN previous_salary IS NULL THEN 'No previous employee in department'
        WHEN salary > previous_salary THEN 'Higher than previous employee'
        WHEN salary < previous_salary THEN 'Lower than previous employee'
        ELSE 'Same salary as previous employee'
    END AS salary_comparison
FROM salary_history
ORDER BY dept_name, emp_id;

-- 7. Example regional energy records, combined into one daily total.
CREATE TABLE fb_eu_energy (
    energy_date DATE NOT NULL,
    consumption INT NOT NULL
);

CREATE TABLE fb_asia_energy (
    energy_date DATE NOT NULL,
    consumption INT NOT NULL
);

CREATE TABLE fb_na_energy (
    energy_date DATE NOT NULL,
    consumption INT NOT NULL
);

INSERT INTO fb_eu_energy (energy_date, consumption)
VALUES
    ('2020-01-01', 400),
    ('2020-01-02', 350),
    ('2020-01-03', 500),
    ('2020-01-04', 500),
    ('2020-01-07', 600);

INSERT INTO fb_asia_energy (energy_date, consumption)
VALUES
    ('2020-01-01', 400),
    ('2020-01-02', 400),
    ('2020-01-04', 675),
    ('2020-01-05', 1200),
    ('2020-01-06', 750),
    ('2020-01-07', 400);

INSERT INTO fb_na_energy (energy_date, consumption)
VALUES
    ('2020-01-01', 250),
    ('2020-01-02', 375),
    ('2020-01-03', 600),
    ('2020-01-06', 500),
    ('2020-01-07', 250);

WITH all_regions AS (
    SELECT energy_date, consumption FROM fb_eu_energy
    UNION ALL
    SELECT energy_date, consumption FROM fb_asia_energy
    UNION ALL
    SELECT energy_date, consumption FROM fb_na_energy
),
daily_totals AS (
    SELECT energy_date, SUM(consumption) AS total_consumption
    FROM all_regions
    GROUP BY energy_date
),
ranked_daily_totals AS (
    SELECT
        energy_date,
        total_consumption,
        DENSE_RANK() OVER (ORDER BY total_consumption DESC) AS consumption_rank
    FROM daily_totals
)
SELECT energy_date, total_consumption
FROM ranked_daily_totals
WHERE consumption_rank = 1
ORDER BY energy_date;

-- 8. Swap adjacent student names by ID; keep an unpaired final name unchanged.
CREATE TABLE students (
    id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL
);

INSERT INTO students (id, student_name)
VALUES
    (1, 'James'),
    (2, 'Michael'),
    (3, 'George'),
    (4, 'Stewart'),
    (5, 'Robin');

SELECT
    id,
    student_name,
    CASE
        WHEN id % 2 = 1 THEN LEAD(student_name, 1, student_name) OVER (ORDER BY id)
        ELSE LAG(student_name, 1, student_name) OVER (ORDER BY id)
    END AS swapped_name
FROM students
ORDER BY id;
