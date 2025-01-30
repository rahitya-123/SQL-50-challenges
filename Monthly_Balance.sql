SELECT customer_id AS Customer_ID
	, MIN([date]) AS Calendar_Month_start
	, EOMONTH(MAX([date])) AS Calendar_Month_End
	, SUM(cast(deposits AS INT)) AS Deposits
	, SUM(withdrawals) AS Withdrawals
	, SUM(cast(debits AS INT)) AS [Debit(Wager)]
	, SUM(cast(credits AS INT)) AS [Credit(Payout)]
	, SUM(manual_adjustments) AS Adjustments
	, SUM(CAST(deposits AS INT)) + SUM(withdrawals) + SUM(CAST(debits AS INT)) + SUM(CAST(credits AS INT)) + SUM(manual_adjustments) AS Balance
FROM Production.funds
GROUP BY customer_id
	, Year([date])
	, MONTH([date])
HAVING customer_id IN (
		5001404
		, 6601050
		, 6767707
		, 6588737
		, 6306383
		);

