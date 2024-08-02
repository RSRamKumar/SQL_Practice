/*
Find the customers who bought both products A and B but did not buy product C
*/

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(100)
);

INSERT INTO Customers (customer_id, name) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Alice Johnson'),
(4, 'Bob Brown'),
(5, 'Charlie Black');

CREATE TABLE Purchases (
    chase_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id CHAR(1)
);

INSERT INTO Purchases (chase_id, customer_id, product_id) VALUES
(1, 1, 'A'),
(2, 1, 'B'),
(3, 2, 'A'),
(4, 2, 'C'),
(5, 3, 'B'),
(6, 3, 'A'),
(7, 4, 'A'),
(8, 4, 'B'),
(9, 5, 'C');


-- Query 1 
select name from Customers where customer_id in (
select customer_id from Purchases
where product_id in ('A' )  
 INTERSECT
SELECT customer_id
FROM Purchases
WHERE product_id IN ('B')
EXCEPT 
SELECT customer_id
FROM Purchases
WHERE product_id IN ('C')
) 
order by name;

-- Query 2 
with cte as (
select customer_id, name,
sum(case when product_id = 'A' then 1 else 0 end) as count_of_a,
sum(case when product_id = 'B' then 1 else 0 end) as count_of_b,
sum(case when product_id = 'C' then 1 else 0 end) as count_of_c
from Purchases
join Customers 
using(customer_id)
group by customer_id, name
)

select name from cte where count_of_a > 0 and count_of_b > 0 and count_of_c = 0 
order by name 
