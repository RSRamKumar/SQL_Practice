/*
59. Whos the most frequent renter?
*/

select  CONCAT(first_name,' ', last_name) renter_name, 
  count(*) total_rentals from airbnb_fct_rentals
  join airbnb_dim_users using(user_id)
group by   first_name,last_name
order by total_rentals desc 
limit 1
