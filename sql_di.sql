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



/*
5. How much have refunds cost us?
*/
select  round(sum(surcharge *  base_fare *  trip_miles),2) total_refunded
from uber_fct_trips
join uber_refunds
on uber_refunds.trip_id = uber_fct_trips.ride_id


/*
29. How many luxury properties?
*/
select count(*) total_luxury_properties from airbnb_dim_property
where property_type LIKE '%Luxury%'





/*
61. The most expensive product per category
*/
with cte as (
select *,
dense_rank() over (partition by category order by price desc) as prank
from amazon_products
)

select category, product_name, price from cte where prank =1 
order by category
