1. Count the number of user events performed by MacBookPro users

select event_name, count(event_name) as event_count from playbook_events
where device = 'macbook pro'
group by event_name
order by event_count desc

2. Find all posts which were reacted to with a heart
  
with cte as
(
select facebook_posts.post_id, facebook_posts.poster, facebook_posts.post_text, facebook_posts.post_keywords,
facebook_posts.post_date 
from facebook_posts join facebook_reactions
using(post_id)
where facebook_reactions.reaction = 'heart'
)

select distinct * from cte

(or)
select distinct  facebook_posts.*
from facebook_posts   join facebook_reactions  
on facebook_posts.post_id = facebook_reactions.post_id and facebook_reactions.reaction = 'heart'

3. Find the top 10 ranked songs in 2010
select distinct year_rank, group_name, song_name from billboard_top_100_year_end
where year = '2010'
order by year_rank asc limit 10;

4. Number of violations
SELECT
    EXTRACT(YEAR from inspection_date) AS year, 
    count(inspection_id) AS n_inspections
FROM 
    sf_restaurant_health_violations
WHERE
    business_name = 'Roxanne Cafe' AND violation_id is not null
GROUP BY
    year  

5. Workers With The Highest Salaries
with salary_data as 
(
SELECT
      title.worker_title, max(worker.salary) AS salary
FROM
    worker
JOIN
    title on worker.worker_id = title.worker_ref_id
GROUP BY
    title.worker_title
)

SELECT
    worker_title AS best_paid_title
FROM 
    salary_data
WHERE
    salary = (select max(salary) from salary_data)
ORDER BY
    best_paid_title

  (or)
with salary_rank_data as 
(
SELECT
    worker.salary,
    title.worker_title,
    dense_rank() over (  order by worker.salary desc) AS salary_rank
FROM
    worker
JOIN  
    title
ON
    worker.worker_id = title.worker_ref_id
)
select worker_title from salary_rank_data where salary_rank = 1
    
6. Flags per Video
SELECT 
    video_id, count(DISTINCT CONCAT(COALESCE(user_firstname, ''), COALESCE(user_lastname, '')))
FROM    
    user_flags
WHERE   
    flag_id is NOT NULL
GROUP BY
    video_id
    
7. Highest Salary In Department
with salary_rank_data as 
(
SELECT  
    department, first_name, salary,
    RANK() over (partition by department order by salary desc) salary_rank
FROM    
    employee
)
select department, first_name, salary from salary_rank_data where salary_rank =1

8. Highest Cost Orders
SELECT      
    customers.first_name, orders.order_date, sum(orders.total_order_cost) AS total_order_cost
FROM
    customers
JOIN    
    orders
ON
    customers.id = orders.cust_id and orders.order_date between '2019-02-01' AND '2019-05-01'
GROUP BY
    customers.first_name, orders.order_date
ORDER BY
    total_order_cost desc LIMIT 1

9. Highest Target Under Manager
with target_rank_data as 
(
SELECT
    first_name, target,
    DENSE_RANK() over (order by target desc) AS target_rank
FROM
    salesforce_employees
WHERE
    manager_id = 13
)
SELECT first_name, target FROM target_rank_data WHERE target_rank = 1

(or)
SELECT
    first_name, target 
FROM
    salesforce_employees
WHERE
    target = 
(SELECT
      max(target)
FROM
    salesforce_employees
WHERE
    manager_id = 13
)
AND  manager_id = 13

10. Top Cool Votes
with cool_rank_data as 
(
SELECT
    business_name, review_text, 
    DENSE_RANK() over(order by cool desc) cool_rank
FROM   
    yelp_reviews 
)
select business_name, review_text from cool_rank_data where cool_rank = 1

  (or)
SELECT business_name,
       review_text
FROM yelp_reviews
WHERE cool =
    (SELECT max(cool)
     FROM yelp_reviews)

11. Activity Rank
SELECT
    from_user, count(*) AS total_emails,
    ROW_NUMBER() over (order by  count(*) desc, from_user) AS row_number
