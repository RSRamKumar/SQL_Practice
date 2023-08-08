1. Admin Department Employees Beginning in April or Later
worker[(worker.department == 'Admin') & (worker.joining_date.dt.month >= 4)] 

2. Reviews of Hotel Arena
hotel_reviews[ hotel_reviews['hotel_name'] == 'Hotel Arena'][
    ['hotel_name', 'reviewer_score']
    ].groupby(by=['reviewer_score','hotel_name'],  as_index=False) .agg(
        n_reviews = pd.NamedAgg(column="reviewer_score", aggfunc="count"))

(or)
hotel_reviews[ hotel_reviews['hotel_name'] == 'Hotel Arena'][
    ['hotel_name', 'reviewer_score']
    ].groupby(by=['reviewer_score','hotel_name'],  as_index=False) .size().rename(columns={'size': 'n_reviews'})

3. Most Lucrative Products
df = online_orders[
    (online_orders.date.dt.year == 2022) & (online_orders.date.dt.month <=6 )
    ]
df ['total_cost'] = df.cost_in_dollars * df.units_sold
df.groupby(['product_id'], as_index= False)['total_cost'].sum().nlargest(5, 'total_cost')

(or)
online_orders[
    (online_orders.date.dt.year == 2022) & (online_orders.date.dt.month <=6 )
    ].assign(total_cost = lambda x: x.cost_in_dollars * x.units_sold).groupby(['product_id'], as_index= False)['total_cost'].sum().nlargest(5, 'total_cost')
