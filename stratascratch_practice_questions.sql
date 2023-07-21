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

