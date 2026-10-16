-- SQL dialect: MySQL 8.0+
-- Practice examples for aggregate, ranking, and navigation window functions.
-- Run in a dedicated practice database.

CREATE TABLE employee_rank_demo (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_name VARCHAR(50) NOT NULL,
    salary INT NOT NULL
);

INSERT INTO employee_rank_demo (emp_id, emp_name, dept_name, salary)
VALUES
    (1, 'Jethro', 'HR', 5000),
    (2, 'Michael', 'Finance', 4000),
    (3, 'Joy', 'Admin', 3000),
    (4, 'Calvin', 'IT', 7600),
    (5, 'Claire', 'HR', 5500),
    (6, 'Paul', 'Finance', 2000),
    (7, 'Hannah', 'Admin', 6000),
    (8, 'Makarios', 'IT', 7000),
    (9, 'Claver', 'HR', 8000),
    (10, 'Darrian', 'Finance', 9000),
    (11, 'Ciara', 'Admin', 10000),
    (12, 'Lyadda', 'IT', 11000),
    (13, 'Brenda', 'HR', 12000),
    (14, 'Olive', 'Finance', 13500),
    (15, 'Shirley', 'Admin', 14200),
    (16, 'Monica', 'IT', 5000),
    (17, 'Jackie', 'HR', 6000),
    (18, 'Lorna', 'Finance', 7000),
    (19, 'Faizah', 'Admin', 8000),
    (20, 'Winnie', 'IT', 9000),
    (21, 'Roy', 'HR', 10000),
    (22, 'Patrick', 'Finance', 7560),
    (23, 'Matthew', 'Admin', 6400),
    (24, 'Samuel', 'IT', 8600),
    (25, 'Daniel', 'HR', 9500);

-- 1. Highest salary in the full dataset.
SELECT MAX(salary) AS maximum_salary
FROM employee_rank_demo;

-- 2. Highest salary by department.
SELECT dept_name, MAX(salary) AS maximum_department_salary
FROM employee_rank_demo
GROUP BY dept_name
ORDER BY dept_name;

-- 3. Display each employee alongside their department's highest salary.
SELECT
    emp_id,
    emp_name,
    dept_name,
    salary,
    MAX(salary) OVER (PARTITION BY dept_name) AS maximum_department_salary
FROM employee_rank_demo
ORDER BY dept_name, emp_id;

-- 4. First two employees by employee ID in each department.
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
    FROM employee_rank_demo
) AS ranked_employees
WHERE row_num <= 2
ORDER BY dept_name, row_num;

-- 5. Employees with salary ranks 1-3 in each department.
-- RANK preserves ties, so more than three rows may be returned.
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
    FROM employee_rank_demo
) AS ranked_salaries
WHERE salary_rank <= 3
ORDER BY dept_name, salary_rank, emp_id;

-- 6. Compare each employee's salary with the previous employee by ID in
-- the same department, handling the first row explicitly.
WITH employee_salary_history AS (
    SELECT
        emp_id,
        emp_name,
        dept_name,
        salary,
        LAG(salary) OVER (
            PARTITION BY dept_name
            ORDER BY emp_id
        ) AS previous_salary
    FROM employee_rank_demo
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
FROM employee_salary_history
ORDER BY dept_name, emp_id;
