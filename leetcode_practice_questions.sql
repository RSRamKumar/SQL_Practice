1. Classes More Than 5 Students
select class 
from courses
group by class
having count(class) >= 5

2. Employee Bonus
select  name,   bonus.bonus
from employee
left join bonus using(empid)
where bonus<1000 or bonus.bonus is null
