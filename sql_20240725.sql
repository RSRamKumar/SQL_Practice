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


 
select name from Customers where customer_id in (
select customer_id from Purchases
where product_id in ('A' )  
 INTERSECT
SELECT customer_id
FROM Purchases
WHERE product_id IN ('B')
except 
SELECT customer_id
FROM Purchases
WHERE product_id IN ('C')
) 
order by name 
