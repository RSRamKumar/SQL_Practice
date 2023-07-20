1. Top store for movie sales
select store, manager from sales_by_store
where  total_sales = (select max(total_sales) from sales_by_store)

2. Top 3 movie categories by sales
SELECT category
FROM sales_by_film_category
order by total_sales desc
LIMIT 3;

3. Top 5 shortest movies
SELECT  title
FROM film
order by length
LIMIT 5;

4. Monthly revenue
SELECT  EXTRACT(YEAR  FROM payment_ts) as year,
EXTRACT(MONTH FROM payment_ts) as month, sum(amount) as revenue
FROM payment
group by year, month
order by year, month

5. Unique customers count by month
SELECT EXTRACT(YEAR  FROM rental_ts) as year,
EXTRACT(MONTH FROM rental_ts) as month,
count(distinct customer_id) as uu_cnt
FROM rental
group by year, month

6. Average customer spend by month
SELECT  EXTRACT(YEAR  FROM payment_ts) as year,
EXTRACT(MONTH FROM payment_ts) as month, sum(amount)/count(distinct customer_id) as avg_spend
FROM payment
group by year, month
order by year, month

7. Customer who rented the most
select customer.first_name, customer.last_name 
from customer join rental using(customer_id)
where EXTRACT(Month from rental.rental_ts) = 5 and EXTRACT(YEAR from rental.rental_ts) = 2020
group by customer.first_name, customer.last_name 
order by count(*) desc limit 1

