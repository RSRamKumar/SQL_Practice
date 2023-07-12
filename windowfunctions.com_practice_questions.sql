1. Refresher on Aggregates
select 
age, sum(weight) as total_weight
 from cats 
group by age
having sum(weight) >12
order by age


2.Running Totals
select  name, sum(weight) over(order by name) running_total_weight
 from cats order by name

3. Partitioned Running Totals
select 
name, breed, sum(weight) over (partition by breed order by name) running_total_weight
 from cats 
