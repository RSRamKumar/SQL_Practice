/*
Identify users who have made purchases totaling more than 
Rs.5,000 in the last 1 month from the Current Date.
*/

CREATE TABLE purchases (
    purchase_id SERIAL PRIMARY KEY,
    user_id INT,
    date_of_purchase date,
    product_id INT,
    amount_spent DECIMAL(10, 2)
);

INSERT INTO purchases ( user_id, date_of_purchase, product_id, amount_spent)
VALUES
(1, '2024-06-22' , 11, 1000),
(3, '2024-06-24' , 12, 4000),
(1, '2024-06-28 ', 11, 7000),
(2, '2024-06-19 ', 12, 2000),
(3, '2024-06-12 ', 12, 7000),
(1, '2024-05-15 ', 11, 8000),
(3, '2024-05-18 ', 12, 3000),
(1, '2024-05-28 ', 11, 9000),
(2, '2024-06-20 ', 12, 1500),
(3, '2024-06-25 ', 12, 6000);


SELECT user_id, SUM(amount_spent) AS total_spent
FROM purchases
WHERE date_of_purchase >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY user_id
HAVING SUM(amount_spent) > 5000;
