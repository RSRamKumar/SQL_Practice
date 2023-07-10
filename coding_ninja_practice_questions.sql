1. Second Highest Salary
select salary from employee order by salary desc offset 1 limit 1


2. Patients With a Condition
select * from patients where conditions LIKE '%DIAB100%'

3. Customers Who Never Order
select namecust from customers where namecust   not in
(select namecust from customers join orders on customers.id = orders.customerid)

--select customers.NameCust as "Customers" from customers where customers.id not in ( select CustomerId from Orders )


4. Marvel Cities
SELECT * FROM city WHERE CountryCode='Marv' AND Population > 100000

5. Fix the Issue
select lower(TRIM(product_name)) as product_name,
TO_CHAR(sale_date::DATE,'YYYY-MM') as sale_date,
count(sale_id) as total
from sales  
GROUP BY 1, 2
ORDER BY 1, 2

SELECT LOWER(TRIM(product_name)) AS product_name, SUBSTRING(CAST(sale_date AS VARCHAR(10)),1,7) AS sale_date, 
COUNT(sale_id) AS total FROM Sales 
GROUP BY LOWER(TRIM(product_name)),SUBSTRING(CAST(sale_date AS VARCHAR(10)),1,7) 
ORDER BY 1,2 ASC

6. Customer Placing the Largest Number Orders
select customer_number from orders
group by customer_number
having count(order_number) >1


7. Employee Bonus
select employee.name, Bonus.bonus from employee 
full join Bonus on Employee.empId = Bonus.empId
where Bonus.bonus < 1000 or Bonus.bonus is NULL

8. Recyclable and Low Fat Products
select product_id from products
where low_fats = 'Y' and recyclable = 'Y'

9. Classes with more than 5 students
select class  from courses
group by class
having count(class) >=2


10. Biggest Single Number
select max(num) as num from my_numbers where num in
(select num from my_numbers
group by num 
having count(num) =1
)

(or)
select num from my_numbers
group by num 
having count(num) =1
ORDER BY num DESC  limit 1

10. Not Boring Movies
select * from cinema
where id %2=1 and description  NOT LIKE '%boring%'
order by rating desc

11.
--SELECT generate_series(1, 10) AS number;

select generate_series(min(customer_id), max(customer_id)) as ids from customers except
select customer_id from customers

12. Director's Actor
  
select actor_id, director_id,  count(*)  from actordirector
group by actor_id , director_id
having count(*) >=3

13. Ad-Free Sessions
select   session_id   from playback left  join ads on playback.customer_id = ads.customer_id
and ads.timestamp   between playback.start_time and playback.end_time  WHERE Ads.customer_id IS NULL

or 
select session_id from playback where session_id not in 
(
select (session_id) from playback left  join ads on playback.customer_id = ads.customer_id
where ads.timestamp  between playback.start_time and playback.end_time )

14. Triangle Judgement
select x,y,z ,
case when x+y > z and x+z >y and y+z > x then 'Yes' else 'No' end as triangle
from triangle


15. Rank Scores
SELECT
	score ,
	DENSE_RANK() OVER (
		ORDER BY score desc
	) "Rank" 
FROM
	scores;

16. IMDb Genre
select   genre.genre, max(earning.Domestic + earning.Worldwide - IMDb.Budget) as net_profit from IMDb join genre
on IMDb.movie_id = genre.movie_id
join earning on IMDb.movie_id = earning.movie_id
where IMDb.title LIKE '%(2012)%'
group by  genre.genre
having genre.genre is NOT NULL
order by genre.genre

17. Count Student Number in Departments
select  department.dept_name, count(student.student_id) as student_number from student full join department
on student.dept_id = department.dept_id
group by department.dept_name
order by student_number desc
