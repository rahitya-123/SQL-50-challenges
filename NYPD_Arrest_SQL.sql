SELECT count(*)
FROM dbo.nyc_arrests_sql;

SELECT TOP 5 *
FROM dbo.nyc_arrests_sql;

/* Which boroughs witness the most number of arrests? */
SELECT arrest_boro
	, COUNT(arrest_boro) AS Number_of_Arrests
FROM dbo.nyc_arrests_sql
GROUP BY arrest_boro
ORDER BY Number_of_Arrests DESC;

/* Which months see the most number of arrests? */
SELECT MONTH(arrest_date) AS Month_Name
	, COUNT(DATEPART(MM, arrest_date)) AS Number_of_Arrests
FROM dbo.nyc_arrests_sql
GROUP BY MONTH(arrest_date)
ORDER BY Number_of_Arrests DESC;

/* Does New York City have more serious crimes (like, felonies) or less serious ones (like, misdemeanors & violations)? */
-- F (Felony) > M (Misdemeanor)> V (Violation)
SELECT law_cat_cd AS Violation_Type
	, COUNT(law_cat_cd) AS Count_of_Violation
FROM dbo.nyc_arrests_sql
GROUP BY law_cat_cd
ORDER BY Count_of_Violation DESC;

/* Misdemeanors happen the most, followed by serious crimes/felonies. Violations are less than 1500. */
/* What kind of crimes are committed by less than 18 years old? */
SELECT law_cat_cd AS Violation_type
	, COUNT(law_cat_cd) AS Count_of_Violation
FROM dbo.nyc_arrests_sql
WHERE age_group = '<18'
GROUP BY law_cat_cd
ORDER BY Count_of_Violation DESC;

/* Minors (less than 18 year olds) are committing more felonies (more than 2.5 times as misdemeanors). 
Something to worry about :( */
/* Felony vs Misdemeanor comparison for all age groups */
SELECT age_group
	, COUNT(CASE 
			WHEN law_cat_cd = 'F'
				THEN 1
			END) AS "Number of felonies"
	, COUNT(CASE 
			WHEN law_cat_cd = 'M'
				THEN 1
			END) AS "Number of misdemeanors"
FROM dbo.nyc_arrests_sql
GROUP BY age_group
ORDER BY 2
	, 3 DESC;
	/* Minors (less than 18 year olds) is the only age group that has more felonies than misdemeanors. 
This is very concerning. */
