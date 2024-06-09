SELECT sports_category
	,event_name
	,stakes
	,winnings
	,market_list
FROM (
	SELECT *
		,row_number() OVER (
			PARTITION BY sports_category ORDER BY stakes DESC
			) AS top_three_events
	FROM (
		SELECT sports_category
			,event_name
			,SUM(stake_in_GBP) AS stakes
			,sum(winnings) AS winnings
			,string_agg(market, ', ') AS market_list
		FROM production.bet_summary_details bsu
		JOIN production.bet_selections bs ON bsu.bet_id = bs.bet_id
		JOIN production.selections s ON bs.selection_id = s.selection_id
		GROUP BY sports_category
			,event_name
		) O
	) U
WHERE top_three_events < 4
ORDER BY sports_category;