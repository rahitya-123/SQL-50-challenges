SELECT sports_category
	,stakes
	,winnings
	,promotion_bet_counts
	,non_promotion_bet_counts
FROM (
	SELECT *
		,RANK() OVER (
			PARTITION BY sports_category ORDER BY winnings DESC
			) AS highest_winnings
	FROM (
		SELECT C.username
			,sports_category
			,sum(stake_in_GBP) AS stakes
			,SUM(winnings) AS winnings
			,SUM(CASE 
					WHEN is_promotion = 1
						THEN 1
					ELSE 0
					END) AS promotion_bet_counts
			,SUM(CASE 
					WHEN is_promotion = 0
						THEN 1
					ELSE 0
					END) AS non_promotion_bet_counts
		FROM Production.Selections S
		JOIN Production.Bet_selections BS ON S.selection_id = BS.selection_id
		JOIN Production.Bet_Summary_details BSU ON BS.bet_id = BSU.bet_id
		JOIN Production.Customers C ON BSU.customer_id = C.customer_id
		GROUP BY C.username
			,sports_category
		) AS U
	) AS O
WHERE highest_winnings = 1;