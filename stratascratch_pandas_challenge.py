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
