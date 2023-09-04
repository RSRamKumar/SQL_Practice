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

12. Top Cool Votes
yelp_reviews[yelp_reviews.cool == yelp_reviews.cool.max()][['business_name', 'review_text']]

(or)
yelp_reviews.nlargest(1, 'cool', keep='all')[['business_name', 'review_text']]

(or)
yelp_reviews.sort_values(by = ['cool'],  ascending=False).assign(rank = lambda x: x.cool.rank(method='dense', ascending=False)).nsmallest(1, 'rank', keep='all' )[['business_name', 'review_text']]

13. Count the number of movies that Abigail Breslin nominated for oscar
oscar_nominees[oscar_nominees.nominee.eq('Abigail Breslin')][['movie']].nunique()


14. Find libraries who haven't provided the email address in circulation year 2016 but their notice preference definition is set to email
library_usage [
    library_usage['circulation_active_year'].eq(2016) & 
library_usage['notice_preference_definition'].eq('email') &
library_usage['provided_email_address'].eq(0)
    ]['home_library_code'].unique() 

15. Popularity of Hack
facebook_hack_survey.merge(facebook_employees[['id', 'location']], left_on = 'employee_id',
right_on = 'id').groupby(['location'], as_index=False).agg(
    popularity = ('popularity', 'mean'))

(or)
facebook_hack_survey.merge(facebook_employees[['id', 'location']], left_on = 'employee_id',
right_on = 'id').groupby(['location'], as_index=False)['popularity'].mean()

16. Find the most profitable company in the financial sector of the entire world along with its continent

forbes_global_2010_2014[forbes_global_2010_2014.sector == 'Financials'].sort_values(
    by = ['profits'], ascending=False).nlargest(1, columns = 'profits',keep='all')[['company', 'continent']]

(or)
forbes_global_2010_2014[forbes_global_2010_2014.sector == 'Financials'].groupby(['company', 'continent'],
as_index = False)['profits'].agg('max').nlargest(1, 'profits', keep='all')[['company', 'continent']]

17. Top Businesses With Most Reviews
yelp_business.nlargest(5, keep='all', columns = 'review_count')[['name', 'review_count']]

18. Number of Shipments Per Month
amazon_shipment['shipment_date'] = amazon_shipment['shipment_date'].dt.strftime('%Y-%m')
amazon_shipment.groupby(['shipment_date'], as_index = False)[
    ['shipment_id', 'sub_id']
    ].size().rename(columns={'size': 'count'})

19. Find all posts which were reacted to with a heart
facebook_posts[facebook_posts.post_id.isin(facebook_reactions[facebook_reactions.reaction.eq('heart')]['post_id'])]

20. Number of Workers by Department Starting in April or Later
worker[worker.joining_date.dt.month.ge(4)].groupby('department', as_index=False).size().rename(
    columns = {'size': 'num_workers'}).sort_values(by=['num_workers'], ascending=False)

(or)
worker[worker.joining_date.dt.month.ge(4)].groupby('department', as_index=False).agg(num_workers = ('worker_id', 'count')).sort_values(by=['num_workers'], ascending=False)

21. Customer Details
customers.merge(orders, left_on = 'id', right_on = 'cust_id', how = 'left'
)[
    ['first_name', 'last_name', 'city', 'order_details']
].sort_values(by=['first_name', 'order_details'])

22. Order Details
customers[customers.first_name.isin(['Jill', 'Eva'])].merge(
    orders, left_on='id', right_on = 'cust_id'
    ).sort_values(by=['cust_id'])[
        ['first_name', 'order_date', 'order_details', 'total_order_cost']
        ]

23. Ranking Most Active Guests
airbnb_contacts.groupby(['id_guest'], as_index=False)['n_messages'].sum().sort_values(by=['n_messages'], ascending=False).assign(ranking = lambda x: x.n_messages.rank(method='dense', ascending=False))

24. Finding Updated Records
ms_employee_salary.groupby(['id', 'first_name', 'last_name', 'department_id'], as_index = False)['salary'].max().sort_values(by=['id'])

25. Churro Activity Date
los_angeles_restaurant_health_inspections[los_angeles_restaurant_health_inspections.facility_name.eq('STREET CHURROS') & 
los_angeles_restaurant_health_inspections.score.le(95)][['activity_date', 'pe_description']]

26. Highest Salary In Department
employee['salary_rank']= employee.groupby('department', as_index=False)['salary'].rank(method = 'dense',ascending=False)
employee.nsmallest(1,  'salary_rank', keep='all')[['department','first_name','salary']]

(or)
employee[employee.groupby('department')['salary'].transform('max') == employee['salary']][['department','first_name','salary']]

