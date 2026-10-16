-- SQL dialect: MySQL 8.0+
-- Prerequisites:
--   customers(customer_id, city)
--   sales_order(order_number, sales, customer, deal_size, order_date, year_id)
-- These source tables are not defined in this repository; run these examples
-- only in a database that already contains the required schema and data.

-- 1. Orders above the average sales value for their city.
-- The city average excludes small-deal orders; the returned orders do too.
WITH city_avg_sales AS (
    SELECT c.city, AVG(so.sales) AS avg_city_sales
    FROM sales_order AS so
    JOIN customers AS c
        ON c.customer_id = so.customer
    WHERE so.deal_size <> 'Small'
    GROUP BY c.city
)
SELECT
    so.order_number,
    so.sales,
    so.customer,
    so.deal_size,
    c.city,
    cas.avg_city_sales
FROM sales_order AS so
JOIN customers AS c
    ON c.customer_id = so.customer
JOIN city_avg_sales AS cas
    ON cas.city = c.city
WHERE so.deal_size <> 'Small'
  AND so.sales > cas.avg_city_sales
ORDER BY so.sales DESC;

-- 2. Same calculation using a derived table instead of a CTE.
SELECT
    so.order_number,
    so.sales,
    so.customer,
    so.deal_size,
    c.city,
    city_avg_sales.avg_city_sales
FROM sales_order AS so
JOIN customers AS c
    ON c.customer_id = so.customer
JOIN (
    SELECT c2.city, AVG(so2.sales) AS avg_city_sales
    FROM sales_order AS so2
    JOIN customers AS c2
        ON c2.customer_id = so2.customer
    WHERE so2.deal_size <> 'Small'
    GROUP BY c2.city
) AS city_avg_sales
    ON city_avg_sales.city = c.city
WHERE so.deal_size <> 'Small'
  AND so.sales > city_avg_sales.avg_city_sales
ORDER BY so.sales DESC;

-- 3. Orders above the overall average sale value, excluding small deals.
-- The average itself is calculated across all sales_order rows.
WITH overall_average AS (
    SELECT AVG(sales) AS average_sales
    FROM sales_order
)
SELECT so.order_number, so.sales, so.deal_size
FROM sales_order AS so
CROSS JOIN overall_average AS oa
WHERE so.sales > oa.average_sales
  AND so.deal_size <> 'Small'
ORDER BY so.sales DESC;

-- 4. Compare average monthly sales in 2003 and 2004.
-- The INNER JOIN returns months present in both years.
WITH monthly_average AS (
    SELECT
        year_id,
        MONTH(order_date) AS month_number,
        DATE_FORMAT(order_date, '%b') AS month_name,
        AVG(sales) AS avg_monthly_sales
    FROM sales_order
    WHERE year_id IN (2003, 2004)
    GROUP BY year_id, MONTH(order_date), DATE_FORMAT(order_date, '%b')
)
SELECT
    y03.month_name,
    y03.avg_monthly_sales AS average_sales_2003,
    y04.avg_monthly_sales AS average_sales_2004,
    ABS(y03.avg_monthly_sales - y04.avg_monthly_sales) AS absolute_difference
FROM monthly_average AS y03
JOIN monthly_average AS y04
    ON y03.month_number = y04.month_number
WHERE y03.year_id = 2003
  AND y04.year_id = 2004
ORDER BY y03.month_number;
