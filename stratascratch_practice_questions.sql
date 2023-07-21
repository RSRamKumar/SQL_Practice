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
select  EXTRACT(YEAR from inspection_date) AS year, count(inspection_id) from sf_restaurant_health_violations
where business_name = 'Roxanne Cafe' 
group by  year 
