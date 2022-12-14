USE AdventureWorks2012;
GO

SELECT DISTINCT P.LastName
	,P.FirstName
FROM Person.Person P
JOIN HumanResources.Employee E ON P.BusinessEntityID = E.BusinessEntityID
WHERE E.BusinessEntityID IN (
		SELECT SalesPersonID
		FROM Sales.SalesOrderHeader
		WHERE SalesOrderID IN (
				SELECT SalesOrderID
				FROM Sales.SalesOrderDetail
				WHERE ProductID IN (
						SELECT ProductID AS productname
						FROM Production.Product p
						WHERE ProductNumber = 'BK-M68B-42'
						)
				)
		);
GO

