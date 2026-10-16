# Data Wrangling with SQL: A Toolkit for Relational Databases

A collection of SQL scripts demonstrating how to create and populate relational tables, combine data across tables, and solve analytical query problems using joins, common table expressions, and window functions.

## Project overview

This repository serves as a reusable SQL reference toolkit. Its scripts use sample employee, department, manager, project, customer, product, sales-order, energy-consumption, student, and employee-pay datasets. They illustrate how to structure relational data and write queries to answer common analytical questions.

## Tools and technologies

- **SQL**
- Relational database concepts: tables, identifiers, and joins
- Analytical SQL: aggregation, subqueries, CTEs, and window functions

> The repository uses SQL syntax from more than one database dialect in places (for example, MySQL-style constructs and `TO_CHAR`). Check the target database and adapt syntax as required.

## Topics covered

- **Table creation and data insertion:** defining tables and loading sample records.
- **Joins:** ANSI joins, non-ANSI join syntax, inner joins, and left joins.
- **Common table expressions (CTEs):** simplifying multi-step analysis and comparing CTEs with subquery alternatives.
- **Window functions:** `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, and `LEAD()`.
- **Data manipulation:** examples involving duplicate values and relational data transformations.
- **Analytical problem-solving:** orders above city or overall sales averages, monthly sales comparisons across years, employee rankings within departments, and peak energy-consumption dates across regions.

## Repository structure

Selected scripts include:

- `ANSI & NON-ANSI JOINS.sql` — join syntax and retrieval across employee and department tables.
- `CTE_SALES_ORDERS.sql` — CTEs and subquery approaches to sales-order analysis.
- `Creating Tables.sql` and `Inserting Values in a table.sql` — table definitions and example data.
- `Window funtions - Rank, RowNum, Lag.sql`, `Windowfuntions.sql`, and `window functions.sql` — ranking and navigation functions.
- `Triggers.sql` — trigger-related examples.
- `deleting duplicate values.sql` — examples focused on duplicate records.
- `joins paint.sql` — join-based query practice.

File names are preserved as they currently appear in the repository.

## How to use the toolkit

1. Open the SQL script for the topic you want to practise.
2. Read its comments to understand the question being addressed.
3. Confirm which SQL dialect your environment supports.
4. Create the example tables and insert sample data where required.
5. Execute the queries and inspect the results.

These scripts should be run selectively rather than as one single migration. Some scripts create or drop tables, so use a practice database and review statements before running them.

## Example: rank employees within each department

```sql
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY dept_name
            ORDER BY emp_id
        ) AS row_num
    FROM employee
) AS ranked_employees
WHERE row_num <= 2;
```

This pattern returns up to two employees per department, ordered by employee ID.

## Example: compare CTEs with subqueries

The sales-order examples calculate average sales by city and compare individual orders with those averages. The repository includes both a CTE-based implementation and a subquery-based alternative, providing a direct comparison of query structure and readability.

## What this project demonstrates

This toolkit showcases SQL fluency across data definition, data loading, table relationships, analytical query logic, and common interview-style data questions. It is best treated as a practical reference and learning repository rather than a single end-to-end application.

## Repository

[View the SQL scripts on GitHub](https://github.com/M-Jethro/Data-Wrangling-with-SQL-My-Toolkit-for-Relational-Databases)
