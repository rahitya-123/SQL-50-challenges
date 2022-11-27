USE AdventureWorks2012
GO

SELECT customer.customerId
	,SalesOrderHeader.SalesOrderID
	,totalOrderAmount = sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice*(1-SalesOrderDetail.UnitPriceDiscount))
FROM sales.customer
JOIN sales.salesorderheader ON Customer.CustomerID = SalesOrderHeader.CustomerID
JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
WHERE year(OrderDate) = 2013
GROUP BY customer.customerId
	,SalesOrderHeader.SalesOrderID
HAVING sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice*(1-SalesOrderDetail.UnitPriceDiscount)) > 10000
ORDER BY totalOrderAmount;