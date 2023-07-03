1. Cities With Completed Trades [Robinhood SQL Interview Question]
 
select users.city, count(users.city) from users join trades on trades.user_id = users.user_id where trades.status = 'Completed'
group by users.city  ORDER BY count(users.city) desc limit 3