27. Find the rate of processed tickets for each type
facebook_complaints.groupby(['type'], as_index=False)['processed'].mean()

28. Customer Revenue In March
orders [orders.order_date.dt.month.eq(3) & orders.order_date.dt.year.eq(2019)].groupby(
    ['cust_id'], as_index = False).agg(revenue = ('total_order_cost', 'sum')).sort_values(by=['revenue'], ascending=False)

29. Top 5 States With 5 Star Businesses
yelp_business[yelp_business.stars.eq(5)].groupby(['state'], as_index=False).agg(
   n_businesses= ('business_id', 'count')).nlargest(5, 'n_businesses', keep= 'all').sort_values(
       by = ['n_businesses', 'state'], ascending = [False, True])

30. Flags per Video
user_flags[user_flags.flag_id.notnull()].assign(unique_user = lambda x: x.user_firstname.fillna('') + " "+  x.user_lastname.fillna('')) .groupby(['video_id'], as_index=False)['unique_user'].nunique()

31. Find students with a median writing score
sat_scores [sat_scores.sat_writing == sat_scores.sat_writing.median()]['student_id']

32. Reviews of Categories
yelp_business['categories'] = yelp_business.categories.str.split(';')
yelp_business = yelp_business.explode('categories')

yelp_business.groupby(['categories'], as_index=False).agg(
    total_reviews = ('review_count', 'sum')).sort_values(by=['total_reviews'], ascending=False)

33. Top Percentile Fraud
fraud_score["percentile"] = fraud_score.groupby('state')['fraud_score'].rank(pct=True)
df= fraud_score[fraud_score['percentile']>.95]
result = df[['policy_num','state','claim_cost','fraud_score']]

34. Find how many times each artist appeared on the Spotify ranking list
spotify_worldwide_daily_song_ranking.groupby(['artist'], as_index=False).size().rename(columns = {
    'size' : 'n_occurences'
}).sort_values(by = ['n_occurences'], ascending = False)

(or)
spotify_worldwide_daily_song_ranking['artist'].value_counts().to_frame('n_occurences').reset_index()

35. Highest Energy Consumption
pd.concat([fb_eu_energy, fb_asia_energy, fb_na_energy]).groupby(['date'], as_index=False)['consumption'].sum().nlargest(1, 'consumption', keep='all')

36. Average Salaries
employee[['department', 'first_name','salary']].assign (avg_salary =lambda x:x.groupby(['department'], as_index=False)['salary'].transform('mean'))

37. Top Ranked Songs
spotify_worldwide_daily_song_ranking [spotify_worldwide_daily_song_ranking.position.eq(1)].groupby(['trackname'], as_index=False).size().rename(
    columns = {'size': 'times_top1'}).sort_values('times_top1', ascending=False)

38. Count the number of user events performed by MacBookPro users
playbook_events [playbook_events.device.eq('macbook pro')].groupby(['event_name'], as_index=False).size().rename(
    columns = {'size': 'event_count'}).sort_values('event_count', ascending=False)
(or)
playbook_events.loc[playbook_events['device'] == 'macbook pro', 'event_name'].value_counts().reset_index()

39. Activity Rank
google_gmail_emails.groupby(['from_user'], as_index = False).size().rename(columns = {
    'size': 'total_emails'
}).sort_values(['total_emails', 'from_user'], ascending=[False, True]).assign(rank = lambda x: x.total_emails.rank(method = 'first',
 ascending=False))

40. User with Most Approved Flags
flag_review [flag_review.reviewed_outcome.eq('APPROVED')].merge(user_flags.assign(username = lambda 
x: x.user_firstname + ' ' + x.user_lastname), on = 'flag_id').groupby(['username'], as_index = False).agg(
    count = ('video_id', 'nunique')).nlargest(1,columns='count', keep ='all')['username']

(or)
result = flag_review [flag_review.reviewed_outcome.eq('APPROVED')].merge(user_flags.assign(username = lambda 
x: x.user_firstname + ' ' + x.user_lastname), on = 'flag_id').groupby(['username'], as_index = False)["video_id"].nunique().rename(
    columns = {'video_id': 'ncount'}).assign(rank =lambda x: x.ncount.rank(method="dense", ascending=False))
result.loc[result["rank"] == 1, 'username']

41. Find the base pay for Police Captains
sf_public_salaries[(sf_public_salaries['jobtitle'].str.contains('CAPTAIN', case = False))&(sf_public_salaries['jobtitle'].str.contains
                                                                                           ('POLICE', case = False))][['employeename','basepay']]

28. City With Most Amenities
airbnb_search_details.groupby(['city'], as_index=False).agg(amenities_count =('amenities' ,'count')).nlargest(1, 'amenities_count', keep='all')['city']


