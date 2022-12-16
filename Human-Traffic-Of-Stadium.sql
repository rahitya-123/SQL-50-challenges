/* Human-Traffic-Of-Stadium (LeetCode Problem)::

Table: Stadium

| Column Name   | Type    |
| ------------- |  -------|
| id            | int     |
| visit_date    | date    |
| people        | int     |

visit_date is the primary key for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
No two rows will have the same visit_date, and as the id increases, the dates increase as well.

Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.
Return the result table ordered by visit_date in ascending order.
The query result format is in the following example.
Example 1:

Input: 
Stadium table:
| id   | visit_date | people    |
|------|------------|-----------|
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |

Output: 
| id   | visit_date | people    |
|------|------------|-----------|
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
*/

SELECT id
	,visit_date
	,people
FROM (
	SELECT id
		,visit_date
		,LAG(people, 2) OVER (
			ORDER BY id
			) AS people_two_day_before
		,LAG(people, 1) OVER (
			ORDER BY id
			) AS people_one_day_before
		,people
		,LEAD(people, 1) OVER (
			ORDER BY id
			) AS people_one_day_after
		,LEAD(people, 2) OVER (
			ORDER BY id
			) AS people_two_day_after
	FROM stadium
	) A
WHERE (
		people >= 100
		AND people_one_day_after >= 100
		AND people_two_day_after >= 100
		)
	OR (
		people_one_day_before >= 100
		AND people >= 100
		AND people_one_day_after >= 100
		)
	OR (
		people_two_day_before >= 100
		AND people_one_day_before >= 100
		AND people >= 100
		);
