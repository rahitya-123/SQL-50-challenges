/*CHALLENGE QUESTION 5: EXPIRED CREDIT CARDS
Difficulty: Intermediate
The Accounting department found instances where expired credit cards were used with sales orders. 
You are asked to examine all credit cards and report the extent of such activity.

PART I
Based on each CreditCardID, find the following:
 CreditCardType
 ExpirationDate
 Last order date
 Number of sales orders with order dates earlier than or equal to the
 card’s expiration date
 Number of sales orders with order dates later than the card’s expiration date
Note:
Adventure Works stores information about a credit card’s expiration year and expiration month. Expiration dates pertain to 
the last day of a card’s expiration month. For example, if the expiration year is 2007 and the expiration month is “4”,
the card’s expiration date will be April 30, 2007.

PART II
Based on CreditCardType, summarize data returned from Part I. Your output
should include the following columns: CreditCardType
 Number of sales orders with order dates earlier than or equal to the
 card’s expiration date
 Number of sales orders with order dates later than the card’s
 expiration date */ --- Part I
DROP TABLE #data;

SELECT N1.CreditCardID
	,N1.CardType
	,ExpDate = EOMONTH(DATEFROMPARTS(N1.ExpYear, N1.ExpMonth, 1))
	,LastOrderDate = CAST(N2.LastOrderDate AS DATE)
	,[Orders<=Exp] = COUNT(DISTINCT N3.SalesOrderID)
	,[Orders>Exp] = COUNT(DISTINCT N4.SalesOrderID)
INTO #data
FROM Sales.CreditCard N1
LEFT JOIN (
	SELECT X1.CreditCardID
		,LastOrderDate = MAX(X1.OrderDate)
	FROM Sales.SalesOrderHeader X1
	GROUP BY X1.CreditCardID
	) N2 ON N1.CreditCardID = N2.CreditCardID
LEFT JOIN Sales.SalesOrderHeader N3 ON N1.CreditCardID = N3.CreditCardID
	AND N3.OrderDate < = EOMONTH(DATEFROMPARTS(N1.ExpYear, N1.ExpMonth, 1))
LEFT JOIN Sales.SalesOrderHeader N4 ON N1.CreditCardID = N4.CreditCardID
	AND N4.OrderDate > EOMONTH(DATEFROMPARTS(N1.ExpYear, N1.ExpMonth, 1))
GROUP BY N1.CreditCardID
	,N1.CardType
	,N2.LastOrderDate
	,N1.ExpYear
	,N1.ExpMonth

SELECT *
FROM #data
ORDER BY [Orders>Exp] DESC

---Part II
SELECT CardType
	,[Orders<=Exp] = SUM([Orders<=Exp])
	,[Orders>Exp] = SUM([Orders>Exp])
FROM #data
GROUP BY CardType;