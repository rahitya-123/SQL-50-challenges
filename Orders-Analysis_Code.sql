SELECT *
FROM dbo.df_orders;

--find top 10 highest reveue generating products 
SELECT TOP 10 product_id
	, sum(sale_price) AS sales
FROM df_orders
GROUP BY product_id
ORDER BY sales DESC;

--find top 5 highest selling products in each region
WITH cte
AS (
	SELECT region
		, product_id
		, sum(sale_price) AS sales
	FROM df_orders
	GROUP BY region
		, product_id
	)
SELECT *
FROM (
	SELECT *
		, row_number() OVER (
			PARTITION BY region ORDER BY sales DESC
			) AS rn
	FROM cte
	) A
WHERE rn <= 5

--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
WITH cte AS (
		SELECT year(order_date) AS order_year
			, month(order_date) AS order_month
			, sum(sale_price) AS sales
		FROM df_orders
		GROUP BY year(order_date)
			, month(order_date)
		)

--order by year(order_date),month(order_date)
SELECT order_month
	, sum(CASE 
			WHEN order_year = 2022
				THEN sales
			ELSE 0
			END) AS sales_2022
	, sum(CASE 
			WHEN order_year = 2023
				THEN sales
			ELSE 0
			END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;

--for each category which month had highest sales 
WITH cte
AS (
	SELECT category
		, format(order_date, 'yyyyMM') AS order_year_month
		, sum(sale_price) AS sales
	FROM df_orders
	GROUP BY category
		, format(order_date, 'yyyyMM')
		--order by category,format(order_date,'yyyyMM')
	)
SELECT *
FROM (
	SELECT *
		, row_number() OVER (
			PARTITION BY category ORDER BY sales DESC
			) AS rn
	FROM cte
	) a
WHERE rn = 1;

--which sub category had highest growth by profit in 2023 compare to 2022
WITH cte AS (
		SELECT sub_category
			, year(order_date) AS order_year
			, sum(sale_price) AS sales
		FROM df_orders
		GROUP BY sub_category
			, year(order_date)
			--order by year(order_date),month(order_date)
		)
	, cte2 AS (
		SELECT sub_category
			, sum(CASE 
					WHEN order_year = 2022
						THEN sales
					ELSE 0
					END) AS sales_2022
			, sum(CASE 
					WHEN order_year = 2023
						THEN sales
					ELSE 0
					END) AS sales_2023
		FROM cte
		GROUP BY sub_category
		)

SELECT TOP 1 *
	, (sales_2023 - sales_2022)
FROM cte2
ORDER BY (sales_2023 - sales_2022) DESC;