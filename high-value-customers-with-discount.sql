USE AdventureWorks2012
GO

SELECT Customer.customerId
	,SalesOrderHeader.SalesOrderID
	,totalOrderAmount = sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice * (1 - SalesOrderDetail.UnitPriceDiscount))
FROM sales.customer
JOIN sales.salesorderheader ON Customer.CustomerID = SalesOrderHeader.CustomerID
JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
WHERE year(OrderDate) = 2013
GROUP BY customer.customerId
	,SalesOrderHeader.SalesOrderID
HAVING sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice * (1 - SalesOrderDetail.UnitPriceDiscount)) > 10000
ORDER BY totalOrderAmount;
GO

-- Using Window Functions
SELECT customerid
	,totalswithoutdiscount
	,totalswithdiscount
FROM (
	SELECT DISTINCT Customer.customerId
		,sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice * (1 - SalesOrderDetail.UnitPriceDiscount)) OVER (PARTITION BY Customer.customerId) AS totalswithdiscount
		,sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice) OVER (PARTITION BY Customer.customerId) AS totalswithoutdiscount
	FROM sales.customer
	JOIN sales.salesorderheader ON Customer.CustomerID = SalesOrderHeader.CustomerID
	JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
	WHERE year(OrderDate) = 2013
	) AS T
WHERE totalswithdiscount > 10000;
GO

