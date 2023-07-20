1. Top store for movie sales

select store, manager from sales_by_store
where  total_sales = (select max(total_sales) from sales_by_store)
