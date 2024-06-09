use AdventureWorks2012
go

select * from HumanResources.Employee;
select * from Person.Person;

with MaxVacHrs as
(select MaxVacHrs= MAX(VacationHours)
from HumanResources.Employee)

;