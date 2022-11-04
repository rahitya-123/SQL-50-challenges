With Sales_FY(SalesPersonID, FY, FQ, FQSales) AS
(
	SELECT
		SalesPersonID,
		DATEPART (YEAR, DATEADD (MONTH, -6, OrderDate)),
		DATEPART (QUARTER, DATEADD (MONTH, -6, OrderDate)),
		FQSales = SUM (Subtotal)
	FROM Sales.SalesOrderHeader
	WHERE OnlineOrderFlag = 0
	GROUP BY 
		SalesPersonID, 
		DATEPART (YEAR, DATEADD (MONTH, -6, OrderDate)), 
		DATEPART (QUARTER,DATEADD (MONTH, -6, OrderDate))
)
SELECT
	P.LastName,
	S1.*,
	S2.FQSales AS SalesSameFQLastYr,
	S1.FQSales - S2.FQSales AS Change,
	((S1.FQSales - S2.FQSales)/ S2.FQSales) * 100 AS [%Change]
FROM Sales_FY S1
	LEFT JOIN Sales_FY S2
		ON S1.SalesPersonID = S2.SalesPersonID
		AND S1.FQ = S2.FQ
		AND S1.FY-1 = S2.FY
	INNER JOIN Person.Person P
		ON S1.SalesPersonID = P.BusinessEntityID
WHERE S1.FY = 2012
ORDER BY SalesPersonID, FY DESC, FQ DESC;
