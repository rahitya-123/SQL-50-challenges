IF OBJECT_ID('Production.CustomerDetails','V') IS NOT NULL
DROP VIEW Production.CustomerDetails;
GO
CREATE VIEW Production.CustomerDetails
AS
SELECT *
FROM (
	SELECT customer_id
		,first_name
		,last_name
		,username
		,date_of_birth
		,CASE 
			WHEN CAST(customer_mobile_no as bigint) LIKE '7[1-9]0%'
			AND len(cast(customer_mobile_no as bigint)) = 12
				THEN customer_mobile_no
			END AS valid_mobile_no
		,CASE 
			WHEN len(REPLACE(address_postcode, ' ', '')) = 7
				THEN upper(left(REPLACE(address_postcode, ' ', ''), 4))
			WHEN len(REPLACE(address_postcode, ' ', '')) = 6
				THEN upper(left(REPLACE(address_postcode, ' ', ''), 3))
			END AS postcode_area
		,brand
	FROM Production.Customers 
	WHERE address_postcode NOT LIKE '[1-9]%'
	) A
    WHERE valid_mobile_no IS NOT NULL
	AND postcode_area IS NOT NULL
	;
GO


IF OBJECT_ID('Production.bet_Summary_Details','V') IS NOT NULL
DROP VIEW Production.bet_Summary_Details;
GO
CREATE VIEW Production.bet_Summary_Details
WITH SCHEMABINDING
AS
SELECT bet_id
	,customer_id
	,is_promotion
	,CASE 
		WHEN currency = 'GBP'
			THEN stake
		WHEN currency = 'EUR'
			THEN stake * 0.8
		END AS stake_in_GBP
	,winnings
	,date_placed
	,date_settled
FROM production.bet_summary;
GO 

EXEC sp_helptext 'Production.customerDetails';
EXEC sp_helptext 'Production.bet_Summary_Details';