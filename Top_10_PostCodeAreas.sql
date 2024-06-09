WITH TopTenStakes
AS (
	SELECT bs.bet_id
		,bs.customer_id
		,bs.stake_in_GBP
		,bs.is_promotion
		,c.postcode_area
		,bs.date_settled
	FROM Production.bet_summary_details bs
	INNER JOIN Production.customerdetails c ON bs.customer_id = c.customer_id
	)
SELECT TOP (10) postcode_area
	,sum(stake_in_GBP) AS stakes_sum
FROM TopTenStakes
WHERE is_promotion = 0
	AND date_settled IS NOT NULL
GROUP BY postcode_area
ORDER BY stakes_sum DESC;
GO