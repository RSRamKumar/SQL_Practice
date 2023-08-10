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

4. Bikes Last Used
dc_bikeshare_q1_2012[
    ['bike_number', 'end_time']
    ].groupby(
        ['bike_number'],
        as_index=False
        )['end_time'].max().rename(columns={'end_time': 'last_used'}).sort_values(by=['last_used'], ascending=False)

(or)
dc_bikeshare_q1_2012[
    ['bike_number', 'end_time']
    ].groupby(
        ['bike_number'],
        as_index=False
        )['end_time'] .agg({'end_time':'max'}).sort_values("end_time",ascending=False)

(or)
dc_bikeshare_q1_2012[
    ['bike_number', 'end_time']
    ].groupby(
        ['bike_number'],
        as_index=False
        ).agg({'end_time':'max'}).sort_values("end_time",ascending=False)

5. Number Of Bathrooms And Bedrooms
airbnb_search_details.groupby(
    ['city', 'property_type'],
    as_index = False
    ).agg(
        {
            'bathrooms': 'mean',
            'bedrooms': 'mean'
        }
        ).rename(columns={'bathrooms': 'n_bedrooms_avg', 'bedrooms': 'n_bathrooms_avg' })

(or)
airbnb_search_details.groupby(
    ['city', 'property_type'],
    as_index = False
    )['bedrooms','bathrooms'].mean() .rename(columns={'bathrooms': 'n_bedrooms_avg', 'bedrooms': 'n_bathrooms_avg' })

6. Unique Users Per Client Per Month
fact_events.assign(
    month = lambda x: x.time_id.dt.month
    ).groupby(['client_id', 'month'], as_index=False)['user_id'].nunique()

(or)
fact_events.assign(
    month = lambda x: x.time_id.dt.month
    ).groupby(['client_id', 'month'], as_index=False).agg({'user_id': 'nunique'}) # pd.Series.nunique

7. Find the top 10 ranked songs in 2010
billboard_top_100_year_end[
    (billboard_top_100_year_end.year == 2010) & (billboard_top_100_year_end['year_rank'].between(1,10))
    ] [
        ['year_rank', 'group_name', 'song_name' ]
        ].drop_duplicates()

8. Workers With The Highest Salaries
merged_df = pd.merge(worker, title, left_on = 'worker_id', right_on = 'worker_ref_id'
) 
max_salary = merged_df[merged_df["salary"] == merged_df["salary"].max()][["worker_title"]].rename(columns={"worker_title": "best_paid_title"})

(or)
worker[worker.salary == worker.salary.max()].merge( title, left_on = 'worker_id', right_on = 'worker_ref_id'
) [['worker_title']].rename(columns={"worker_title": "best_paid_title"})

(or)

merged_df = pd.merge(worker, title, left_on = 'worker_id', right_on = 'worker_ref_id'
) .sort_values(by = ['salary'],  ascending=False).assign(
    salary_rank = lambda x: x.salary.rank(method = 'dense', ascending = False)
    )   [['worker_title', 'salary_rank']]
merged_df[merged_df['salary_rank'].eq(1)]['worker_title']

(or)
pd.merge(worker, title, left_on = 'worker_id', right_on = 'worker_ref_id'
) .sort_values(by = ['salary'],  ascending=False).assign(
    salary_rank = lambda x: x.salary.rank(method = 'dense', ascending = False)
    ).nsmallest(1,  'salary_rank', keep= 'all')['worker_title']

9. Highest Cost Orders
orders[
    (orders['order_date'] > '2019-02-01') & (orders['order_date'] <= '2019-05-01')
    ].merge(
        customers, left_on = 'cust_id', right_on = 'id'
        ).groupby(['first_name', 'order_date'], as_index=False).agg( {'total_order_cost' : 'sum'}).nlargest(1,'total_order_cost', keep = 'all' )

(or)
orders[
    (orders['order_date'] > '2019-02-01') & (orders['order_date'] <= '2019-05-01')
    ].merge(
        customers, left_on = 'cust_id', right_on = 'id'
        ).groupby(['first_name', 'order_date'], as_index=False).agg(max_order_cost =('total_order_cost' ,'sum')
        ).nlargest(1,'max_order_cost', keep = 'all' )
(or)
orders[
    (orders['order_date'] > '2019-02-01') & (orders['order_date'] <= '2019-05-01')
    ].merge(
        customers, left_on = 'cust_id', right_on = 'id'
        ).groupby(['first_name', 'order_date'], as_index=False)['total_order_cost'].sum().nlargest(1,'total_order_cost' , keep = 'all')

10. Lyft Driver Wages
lyft_drivers[(lyft_drivers.yearly_salary <= 30000) or (lyft_drivers.yearly_salary >= 70000)]
        
11. Number Of Units Per Nationality
airbnb_hosts[
    airbnb_hosts['age'].lt(30)
    ].merge( airbnb_units[airbnb_units['unit_type'] == 'Apartment'], 
    on = 'host_id').groupby(['nationality'], as_index=False).agg(
       apartment_count = ('unit_id', 'nunique') ). sort_values(by=['apartment_count'], ascending=False)
 
