-- SQL dialect: MySQL 8.0+
-- Run this example in a dedicated practice database.
-- The sample employee, department, manager, and projects tables are defined here.

CREATE TABLE employee (
    emp_id VARCHAR(20),
    emp_name VARCHAR(50),
    salary INT,
    dept_id VARCHAR(20),
    manager_id VARCHAR(20)
);

INSERT INTO employee
VALUES
    ('E1', 'Jethro', 15000, 'D1', 'M1'),
    ('E2', 'Roy', 18000, 'D1', 'M1'),
    ('E3', 'Matthew', 15000, 'D5', 'M2'),
    ('E4', 'Patrick', 25000, 'D5', 'M2'),
    ('E5', 'Faizah', 65000, 'D2', 'M3'),
    ('E6', 'Winnie', 35000, 'D2', 'M3'),
    ('E7', 'Andrew', 19000, 'D4', 'M4'),
    ('E8', 'Conrad', 106000, 'D3', 'M5'),
    ('E9', 'Arnold', 67000, 'D4', 'M4'),
    ('E10', 'Samuel', 35000, 'D3', 'M5');

CREATE TABLE department (
    dept_id VARCHAR(20),
    dept_name VARCHAR(50)
);

INSERT INTO department
VALUES
    ('D1', 'IT'),
    ('D2', 'HR'),
    ('D3', 'Finance'),
    ('D4', 'Admin'),
    ('D5', 'Legal');

CREATE TABLE manager (
    manager_id VARCHAR(20),
    manager_name VARCHAR(50),
    dept_id VARCHAR(20)
);

INSERT INTO manager
VALUES
    ('M1', 'Joy', 'D1'),
    ('M2', 'Jackie', 'D5'),
    ('M3', 'Beyonce', 'D2'),
    ('M4', 'Nicole', 'D4'),
    ('M5', 'Porsche', 'D3');

CREATE TABLE projects (
    project_id VARCHAR(20),
    project_name VARCHAR(50),
    team_member_id VARCHAR(20)
);

INSERT INTO projects
VALUES
    ('P1', 'Data Cleaning', 'E1'),
    ('P2', 'Data Analysis', 'E2'),
    ('P3', 'Data Visualization', 'E3'),
    ('P4', 'Data Manipulation', 'E4'),
    ('P5', 'Data Migration', 'E5');

-- Inspect the source tables.
SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM manager;
SELECT * FROM projects;

-- ANSI JOIN: retrieve each employee's department.
SELECT e.emp_name, d.dept_name
FROM employee AS e
JOIN department AS d
    ON e.dept_id = d.dept_id;

-- Legacy non-ANSI join syntax. Prefer explicit JOIN ... ON in new code.
SELECT e.emp_name, d.dept_name
FROM employee AS e, department AS d
WHERE e.dept_id = d.dept_id;

-- Filter to the Legal department using ANSI join syntax.
SELECT e.emp_name, d.dept_name
FROM employee AS e
JOIN department AS d
    ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Legal';

-- The equivalent filter using legacy non-ANSI syntax.
SELECT e.emp_name, d.dept_name
FROM employee AS e, department AS d
WHERE e.dept_id = d.dept_id
  AND d.dept_name = 'Legal';

-- LEFT JOIN: retain every employee, even if no department matches.
SELECT e.emp_name, d.dept_name
FROM employee AS e
LEFT JOIN department AS d
    ON e.dept_id = d.dept_id;

-- Join employees to their manager and project, where present.
SELECT e.emp_name, m.manager_name, p.project_name
FROM employee AS e
LEFT JOIN manager AS m
    ON e.manager_id = m.manager_id
LEFT JOIN projects AS p
    ON p.team_member_id = e.emp_id
ORDER BY e.emp_id;
