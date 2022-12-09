SELECT EmployeeId
	,LastName
	,totalLateOrders
	,totalOrders
FROM (
	SELECT DISTINCT E.BusinessEntityID AS EmployeeId
		,P.LastName
		,sum(CASE 
				WHEN O.ShipDate >= O.DueDate
					THEN 1
				ELSE 0
				END) OVER (PARTITION BY O.SalesPersonId) AS totallateorders
		,count(O.SalesOrderID) OVER (PARTITION BY O.SalesPersonId) AS totalorders
	FROM Sales.SalesOrderHeader O
	JOIN HumanResources.Employee E ON O.SalesPersonID = E.BusinessEntityID
	JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
	) AS T;