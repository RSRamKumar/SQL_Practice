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

11. Find the Missing IDs
--SELECT generate_series(1, 10) AS number;

select generate_series(min(customer_id), max(customer_id)) as ids from customers except
select customer_id from customers

12. Director's Actor
	
select actor_id, director_id,  count(*)  from actordirector
group by actor_id , director_id
having count(*) >=3

13. Ad-Free Sessions / Spotify Sessions
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
select  department.dept_name, count(student.student_id) as student_number from student right join department
on student.dept_id = department.dept_id
group by department.dept_name
order by student_number desc

18*. Maximum Transaction Each Day
select transaction_id from transactions where (DATE(day), amount) in
(
select DATE(day) as day , max(amount) as max_amt from transactions
group by 1  )
order by 1

19. Warehouse Manager
select warehouse.name as warehouse_name,  sum(products.width*products.length*products.height * warehouse.units)  as volume
from warehouse join products on warehouse.product_id = products.product_id
group by warehouse.name 

20. Article
select viewer_id  as id from views
where author_id != viewer_id
group by viewer_id, view_date
having count(view_date) >1
order by viewer_id 

21. Product's Worth Over Invoices
	
select name, sum(rest) as rest, sum(paid) as paid, sum(canceled) as canceled, sum(refunded) as refunded from product
join invoice on product.product_id = invoice.product_id
group by name
order by name

22. Fix Names in a Table
select user_id, CONCAT(UPPER(SUBSTRING (name,1,1)),
LOWER(SUBSTRING(name,2))) AS name  from users

23. The Latest Login in 2020
select user_id, max(time_stamp) AS last_stamp from logins
where EXTRACT(YEAR from time_stamp) = '2020'
group by user_id  

24. Queries Quality and Percentage
select query_name,  round(avg(rating/position),2)  quality from queries
group by query_name


25. Sellers With No Sales
select seller.seller_name from seller where seller.seller_name not in (
select  seller.seller_name from orders 
join seller using(seller_id)
where EXTRACT(year from orders.sale_date) = '2020')


24. Top Travellers
select   users.name, COALESCE(sum(rides.distance),0) as travelled_distance from users left join rides
on users.id = rides.user_id
group by users.name
order by travelled_distance desc, users.name 

25. Customers Who Never Order
select customers.namecust as "Customers" from Customers where  customers.namecust not in
(select customers.namecust from customers join orders on 
 customers.id = orders.customerid)
 (or)
 select customers.namecust AS "Customers" from customers where
  customers.id not in (select customerid from orders)

26. IMDb Max Weighted Rating
select   genre.genre, MAX( (IMDB.rating + IMDB.metacritic/10)/2.0) as weighted_rating from IMDB   
join genre on imdb.movie_id = genre.movie_id
where IMDB.title  LIKE '%(2014)%'
group by genre 
having genre is NOT  NULL
order by genre 

27. Sales Executive
 select salesperson.name from salesperson where salesperson.name not in
 (
 select   salesperson.name  from salesperson join orders
 on salesperson.sales_id = orders.sales_id
 join company on orders.com_id = company.com_id
 where company.name = 'RED'
 )
 
28. Immediate Food Delivery
with ranked_data AS (
     select * ,
 RANK () OVER ( 
		PARTITION BY customer_id
		ORDER BY order_date  
	) deliver_date_rank
 from delivery
 )
 
 SELECT round((sum(case when order_date = customer_pref_delivery_date then 1.0  else 0 end  )/count(*))*100.0,2)  AS immediate_percentage
FROM ranked_data
WHERE deliver_date_rank = 1;
 
29. Department Highest Salary
 WITH ranked_data AS (
select employee.name AS "Employee", employee.salary AS "Salary", department.name AS "Department",
RANK () over (Partition by department.name order by employee.salary desc) employee_salary_rank
from employee
join department on employee.departmentid = department.id
) 

SELECT "Department","Employee"   , "Salary"   
FROM ranked_data
WHERE employee_salary_rank = 1;

30. Department Top Three Salaries
with ranked_data as
(

select employee.name AS "Employee", employee.salary AS "Salary", department.name AS "Department",
  DENSE_RANK () over (Partition by department.name order by employee.salary desc) salary_rank

 from employee
join department on employee.departmentid = department.id

)

select "Department", "Employee", "Salary"
from ranked_data
where salary_rank  in (1,2,3)
