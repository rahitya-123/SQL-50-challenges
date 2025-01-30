USE AdventureWorks2012
GO

WITH Data
AS (
	SELECT BusinessEntityID
		, PayRateNumber = ROW_NUMBER() OVER (
			PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC
			)
		, RateChangeDate
		, Rate
	FROM HumanResources.EmployeePayHistory
	)
SELECT N1.BusinessEntityID
	, RatePrior = N2.Rate
	, LatestRate = N1.Rate
	, PercentChange = CONVERT(VARCHAR(10), (N1.Rate - N2.Rate) / N2.Rate * 100) + '%'
FROM Data N1
LEFT JOIN Data N2 ON N1.BusinessEntityID = N2.BusinessEntityID
	AND N2.PayRateNumber = 2
WHERE N1.PayRateNumber = 1;