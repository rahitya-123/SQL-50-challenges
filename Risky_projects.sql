/*
RISKY_PROJECT [LINKEDIN INTERVIEW QUESTION]

Identify projects that are at risk for going overbudget. A project is considered to be overbudget if the cost of all employees 
assigned to the project is greater than the budget of the project.

You'll need to prorate the cost of the employees to the duration of the project. For example, if the budget for a project that 
takes half a year to complete is $10K, then the total half-year salary of all employees assigned to the project should not exceed
$10K. Salary is defined on a yearly basis, so be careful how to calculate salaries for the projects that last less or more than
one year.

Output a list of projects that are overbudget with their project name, project budget, and prorated total employee expense (rounded to the next dollar amount).

HINT: to make it simpler, consider that all years have 365 days. You don't need to think about the leap years.

Tables: linkedin_projects, linkedin_emp_projects, linkedin_employees

All required columns and the first 5 rows of the solution are shown

EXPECTED OUTPUT:
title		budget	prorated_employee_expense
Project1	29498	36293
Project11	11705	31606
Project12	10468	62843
Project14	30014	36774
Project16	19922	21875

linkedin_projects Preview
id:int
title:varchar
budget:int
start_date:datetime
end_date:datetime

linkedin_emp_projects Preview
emp_id:int
project_id:int

linkedin_employees Preview
id: int
first_name:varchar
last_name:varchar
salary:int

*/



WITH cte
AS (
	SELECT output1.title
		, output1.budget
		, ceiling(sum(le.salary * output1.no_of_days * 1.0 / 365)) AS prorated_employee_expense
	FROM (
		SELECT lp.id
			, lp.title
			, lp.budget
			, lep.emp_id
			, datediff(dd, lp.start_date, lp.end_date) AS no_of_days
		FROM linkedin_projects lp
		LEFT JOIN linkedin_emp_projects lep ON lp.id = lep.project_id
		) AS output1
	LEFT JOIN linkedin_employees le ON output1.emp_id = le.id
	GROUP BY output1.title
		, output1.budget
		, output1.no_of_days
	)
SELECT *
FROM cte
WHERE budget < prorated_employee_expense;