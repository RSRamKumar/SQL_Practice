1. Cities With Completed Trades [Robinhood SQL Interview Question]
 
select users.city, count(users.city) from users join trades on trades.user_id = users.user_id where trades.status = 'Completed'
group by users.city  ORDER BY count(users.city) desc limit 3


2. Pharmacy Analytics (Part 1)
SELECT drug, total_sales - cogs as total_profit FROM pharmacy_sales ORDER BY total_profit desc limit 3;

3. Pharmacy Analytics (Part 3)
SELECT manufacturer, CONCAT( '$', ROUND(SUM(total_sales) / 1000000), ' million') as sale FROM pharmacy_sales GROUP BY manufacturer ORDER BY SUM(total_sales) desc ;

4. Patient Support Analysis (Part 1)
SELECT COUNT(*) FROM (SELECT policy_holder_id, count(policy_holder_id) as member_count FROM callers GROUP BY policy_holder_id having count(policy_holder_id) >=3
) AS total_calls;


5. Teams Power Users
SELECT sender_id, count(message_id) as message_count FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8'
  AND EXTRACT(YEAR FROM sent_date) = '2022'
  GROUP BY sender_id  ORDER BY message_count desc
limit 2;


6. Cards Issued Difference
SELECT card_name, max(issued_amount)-min(issued_amount) as difference FROM monthly_cards_issued 
GROUP BY card_name ORDER BY difference desc;

7. Average Post Hiatus (Part 1)
select 	user_id,  MAX(post_date::DATE)-MIN(post_date::DATE) as days_between from posts
where EXTRACT(YEAR FROM post_date) = '2021'
GROUP BY user_id 
HAVING COUNT(post_id) > 1

8. Average Review Ratings
select EXTRACT(MONTH FROM submit_date) as month, product_id, ROUND(avg(stars), 2)
from reviews
GROUP BY EXTRACT(MONTH FROM submit_date), product_id
ORDER BY EXTRACT(MONTH FROM submit_date), product_id

9. Compressed Mean
SELECT ROUND(sum(item_count::Decimal * order_occurrences) / sum(order_occurrences), 1) mean FROM items_per_order;

10. Second Day Confirmation
 select emails.user_id    from emails
 join texts on emails.email_id = texts.email_id
 where texts.signup_action = 'Confirmed' and 
 texts.action_date = emails.signup_date + INTERVAL '1 day'

11. Compressed Mode
SELECT item_count as mode FROM items_per_order
where order_occurrences = (SELECT  max(order_occurrences) from items_per_order)
ORDER BY item_count asc;

12. Odd and Even Measurements
with row_data as (
SELECT ROW_NUMBER () OVER (PARTITION BY DATE(measurement_time) ORDER BY measurement_id),
measurement_value, date(measurement_time) 
FROM measurements 
)

SELECT date, sum(CASE WHEN row_number %2=1 then measurement_value ELSE 0 end) odd_sum,
sum(CASE WHEN row_number %2=0 then measurement_value ELSE 0 end) even_sum
FROM row_data
GROUP BY date

13. Users Third Transaction
 with row_data as (
select *, ROW_NUMBER() over (PARTITION BY user_id ORDER BY transaction_date) row
FROM transactions
)

select user_id, spend, transaction_date FROM row_data
WHERE row =3

14. Highest-Grossing Items
with ranked_data AS (
SELECT  category, product, sum(spend) as "total_spend" ,
RANK() over (PARTITION BY category ORDER BY sum(spend) desc)
FROM product_spend
where EXTRACT(year FROM transaction_date :: date) = '2022'
GROUP BY category, product
)

select category, product, total_spend from ranked_data where rank in (1,2)

 15. Supercloud Customer 
select customer_contracts.customer_id  
from customer_contracts left join products using(product_id)
GROUP BY customer_contracts.customer_id 
HAVING count(DISTINCT products.product_category) = 
(SELECT count(DISTINCT product_category) FROM products)

(or)

with cte as 
(
select customer_contracts.customer_id  , count(DISTINCT product_category) unique_product_category_count
from customer_contracts left join products using(product_id)
GROUP BY customer_contracts.customer_id 
)

SELECT customer_id FROM cte
where unique_product_category_count = (SELECT count(DISTINCT product_category) FROM products)
