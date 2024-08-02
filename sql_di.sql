/*
59. Whos the most frequent renter?
*/

select  CONCAT(first_name,' ', last_name) renter_name, 
  count(*) total_rentals from airbnb_fct_rentals
  join airbnb_dim_users using(user_id)
group by   first_name,last_name
order by total_rentals desc 
limit 1



/*
6. What is the abandon view rate?
*/
select count(viewer_id) / (select count(*) from tiktok_fct_views ) * 100.0 as abandon_view_rate
from tiktok_fct_views
where viewed_to_completion = 0
