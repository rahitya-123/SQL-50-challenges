USE AdventureWorks2012
GO

WITH customerTotalOrder_2013 (
	CustomerId
	,SalesOrderID
	,TotalOrderAmount
	)
AS (
	SELECT Customer.CustomerID
		,SalesOrderHeader.SalesOrderID
		,TotalOrderAmount = sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice)
	FROM sales.customer
	JOIN sales.salesorderheader ON Customer.CustomerID = SalesOrderHeader.CustomerID
	JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
	WHERE year(OrderDate) = 2013
	GROUP BY customer.customerId
		,SalesOrderHeader.SalesOrderID
	)
SELECT DISTINCT CustomerGroup
	,count(CustomerGroup) OVER (PARTITION BY CustomerGroup) AS TotalInGroup
	,(count(CustomerGroup) OVER (PARTITION BY CustomerGroup)) * 100.0 / (
		SELECT count(*)
		FROM CustomerTotalOrder_2013
		) AS PercentageInGroup
FROM (
	SELECT CASE 
			WHEN 0 <= TotalOrderAmount
				AND TotalOrderAmount <= 1000
				THEN 'Low'
			WHEN 1000 < TotalOrderAmount
				AND TotalOrderAmount <= 5000
				THEN 'Medium'
			WHEN 5000 < TotalOrderAmount
				AND TotalOrderAmount <= 10000
				THEN 'High'
			WHEN TotalOrderAmount > 10000
				THEN 'Very High'
			END AS CustomerGroup
	FROM customerTotalOrder_2013
	) AS T
ORDER BY TotalInGroup DESC;