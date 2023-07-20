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

3. Movie Rating
(
select   users.name as results
from movierating join users using(user_id)
group by user_id
order by  count(*) desc, name
limit 1 
)
union  all
(
 select movies.title as results from movierating join movies
 using(movie_id)
 where  EXTRACT(YEAR from movierating.created_at) = '2020' and EXTRACT(MONTH from movierating.created_at) = '2'
 group by movies.title
 order by avg(movierating.rating) desc, movies.title limit 1
)

4. Customer Placing the Largest Number of Orders
select customer_number
from orders
group by customer_number
order by count(*) desc limit 1

5. Sales Person
with cte as 
(
select orders.order_id, company.name as "company", salesPerson.name as "sales" from orders
join company using(com_id)
join salesPerson  using(sales_id)
where company.name = 'RED'
)
select salesperson.name from salesperson where salesperson.name not in (select sales from cte)

6. Actors and Directors Who Cooperated At Least Three Times
select actor_id, director_id from actordirector
group by actor_id, director_id
having count(*) >= 3
 
