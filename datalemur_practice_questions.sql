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
