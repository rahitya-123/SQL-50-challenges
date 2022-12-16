/*write a sql program to populate category values to the last not null value.
Table Name: brands
			category  |brand_name
			---------------------
			chocolates|5-star
			NULL      |dairy milk
			NULL      |perk
			NULL      |eclairs
			Biscuits  |britannia
			NULL	  |good day
			NULL	  |Boost     */
WITH cte1
AS (
	SELECT *
		,ROW_NUMBER() OVER (
			ORDER BY (
					SELECT NULL
					)
			) AS rn
	FROM brands
	)
	,cte2
AS (
	SELECT *
		,LEAD(rn,) OVER (
			ORDER BY rn
			) AS next_rn
	FROM cte1
	WHERE category IS NOT NULL
	)
SELECT cte2.catgeory
	,cte1.brand_name
FROM cte1
INNER JOIN cte2 ON cte1.rn >= cte2.rn
	AND (
		cte1.rn <= cte2.next_rn - 1
		OR cte2.next_rn IS NULL
		);