SELECT id, visit_date, people
FROM (
SELECT id, visit_date,
LAG(people, 2) OVER (ORDER BY id) as people_two_day_before,
LAG(people, 1) OVER (ORDER BY id) as people_one_day_before,
people,
LEAD(people, 1) OVER (ORDER BY id) as people_one_day_after,
LEAD(people, 2) OVER (ORDER BY id) AS people_two_day_after
FROM stadium
) A
WHERE (people >= 100 AND people_one_day_after >= 100 and people_two_day_after >= 100) OR
(people_one_day_before >= 100 and people >= 100 and people_one_day_after >= 100) OR
(people_two_day_before >= 100 and people_one_day_before >= 100 and people >= 100);