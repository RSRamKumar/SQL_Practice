1. Second Highest Salary
select salary from employee order by salary desc offset 1 limit 1


2. Patients With a Condition
select * from patients where conditions LIKE '%DIAB100%'

3. Customers Who Never Order
select namecust from customers where namecust   not in
(select namecust from customers join orders on customers.id = orders.customerid)

--select customers.NameCust as "Customers" from customers where customers.id not in ( select CustomerId from Orders )


4. Marvel Cities
SELECT * FROM city WHERE CountryCode='Marv' AND Population > 100000

5. Fix the Issue
select lower(TRIM(product_name)) as product_name,
TO_CHAR(sale_date::DATE,'YYYY-MM') as sale_date,
count(sale_id) as total
from sales  
GROUP BY 1, 2
ORDER BY 1, 2

SELECT LOWER(TRIM(product_name)) AS product_name, SUBSTRING(CAST(sale_date AS VARCHAR(10)),1,7) AS sale_date, 
COUNT(sale_id) AS total FROM Sales 
GROUP BY LOWER(TRIM(product_name)),SUBSTRING(CAST(sale_date AS VARCHAR(10)),1,7) 
ORDER BY 1,2 ASC

6. Customer Placing the Largest Number Orders
select customer_number from orders
group by customer_number
having count(order_number) >1


7. Employee Bonus
select employee.name, Bonus.bonus from employee 
full join Bonus on Employee.empId = Bonus.empId
where Bonus.bonus < 1000 or Bonus.bonus is NULL

8. Recyclable and Low Fat Products
select product_id from products
where low_fats = 'Y' and recyclable = 'Y'
