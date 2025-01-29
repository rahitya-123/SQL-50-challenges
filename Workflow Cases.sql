/*----------------------------------------------------
DDL for Puzzle #8
Workflow Cases
*/----------------------------------------------------

/*-------------------------------------------------------------

You have a report of all workflows and their case results.

A value of 0 signifies the workflow failed, and a value of 1 signifies the workflow passed.

Write an SQL statement that transforms the following table into the expected output.

Input Table:
| Workflow | Case 1 | Case 2 | Case 3 |
|----------|--------|--------|--------|
| Alpha    | 0      | 0      | 0      |
| Bravo    | 0      | 1      | 1      |
| Charlie  | 1      | 0      | 0      |
| Delta    | 0      | 0      | 0      |

Expected Output:
| Workflow | Passed |
|----------|--------|
| Alpha    | 0      |
| Bravo    | 2      |
| Charlie  | 1      |
| Delta    | 0      |


*/------------------------------------------------------------------

DROP TABLE IF EXISTS #WorkflowCases;
GO

CREATE TABLE #WorkflowCases
(
Workflow  VARCHAR(100) PRIMARY KEY,
Case1     INTEGER NOT NULL DEFAULT 0,
Case2     INTEGER NOT NULL DEFAULT 0,
Case3     INTEGER NOT NULL DEFAULT 0
);
GO

INSERT INTO #WorkflowCases (Workflow, Case1, Case2, Case3) VALUES
('Alpha',0,0,0),('Bravo',0,1,1),('Charlie',1,0,0),('Delta',0,0,0);
GO


------Method 1

select Workflow,Case1+Case2+Case3 as passed from #WorkflowCases;
GO


----Method 2

WITH cte_PassFail AS
(
SELECT  Workflow, CaseNumber, PassFail
FROM  #WorkflowCases
 UNPIVOT (PassFail FOR CaseNumber IN (Case1,Case2,Case3)) AS UNPVT
)
SELECT  Workflow,
        SUM(PassFail) AS PassFail
FROM    cte_PassFail
GROUP BY Workflow
ORDER BY 1;
GO

