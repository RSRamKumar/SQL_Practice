1. Second Highest Salary
select salary from employee order by salary desc offset 1 limit 1


2. Patients With a Condition
select * from patients where conditions LIKE '%DIAB100%'

3. Customers Who Never Order
select namecust from customers where namecust   not in
(select namecust from customers join orders on customers.id = orders.customerid)

--select customers.NameCust as "Customers" from customers where customers.id not in ( select CustomerId from Orders )
