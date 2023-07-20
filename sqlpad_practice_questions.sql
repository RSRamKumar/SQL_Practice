1. Top store for movie sales

select store, manager from sales_by_store
where  total_sales = (select max(total_sales) from sales_by_store)

2. Top 3 movie categories by sales
SELECT category
FROM sales_by_film_category
order by total_sales desc
LIMIT 3;
