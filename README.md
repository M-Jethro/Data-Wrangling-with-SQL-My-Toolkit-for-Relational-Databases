# Data Wrangling with SQL: A Toolkit for Relational Databases

A collection of hands-on SQL exercises covering relational table design, data insertion, joins, common table expressions (CTEs), window functions, triggers, duplicate removal, and analytical querying.

This repository is a **set of independent practice scripts**, not one application or one migration. Several exercises create tables with common names such as `employee`, `artists`, or `product`. Run each exercise in a dedicated practice database and review every `DROP`, `DELETE`, `TRUNCATE`, or schema-changing statement before execution.

## Technology

- **MySQL 8.0+** is the recommended environment for the CTE and window-function examples.
- MySQL Workbench or the MySQL command-line client can be used to run the scripts.
- If using PostgreSQL, SQL Server, or another engine, check and adapt dialect-specific syntax.

## Topics and project files

| File | What it demonstrates |
| --- | --- |
| [`Creating Tables.sql`](./Creating%20Tables.sql) | Tables, primary keys, foreign keys, and referential actions. |
| [`Inserting Values in a table.sql`](./Inserting%20Values%20in%20a%20table.sql) | Loading sample branch, employee, supplier, client, and sales-relationship data. |
| [`ANSI & NON-ANSI JOINS.sql`](./ANSI%20%26%20NON-ANSI%20JOINS.sql) | Explicit joins, legacy comma joins, and left joins using employee, department, manager, and project data. |
| [`joins paint.sql`](./joins%20paint.sql) | Inner/outer joins, cross joins, natural joins, self joins, and painting sales summaries. |
| [`CTE_SALES_ORDERS.sql`](./CTE_SALES_ORDERS.sql) | CTEs versus derived tables; city-level and overall sales comparisons; monthly average comparisons. Requires existing `customers` and `sales_order` tables. |
| [`window functions.sql`](./window%20functions.sql) | Employee ranking, departmental aggregates, regional energy totals, and `LEAD`/`LAG`. |
| [`window-functions-ranking-lag.sql`](./window-functions-ranking-lag.sql) | Focused examples of `MAX() OVER`, `ROW_NUMBER()`, `RANK()`, and `LAG()`. |
| [`products_ntile, fv,lead, lag.sql`](./products_ntile,%20fv,lead,%20lag.sql) | `FIRST_VALUE`, `NTH_VALUE`, and `NTILE` for product-price analysis. |
| [`Triggers.sql`](./Triggers.sql) | MySQL trigger syntax and logging insert events. Requires the employee practice schema. |
| [`deleting duplicate values.sql`](./deleting%20duplicate%20values.sql) | Detecting repeated artist names and keeping one row per name. Contains its own demo data. |

## Getting started

### 1. Set up a SQL environment

Install MySQL Server 8.0 or newer, then create a disposable practice database:

```sql
CREATE DATABASE sql_practice;
```

Connect to `sql_practice` before running an exercise.

### 2. Choose one exercise

Open the relevant `.sql` file and read the comments at the top. **Do not run all scripts sequentially in the same database:** multiple exercises reuse table names but expect different schemas and data.

### 3. For the branch/employee schema

For the foreign-key and data-insertion lesson, run these files in order in an empty practice database:

1. `Creating Tables.sql`
2. `Inserting Values in a table.sql`
3. `Triggers.sql` (optional)

The trigger script demonstrates three alternative versions of one trigger and inserts employee IDs 109–111. It removes those demo rows and clears its demonstration log before rerunning, so it can be used repeatedly after the branch/employee setup. MySQL Workbench and the MySQL command-line client support the `DELIMITER` commands used in that script; some browser-based SQL editors do not.

### 4. For analytical SQL exercises

- `CTE_SALES_ORDERS.sql` expects `customers` and `sales_order` tables with the columns referenced in the queries. Their schemas and data are not included in this repository.
- The join, window-function, and product exercises define example tables in their scripts. Run each against a suitable, isolated practice schema.
- `deleting duplicate values.sql` drops and recreates its demo `artists` table at the start.

## Example: rank employees within each department

```sql
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
) AS ranked_employees
WHERE salary_rank <= 3
ORDER BY dept_name, salary_rank, emp_id;
```

`RANK()` preserves ties, so the query may return more than three rows per department. Use `ROW_NUMBER()` when you need at most three rows and have specified a deterministic tie-breaker.

## Safe practice

- Use disposable databases for exercises that drop or recreate tables.
- Confirm the expected schema and table names before running a script.
- Preview affected rows with a `SELECT` before executing data-changing statements.
- Back up data before destructive operations. These scripts are for learning, not production migrations.
- Results depend on the source data available in your database; the repository does not guarantee a particular output.

## Skills demonstrated

Relational schema design, referential integrity, joins, aggregation, CTEs, window functions, trigger logic, deduplication, and translating analytical questions into SQL.

## Repository

[Browse the source code on GitHub](https://github.com/M-Jethro/Data-Wrangling-with-SQL-My-Toolkit-for-Relational-Databases)
