1. Refresher on Aggregates
select 
age, sum(weight) as total_weight
 from cats 
group by age
having sum(weight) >12
order by age
