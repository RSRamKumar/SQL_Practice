/*
You are given two tables: Restaurants and Orders. After receiving an order,
each restaurant has 15 minutes to dispatch it. Dispatch times are categorized as follows:

on_time_dispatch: Dispatched within 15 minutes of order received.
late_dispatch: Dispatched between 15 and 20 minutes after order received.
super_late_dispatch: Dispatched after 20 minutes.
Task: Write an SQL query to count the number of dispatched orders in each category for each restaurant.

Link: https://onecompiler.com/postgresql/42myrzn3q
*/

 
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS orders;

CREATE TABLE restaurants (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100)
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES restaurants(id),
  order_time TIMESTAMP WITH TIME ZONE,
  dispatch_time TIMESTAMP WITH TIME ZONE
);

INSERT INTO Restaurants (name) VALUES
('KFC'),
('McDonald'),
('Starbucks'),
('Haldiram'),
('Dominoz');

INSERT INTO Orders (restaurant_id, order_time, dispatch_time) VALUES
(1, '2024-07-23 12:00:00', '2024-07-23 12:14:00'),
(1, '2024-07-23 12:30:00', '2024-07-23 12:48:00'),
(1, '2024-07-23 13:00:00', '2024-07-23 13:16:00'),
(2, '2024-07-23 13:30:00', '2024-07-23 13:50:00'),
(2, '2024-07-23 14:00:00', '2024-07-23 14:14:00'),
(3, '2024-07-23 14:30:00', '2024-07-23 14:49:00'),
(3, '2024-07-23 15:00:00', '2024-07-23 15:16:00'),
(3, '2024-07-23 15:30:00', '2024-07-23 15:40:00'),
(4, '2024-07-23 16:00:00', '2024-07-23 16:10:00'),
(4, '2024-07-23 16:30:00', '2024-07-23 16:50:00'),
(5, '2024-07-23 17:00:00', '2024-07-23 17:25:00'),
(5, '2024-07-23 17:30:00', '2024-07-23 17:55:00'),
(5, '2024-07-23 18:00:00', '2024-07-23 18:19:00'),
(1, '2024-07-23 18:30:00', '2024-07-23 18:44:00'),
(2, '2024-07-23 19:00:00', '2024-07-23 19:13:00');

 with cte as (
   select restaurant_id, name,
case when extract(epoch from dispatch_time - order_time)/60 < 15 then 'on_time_dispatch'
  when extract(epoch from dispatch_time - order_time)/60 between 15 and 20 then 'late_dispatch'
  when extract(epoch from dispatch_time - order_time)/60 > 20 then 'super_late_dispatch'
end as result
from orders  
join Restaurants 
on orders.restaurant_id = Restaurants.id 
 )

 select restaurant_id, name, 
 SUM(case when result='on_time_dispatch' then 1 else 0 end)  as on_time_dispatch,
 SUM(case when result='late_dispatch' then 1 else 0 end)  as late_dispatch,
 SUM(case when result='super_late_dispatch' then 1 else 0 end)  as super_late_dispatch
 from cte
 group by restaurant_id, name
 
 
