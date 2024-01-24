	DROP TABLE product;
	CREATE TABLE product
	(
		product_category varchar(255),
		brand varchar(255),
		product_name varchar(255),
		price int
	);

	INSERT INTO product VALUES
	('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
	('Phone', 'Apple', 'iPhone 12 Pro', 1100),
	('Phone', 'Apple', 'iPhone 12', 1000),
	('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
	('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
	('Phone', 'Samsung', 'Galaxy Note 20', 1200),
	('Phone', 'Samsung', 'Galaxy S21', 1000),
	('Phone', 'OnePlus', 'OnePlus Nord', 300),
	('Phone', 'OnePlus', 'OnePlus 9', 800),
	('Phone', 'Google', 'Pixel 5', 600),
	('Laptop', 'Apple', 'MacBook Pro 13', 2000),
	('Laptop', 'Apple', 'MacBook Air', 1200),
	('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
	('Laptop', 'Dell', 'XPS 13', 2000),
	('Laptop', 'Dell', 'XPS 15', 2300),
	('Laptop', 'Dell', 'XPS 17', 2500),
	('Earphone', 'Apple', 'AirPods Pro', 280),
	('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
	('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
	('Earphone', 'Sony', 'WF-1000XM4', 250),
	('Headphone', 'Sony', 'WH-1000XM4', 400),
	('Headphone', 'Apple', 'AirPods Max', 550),
	('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
	('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
	('Smartwatch', 'Apple', 'Apple Watch SE', 400),
	('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
	('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);
	COMMIT;


	select * from product;

---- 1) Write query to display the most expensive product under each category (corresponding to each record)

	 SELECT *, FIRST_VALUE (product_name) OVER (PARTITION BY product_category ORDER BY PRICE desc) AS most_expensive_product
	 FROM product;

-- 2) Write query to display the 2nd most expensive product under each category 
		-- (corresponding to each record)
	
	SELECT *, NTH_VALUE(product_name, 2)OVER (PARTITION BY product_category ORDER BY PRICE desc
											 range between unbounded preceding and unbounded following) AS second_most_expensive_product
	FROM product;

--3) Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.


	SELECT
		product_name,
		price,
		-- Use a CASE statement to categorize products into phone categories
		CASE
			WHEN buckets = 1 THEN 'Expensive Phones'    -- Bucket 1: Expensive Phones
			WHEN buckets = 2 THEN 'Mid-Range Phones'   -- Bucket 2: Mid-Range Phones
			ELSE 'Cheaper Phones'                      -- Bucket 3: Cheaper Phones
		END AS phone_category

	FROM (
		-- Subquery to segment products and assign them to buckets based on price

		SELECT
			*,
			-- Use NTILE(3) to divide products into three buckets based on price, ordered by price in descending order
			NTILE(3) OVER (ORDER BY price DESC) AS buckets

		FROM product
		WHERE product_category = 'Phone'  -- Select only products in the 'Phone' category
	) x;































