1. Second Highest Salary
select salary from employee order by salary desc offset 1 limit 1


2. Patients With a Condition
select * from patients where conditions LIKE '%DIAB100%'
