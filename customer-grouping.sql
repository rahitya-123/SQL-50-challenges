USE AdventureWorks2012
GO

with customerTotalOrder_2013(CustomerId,SalesOrderID,TotalOrderAmount) AS
(SELECT Customer.CustomerID
	,SalesOrderHeader.SalesOrderID
	,TotalOrderAmount = sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice)
FROM sales.customer
JOIN sales.salesorderheader ON Customer.CustomerID = SalesOrderHeader.CustomerID
JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
WHERE year(OrderDate) = 2013
GROUP BY customer.customerId
	,SalesOrderHeader.SalesOrderID)
select CustomerID, SalesOrderID, TotalOrderAmount,
case
    when 0 <= TotalOrderAmount AND TotalOrderAmount <= 1000 Then 'Low'
    when 1000 < TotalOrderAmount AND TotalOrderAmount <= 5000 Then 'Medium'
    when 5000 < TotalOrderAmount AND TotalOrderAmount <= 10000 Then 'High'
    when TotalOrderAmount > 10000  Then 'Very High'
end as CustomerGroup
from customerTotalOrder_2013
order by CustomerID;