FROM
    google_gmail_emails
GROUP BY
    from_user

12. Most Lucrative Products
SELECT
    product_id, sum(cost_in_dollars * units_sold) AS revenue
FROM
    online_orders
WHERE
     date_part('month',date) between 1 and 6
GROUP BY
    product_id
ORDER BY
    revenue desc LIMIT 5

13. Find how many times each artist appeared on the Spotify ranking list
SELECT
    artist, count(*) AS n_occurences
FROM
    spotify_worldwide_daily_song_ranking
GROUP BY
    artist
ORDER BY
    n_occurences desc

14. Unique Users Per Client Per Month
SELECT
    client_id, EXTRACT(month from time_id) AS month,
    count(DISTINCT user_id) AS users_num
FROM
    fact_events
GROUP BY
    client_id, month

15. Reviews of Hotel Arena
SELECT
    hotel_name, reviewer_score, count(*)
FROM
    hotel_reviews 
WHERE
    hotel_name = 'Hotel Arena'
GROUP BY
    hotel_name, reviewer_score

16. Number Of Bathrooms And Bedrooms
SELECT
    city, property_type, AVG(bathrooms) AS n_bathrooms_avg, AVG(bedrooms) AS n_bedrooms_avg
FROM
    airbnb_search_details 
GROUP BY
    city, property_type

17. Finding Updated Records
SELECT
    id, first_name, last_name, department_id, max(salary)
FROM
    ms_employee_salary
GROUP BY
    id, first_name, last_name, department_id
ORDER BY
    id

18. Bikes Last Used
SELECT
    bike_number, max(end_time) AS last_used
FROM
    dc_bikeshare_q1_2012
GROUP BY
    bike_number 
ORDER BY
    last_used desc

19. Number of Shipments Per Month
SELECT
    TO_CHAR(shipment_date, 'YYYY-MM') AS year_month, count((shipment_id + sub_id))
FROM
    amazon_shipment 
GROUP BY
   year_month 

20. Find the most profitable company in the financial sector of the entire world along with its continent
SELECT
    company, continent
FROM
    forbes_global_2010_2014
WHERE
    sector = 'Financials'
ORDER BY
    profits DESC
LIMIT 1

(or)
SELECT company,
       continent
FROM forbes_global_2010_2014
WHERE sector = 'Financials'
  AND profits =
    (SELECT MAX(profits)
     FROM forbes_global_2010_2014
     WHERE sector = 'Financials')

21. Average Salaries
SELECT
    department, first_name, salary, AVG(salary) over (PARTITION BY department)  
FROM
    employee

22. Admin Department Employees Beginning in April or Later
SELECT
    count(*)
FROM
    worker
WHERE
    department = 'Admin' AND EXTRACT(month from joining_date) >= 4

23. Customer Details
SELECT
    customers.first_name, customers.last_name, customers.city, orders.order_details
FROM
    customers
LEFT JOIN
    orders
ON
    customers.id = orders.cust_id
ORDER BY customers.first_name, orders.order_details

24. Order Details
SELECT
    customers.first_name, orders.order_date, orders.order_details, orders.total_order_cost
FROM
    customers
JOIN
    orders
ON
    customers.id = orders.cust_id AND (customers.first_name IN ('Jill', 'Eva') )
ORDER BY
    customers.id 

25. Number of Workers by Department Starting in April or Later
SELECT 
    department, count(worker_id) AS num_workers
FROM
    worker
WHERE
    EXTRACT(month from joining_date) >= 4
GROUP BY
    department
ORDER BY
    num_workers desc

26. Churro Activity Date
SELECT
    activity_date, pe_description
FROM
    los_angeles_restaurant_health_inspections
WHERE
    facility_name = 'STREET CHURROS' AND score < 95

27. Lyft Driver Wages
SELECT 
    * 
FROM
    lyft_drivers 
WHERE
    yearly_salary <= 30000 or yearly_salary >= 70000
    

