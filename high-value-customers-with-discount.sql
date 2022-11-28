USE AdventureWorks2012
GO

SELECT Customer.customerId
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
GO

-- Using Window Functions

Select customerid,totalswithoutdiscount,totalswithdiscount
from 
(select distinct Customer.customerId,
sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice*(1-SalesOrderDetail.UnitPriceDiscount)) 
over(partition by Customer.customerId)as totalswithdiscount,
sum(SalesOrderDetail.orderqty * SalesOrderDetail.unitprice) 
over(partition by Customer.customerId) as totalswithoutdiscount

FROM sales.customer
JOIN sales.salesorderheader ON Customer.CustomerID = SalesOrderHeader.CustomerID
JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
WHERE year(OrderDate) = 2013
) as T
where totalswithdiscount>10000;
Go





