	
	select * from customers;
	select * from products;
	select * from sales_order;
	
--1) Find the most profitable orders. Most profitable orders are those whose sale price exceeded the average sale price for each city and whose deal size was not small. Use CTE

	WITH CTE AS 
	(
	  SELECT AVG(so.sales) AS AvgCitySales, cs.city
	  FROM sales_order so
	  JOIN customers cs ON cs.customer_id = so.customer
	  WHERE so.deal_size <> 'Small'
	  GROUP BY cs.city
	)

	SELECT so.order_number, so.sales, so.customer, so.deal_size, cs.city, cte.AvgCitySales
	FROM sales_order so
	JOIN customers cs ON cs.customer_id = so.customer
	JOIN CTE ON cs.city = CTE.city
	WHERE so.sales > CTE.AvgCitySales;


--2) Re-write above query without using CTE

	SELECT so.order_number, so.sales, so.customer, so.deal_size, cs.city, avg_city_sales.AvgCitySales
	FROM sales_order so
	JOIN customers cs ON cs.customer_id = so.customer
	JOIN (
	  SELECT AVG(s.sales) AS AvgCitySales, c.city
	  FROM sales_order s
	  JOIN customers c ON c.customer_id = s.customer
	  WHERE s.deal_size <> 'Small'
	  GROUP BY c.city
	) avg_city_sales ON cs.city = avg_city_sales.city
	WHERE so.sales > avg_city_sales.AvgCitySales;


--3) Find the most profitable orders. Most profitable orders are those whose sale price exceeded the average sale price and whose deal size was not small.

	WITH AvgSalePrice AS (
		SELECT AVG(sales) AS AveragePrice
		FROM sales_order
	)

	SELECT order_number, sales, deal_size
	FROM sales_order
	JOIN AvgSalePrice ON sales > AveragePrice
	WHERE deal_size <> 'Small'
	ORDER BY sales DESC;

	select * from customers;
	select * from products;
	select * from sales_order;

4) Find the difference in average sales for each month of 2003 and 2004.

	WITH cte_2003 AS (
		SELECT
			TO_CHAR(order_date, 'MON') AS month,
			AVG(sales) AS avg_sales_per_month
		FROM sales_order
		WHERE year_id = 2003
		GROUP BY TO_CHAR(order_date, 'MON')
	),

	cte_2004 AS (
		SELECT
			TO_CHAR(order_date, 'MON') AS month,
			AVG(sales) AS avg_sales_per_month
		FROM sales_order
		WHERE year_id = 2004
		GROUP BY TO_CHAR(order_date, 'MON')
	)

	SELECT
		yr03.month,
		ABS(yr03.avg_sales_per_month - yr04.avg_sales_per_month) AS difference
	FROM cte_2003 yr03
	JOIN cte_2004 yr04 ON yr03.month = yr04.month;

--solution 2 in order to remove the redudancy in the coding

		WITH cte AS (
			SELECT
				year_id,
				TO_CHAR(order_date, 'MON') AS mon,
				AVG(sales) AS avg_sales_per_month
			FROM sales_order s
			WHERE year_id IN (2003, 2004)
			GROUP BY year_id, TO_CHAR(order_date, 'MON')
		)
		SELECT
			y03.mon,
			ABS(y03.avg_sales_per_month - y04.avg_sales_per_month) AS diff
		FROM cte y03 -- we join the CTE table to itself however with different aliases
		JOIN cte y04 ON y03.mon = y04.mon
		WHERE y03.year_id = 2003
		  AND y04.year_id = 2004;


    select * from customers;
	select * from products;
	select * from sales_order;















































