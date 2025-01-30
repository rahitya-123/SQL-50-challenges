/*

Seller-Buyer-Details ----> Google SQL question

You are given a transaction table, which records transactions between sellers and buyers. 
The structure of the table is as follows:
		Transaction_ID (INT), Customer_ID (INT), Amount (INT), Date (timestamp)

Every successful transaction will have two row entries into the table with two different 
transaction_id but in ascending order sequence, the first one for the seller where their 
customer_id will be registered, and the second one for the buyer where their customer_id will 
be registered. The amount and date time for both will however be the same.

Write an sql query to find the 5 top seller-buyer combinations who have had maximum transactions 
between them.

Condition - Please disqualify the sellers who have acted as buyers and also the buyers who have 
acted as sellers for this condition.

*/




/*
create table command
CREATE TABLE dbo.transactions (
	transaction_id INT PRIMARY KEY
	,customer_id INT
	,amount INT
	,tran_Date DATETIME
	);
*/

/*
DELETE
FROM Transactions;


INSERT INTO Transactions
VALUES (
	1
	,101
	,500
	,'2025-01-01 10:00:01'
	);

INSERT INTO Transactions
VALUES (
	2
	,201
	,500
	,'2025-01-01 10:00:01'
	);

INSERT INTO Transactions
VALUES (
	3
	,102
	,300
	,'2025-01-02 00:50:01'
	);

INSERT INTO Transactions
VALUES (
	4
	,202
	,300
	,'2025-01-02 00:50:01'
	);

INSERT INTO Transactions
VALUES (
	5
	,101
	,700
	,'2025-01-03 06:00:01'
	);

INSERT INTO Transactions
VALUES (
	6
	,202
	,700
	,'2025-01-03 06:00:01'
	);

INSERT INTO Transactions
VALUES (
	7
	,103
	,200
	,'2025-01-04 03:00:01'
	);

INSERT INTO Transactions
VALUES (
	8
	,203
	,200
	,'2025-01-04 03:00:01'
	);

INSERT INTO Transactions
VALUES (
	9
	,101
	,400
	,'2025-01-05 00:10:01'
	);

INSERT INTO Transactions
VALUES (
	10
	,201
	,400
	,'2025-01-05 00:10:01'
	);

INSERT INTO Transactions
VALUES (
	11
	,101
	,500
	,'2025-01-07 10:10:01'
	);

INSERT INTO Transactions
VALUES (
	12
	,201
	,500
	,'2025-01-07 10:10:01'
	);

INSERT INTO Transactions
VALUES (
	13
	,102
	,200
	,'2025-01-03 10:50:01'
	);

INSERT INTO Transactions
VALUES (
	14
	,202
	,200
	,'2025-01-03 10:50:01'
	);

INSERT INTO Transactions
VALUES (
	15
	,103
	,500
	,'2025-01-01 11:00:01'
	);

INSERT INTO Transactions
VALUES (
	16
	,101
	,500
	,'2025-01-01 11:00:01'
	);
	
*/	
	



----Method 1

WITH cte1
AS (
	SELECT Sellers_Details.customer_id AS seller
		,Buyers_Details.customer_id AS buyer
		,count(*) AS count_of_transactions
	FROM dbo.transactions Sellers_Details
	JOIN dbo.Transactions Buyers_Details ON Sellers_Details.amount = Buyers_Details.amount
		AND Sellers_Details.tran_date = Buyers_Details.tran_date
		AND Sellers_Details.transaction_id = Buyers_Details.transaction_id - 1
		AND Buyers_Details.transaction_id % 2 = 0
	GROUP BY Sellers_Details.customer_id
		,Buyers_Details.customer_id
	)
SELECT *
FROM cte1
WHERE seller NOT IN (
		SELECT buyer
		FROM cte1
		)
	AND buyer NOT IN (
		SELECT seller
		FROM cte1
		);





---- Method 2


WITH cte
AS (
	SELECT transaction_id
		,customer_id AS seller_id
		,amount
		,tran_date
		,LEAD(customer_id) OVER (
			ORDER BY transaction_id
			) AS buyer_id
	FROM transactions
	)
	,cte_combinations
AS (
	SELECT seller_id
		,buyer_id
		,COUNT(*) AS no_of_transactions
	FROM cte
	WHERE transaction_id % 2 = 1
	GROUP BY seller_id
		,buyer_id
	)
	,fraud_customers
AS (
	SELECT seller_id AS frauds
	FROM cte_combinations
	
	INTERSECT
	
	SELECT buyer_id
	FROM cte_combinations
	)
SELECT *
FROM cte_combinations
WHERE seller_id NOT IN (
		SELECT frauds
		FROM fraud_customers
		)
	AND buyer_id NOT IN (
		SELECT frauds
		FROM fraud_customers
		);
