1. Classes More Than 5 Students
select class 
from courses
group by class
having count(*) >= 5

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

7. Game Play Analysis I
with login_rank_data as 
(
SELECT
    player_id, event_date AS first_login,
    RANK() over (partition by player_id order by event_date) login_rank
FROM    
    activity
)

select player_id, first_login from login_rank_data where login_rank=1

 (or)
SELECT
    player_id,
    min(event_date) AS first_login
FROM
    activity
GROUP BY
    player_id
 
8. Employees Earning More Than Their Managers
select e1.name AS Employee
from employee e1 
join employee e2
on e1.managerId  = e2.id and e1.salary > e2.salary

9. Customers Who Never Order
select name AS Customers from customers where id not in (select customerid from orders)

10. Department Highest Salary
with salary_rank_data as 
(
SELECT
    Department.name AS "Department", Employee.name AS "Employee" , Employee.Salary,
    dense_rank() over (partition by Department.name order by Employee.Salary desc) AS salary_rank
FROM
    Department
JOIN
    Employee
ON
    Employee.departmentID = Department.id
)

SELECT Department, Employee, Salary FROM salary_rank_data where salary_rank = 1

10. Immediate Food Delivery II
with delivery_rank_data as 
(
SELECT
    *, rank() over (partition by customer_id order by order_date) AS delivery_rank
FROM
    delivery
)

SELECT
round(sum(CASE WHEN order_date = customer_pref_delivery_date  then 1.0 else 0 end )/
 ( count(*) ) * 100,2)  
 AS immediate_percentage 
from delivery_rank_data where delivery_rank = 1 

(or)

Select 
    round(sum(CASE WHEN order_date = customer_pref_delivery_date  then 1.0 else 0 end )/
   ( count(*) ) * 100,2)  AS immediate_percentage 
from Delivery
where (customer_id, order_date) in (
  Select customer_id, min(order_date) 
  from Delivery
  group by customer_id
)

11. Monthly Transactions I
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
country , count(*) AS trans_count ,
sum(case WHEN state= 'approved' then 1.0 else 0 end) AS approved_count,
sum(amount) AS trans_total_amount ,
sum(case WHEN state = 'approved' then amount else 0 end) AS approved_total_amount 
FROM Transactions 
group by month, country

(or)
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
country , count(*) AS trans_count ,
sum(state="approved") as approved_count,
sum(amount) AS trans_total_amount ,
sum(if(state = 'approved', amount, 0)) AS approved_total_amount 
FROM Transactions 
group by month, country

12. Daily Leads and Partners
SELECT
    date_id, make_name,
    count(DISTINCT lead_id) AS unique_leads , count(DISTINCT partner_id) AS unique_partners 
FROM
    DailySales 
GROUP BY
    date_id, make_name

13. Big Countries
SELECT
    name, population, area
FROM
    world
WHERE
    area >= 3000000 or population >= 25000000

14.  Recyclable and Low Fat Products
SELECT
    product_id
FROM
    products
WHERE
    low_fats = 'Y' and recyclable = 'Y'

15. Article Views I
SELECT
   DISTINCT author_id AS id
FROM
    views
WHERE
    author_id = viewer_id
ORDER BY
    author_id

16. Invalid Tweets
SELECT
    tweet_id
FROM
    tweets
WHERE
    length(content) >  15

17. Calculate Special Bonus
SELECT
    employee_id, if(employee_id %2 != 0 and SUBSTRING(name,1,1) !='M' , salary, 0) AS bonus
FROM
    employees
ORDER BY   
    employee_id

18. Fix Names in a Table
SELECT
    user_id, CONCAT(UPPER(LEFT(name, 1)),LOWER(SUBSTRING(name, 2))) AS name
FROM
    users
ORDER BY
    user_id

19. Patients With a Condition
SELECT * FROM PATIENTS WHERE CONDITIONS LIKE '% DIAB1%' OR CONDITIONS LIKE 'DIAB1%';

20. Department Highest Salary
with salary_data as 
(
SELECT
       Department.name AS "Department"  , Employee.name  AS "Employee", Employee.salary AS "Salary",
      max(Employee.Salary) over(partition by Department.name) AS max_salary
FROM
    Department
JOIN
    Employee
ON
    Employee.departmentID = Department.id
GROUP BY
    Department.name, Employee.name
)

SELECT 
     Department , Employee  , Salary
FROM
    salary_data
WHERE
    Salary = max_salary

21. Rank Scores
SELECT
    score,
    dense_rank() over( order by score desc)  AS 'rank'
FROM
    scores

22.
DELETE p1
  FROM Person p1,
       Person p2
 WHERE p1.Email = p2.Email
   AND p1.Id > p2.Id
"""
Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+

=> From Person p1, Person p2 : it would look like:
1|john@example.com|1|john@example.com
1|john@example.com|2|bob@example.com 
1|john@example.com|3|john@example.com

2|bob@example.com|1|john@example.com
2|bob@example.com|2|bob@example.com
2|bob@example.com|3|john@example.com

3|john@example.com|1|john@example.com
3|john@example.com|2|bob@example.com
3|john@example.com|3|john@example.com

=> From Person p1, Person p2 where p1.email=p2.email and p1.id>p2.id:
It would look like:
3|john@example.com|1|john@example.com

Now delete this row's matching row in p1 using p1:  delete p1
"""

23. The Number of Rich Customers
SELECT
    count(DISTINCT customer_id) AS rich_count 
FROM
    store
WHERE
    amount > 500

24. Immediate Food Delivery I
with immediate_delivery_data as 
(
SELECT
    count(*) as immediate_delivery_count
FROM
    Delivery 
WHERE
    order_date = customer_pref_delivery_date
)

select round((immediate_delivery_count / (select count(*) from delivery))*100,2) AS immediate_percentage 
 from immediate_delivery_data

(or)
SELECT round(100 * sum(order_date = customer_pref_delivery_date) / count(*), 2) AS immediate_percentage
  FROM Delivery

25. Find Total Time Spent by Each Employee
SELECT
    event_day AS day, emp_id,
    sum(out_time - in_time) as total_time
FROM
    employees
GROUP BY
    day, emp_id

26. Number of Unique Subjects Taught by Each Teacher
SELECT
    teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM
    teacher
GROUP BY
    teacher_id

27. Group Sold Products By The Date
SELECT sell_date,
       count(DISTINCT product) AS num_sold,
       group_concat(DISTINCT product ORDER BY product ASC SEPARATOR ',') products
 FROM 
     activities
 GROUP BY 
     sell_date
 ORDER BY 
     sell_date

28. Combine Two Tables
SELECT
    person.firstName, person.lastName, address.city, address.state
FROM
    person 
LEFT JOIN
    address USING(personid)

29. Duplicate Emails
SELECT
  person.email
FROM
  person
GROUP BY
  person.email
HAVING
  count(person.email) > 1
