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
