/*
Adventure Works will feature one product for the cover of its print catalog. Help
select a list of products for consideration.
Your list should contain products which meet all of the following conditions:
Finished goods (not products utilized to make other products)
List price at least $1,500
At least 150 in inventory
Currently available for sale
Your output should contain the following columns:
ProductID
ProductName
Color
ListPrice
Inventory quantity
*/

USE AdventureWorks2012

GO

SELECT productId=p.productid
	, productName=p.name
	, p.Color
	, p.ListPrice
	, InventoryQuantity=P2.totalquantity
FROM production.Product P
INNER JOIN (
	SELECT productId
		, totalquantity = sum(quantity)
	FROM production.productInventory
	GROUP BY productId
	) P2 ON p.productId = P2.productId
WHERE p.SellEndDate IS NOT NULL
	AND p.listprice >= 1500
	AND p.finishedgoodsflag = 1
	AND p2.totalquantity >= 150;
