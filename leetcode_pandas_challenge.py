1.  Big Countries
import pandas as pd

def big_countries(world: pd.DataFrame) -> pd.DataFrame:
    big_countries_df  = world[(world['area'] >= 3000000 ) | (world['population']  >= 25000000)]
    return big_countries_df [['name', 'population', 'area']]

2. Recyclable and Low Fat Products
import pandas as pd

def find_products(products: pd.DataFrame) -> pd.DataFrame:
    return products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')][['product_id']]

3. Article Views I
import pandas as pd

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    df = views[views['author_id'] == views['viewer_id']][['author_id']].drop_duplicates().sort_values(by='author_id').rename(columns={'author_id': 'id'})
    return df

4. Invalid Tweets
import pandas as pd

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
      return tweets[tweets['content'].str.len().gt(15)][['tweet_id']]  

5.  Patients With a Condition
import pandas as pd

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
   patients['DIAB1_conditions'] = patients['conditions'].apply(lambda x :  any(i for i  in x.split() if i.startswith('DIAB1')) )
   return patients[patients['DIAB1_conditions']==True] [['patient_id', 'patient_name', 'conditions']]

(or)
import pandas as pd

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    return patients[patients.conditions.str.contains(r'^DIAB1| DIAB1')]
"""
.str transforms each entry in the conditions column to a string.
.contains() looks for the specified pattern in each of those strings.
We can use r' ' to specify pass in a regular expression.
'|' is the syntax for 'or' so it will match either:
'^DIAB1': ^ is an anchor which specifies that it must be matched to the beginning of a string (eg. DIAB100 MYOP)
' DIAB1': the space will ensure that conditions such as 'ACNE DIAB100' will be matched while conditions such as 'TYPE1DIAB100' will be exclude
"""
(or)
import pandas as pd

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    return patients[patients['conditions'].str.contains(' DIAB1') | patients['conditions'].str.startswith('DIAB1')]

6. Calculate Special Bonus
import pandas as pd

def calculate_special_bonus(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus'] = employees.apply(lambda r: r['salary'] if 
    (r['employee_id'] %2 !=0) and  (not  r['name'].startswith('M')) else 0, axis=1)  
    return employees[['employee_id', 'bonus']].sort_values(by='employee_id', ascending=True)

(or)
import pandas as pd

def calculate_special_bonus(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus']  = np.where(
  (~ employees['name'].str.startswith('M')) & (employees['employee_id']%2 !=0) ,  employees['salary'],0)
    return pd.DataFrame(employees[['employee_id','bonus']]).sort_values(by=['employee_id'], ascending=True)

7. Fix Names in a Table
import pandas as pd

def fix_names(users: pd.DataFrame) -> pd.DataFrame:

    users.name = users.name.apply(lambda x: x.capitalize())
    return users.sort_values(by= 'user_id')

8. Department Highest Salary
import pandas as pd

def department_highest_salary(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    df = employee.merge( department, left_on='departmentId', right_on='id',suffixes = ['_emp', '_dep']) \
    .groupby('name_dep'
    ).apply(
        lambda x: x[x['salary'] == x['salary'].max()]
    ).reset_index(drop=True)[
        ['name_dep', 'name_emp', 'salary']
    ].rename(columns={
        'name_dep': 'Department',
        'name_emp': 'Employee',
        'salary': 'Salary',
    })
    return df

(or)
import pandas as pd

def department_highest_salary(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    df = employee.merge(department, how="left", left_on="departmentId", right_on="id")
    df["max_sal"] = df.groupby("name_y")["salary"].transform("max")
    df = df.loc[(df["salary"] == df["max_sal"]),["name_y","name_x","salary"]].rename(columns={"name_y":"Department", "name_x":"Employee","salary":"Salary"})
    return df

9. Rank Scores
import pandas as pd

def order_scores(scores: pd.DataFrame) -> pd.DataFrame:
    scores.sort_values(by = ['score'], inplace=True, ascending=False)
    scores['rank'] = scores.score.rank(method = 'dense', ascending=False )
    return scores[['score', 'rank']]

10.  The Number of Rich Customers
import pandas as pd

def count_rich_customers(store: pd.DataFrame) -> pd.DataFrame:
   return store[store['amount'].gt(500) ][['customer_id']].drop_duplicates() \
    .count().reset_index(drop=True) .to_frame()  \
    .rename(columns={
         0: 'rich_count' 
       
    }) 

(or)
import pandas as pd

def count_rich_customers(store: pd.DataFrame) -> pd.DataFrame:
   return  pd.DataFrame (
       store[store['amount'].gt(500) ][['customer_id']].nunique(),
       columns = ['rich_count']
   )
  
11. Immediate Food Delivery I
import pandas as pd

def food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
   immediate =  len(delivery[delivery.order_date == delivery.customer_pref_delivery_date ])
   total = len(delivery)
   return pd.DataFrame( {'immediate_percentage': [round(immediate / total * 100, 2)]} )

(or)
import pandas as pd

def food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
   immediate = delivery[delivery.order_date == delivery.customer_pref_delivery_date ].size
   total = delivery.size
   print(immediate, total)
   return pd.DataFrame( {'immediate_percentage': [round(immediate / total * 100, 2)]} )
  
12. Game Play Analysis I
import pandas as pd

def game_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    return activity.groupby('player_id')['event_date'].apply(
        lambda x: x.min()
    ).to_frame().reset_index().rename(columns={
         'event_date': 'first_login' 
    })

(or)
import pandas as pd

def game_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    return  activity.groupby(['player_id' ]).apply(lambda x: x[x['event_date'] == x['event_date'].min()]
    ).reset_index(drop=True) [['player_id', 'event_date']].rename(columns={'event_date': 'first_login'})

(or)
import pandas as pd

def game_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    activity['first_login'] = activity.groupby('player_id' )["event_date"].transform("min")
    return activity.loc[activity['event_date'] == activity['first_login'], ['player_id', 'first_login'] ]

(or)
return activity.groupby(
        ['player_id'],
        as_index=False
    ).agg({'event_date' :'min' }).rename(columns={'event_date': 'first_login'})
     

(or)
return activity.groupby(
        ['player_id'],
        as_index=False
    ).agg(first_login = pd.NamedAgg(column="event_date", aggfunc="min")) 

(or)
return activity.groupby('player_id', as_index=False)['event_date'].min().rename(columns = {'event_date': 'first_login'})

13. Number of Unique Subjects Taught by Each Teacher
import pandas as pd

def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:
    return teacher.groupby(by = 'teacher_id',  as_index=False)['subject_id'].apply(lambda x:x.nunique()).rename(columns={'subject_id': 'cnt'})

14. Classes More Than 5 Students
import pandas as pd

def find_classes(courses: pd.DataFrame) -> pd.DataFrame:
    df = courses.groupby(by = ['class'], as_index=False).agg(
        subject_count = pd.NamedAgg(column="class", aggfunc="count")
        )  
    return pd.DataFrame (
     df [df['subject_count'] >= 5]['class'],
       columns = ['class']
   )

(or)
def find_classes(courses: pd.DataFrame) -> pd.DataFrame:
    courses = courses.groupby('class', as_index=False).count()
    return courses[courses.student >= 5].drop(columns=['student'])

15. Customer Placing the Largest Number of Orders
import pandas as pd

def largest_orders(orders: pd.DataFrame) -> pd.DataFrame:
    return orders['customer_number'].mode().to_frame()

16. Delete Duplicate Emails
def delete_duplicate_emails(person: pd.DataFrame):
    person.sort_values(by='id', inplace=True)
    person.drop_duplicates(subset=['email'], inplace=True)

17. Rearrange Products Table
import pandas as pd

def rearrange_products_table(products: pd.DataFrame) -> pd.DataFrame:
        return pd.melt(
        products, id_vars='product_id', var_name='store', value_name='price'
    ).dropna()

18. Daily Leads and Partners
import pandas as pd

def daily_leads_and_partners(daily_sales: pd.DataFrame) -> pd.DataFrame:

    return daily_sales.groupby(by=['date_id', 'make_name'], as_index=False
    ).nunique().rename(columns={
        'lead_id': 'unique_leads',
        'partner_id': 'unique_partners',
    })

(or)
return  daily_sales.groupby(by=['date_id', 'make_name'], as_index=False
    ).agg( unique_leads = pd.NamedAgg(column="lead_id", aggfunc="nunique"),
     unique_partners = pd.NamedAgg(column="partner_id", aggfunc="nunique"))


19. Group Sold Products By The Date
def categorize_products(activities: pd.DataFrame) -> pd.DataFrame:
    return activities.groupby(
        'sell_date',
        as_index = False
    )['product'].agg([
        ('num_sold', 'nunique'),
        ('products', lambda x: ','.join(sorted(x.unique())))
    ]) 

20. Find Total Time Spent by Each Employee
def total_time(employees: pd.DataFrame) -> pd.DataFrame:
    return employees.assign(
        total_time =lambda x: x.out_time - x.in_time 
        ).groupby(['event_day', 'emp_id'], as_index=False) ['total_time'].apply(
            lambda x:x.sum()
            ).rename(columns={'event_day': 'day'})

(or)
return employees.assign(
        time_diff =lambda x: x.out_time - x.in_time 
        ).groupby(['event_day', 'emp_id'], as_index=False).agg(
            total_time = ('time_diff', 'sum')
        ).rename(columns={'event_day': 'day'})

(or)
return employees.assign(
        total_time =lambda x: x.out_time - x.in_time 
        ).groupby(['event_day', 'emp_id'], as_index=False) ['total_time'].sum().rename(columns={'event_day': 'day'})

21. Second Highest Salary
def second_highest_salary(employee: pd.DataFrame) -> pd.DataFrame:
    if employee.salary.nunique() <= 1:
       return pd.DataFrame({'SecondHighestSalary': [None]})
    else:
        return pd.DataFrame({'SecondHighestSalary': 
              [employee.salary.drop_duplicates().sort_values(ascending=False).reset_index(drop=True).loc[1]]})

22. Nth Highest Salary
def nth_highest_salary(employee: pd.DataFrame, N: int) -> pd.DataFrame:
    salary_dict = (employee.salary.drop_duplicates().sort_values(ascending=False).reset_index(drop=True)).to_dict()
    return pd.DataFrame({f'getNthHighestSalary({N})': 
              [ salary_dict.get(N-1) ]})

(or)
   return employee.sort_values('salary', ascending=False).drop_duplicates(subset=['salary']).iloc[N - 1:N][['salary']]

23. Sales Person
def sales_person(sales_person: pd.DataFrame, company: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    merged_df = orders.merge(company ,on = 'com_id').merge(sales_person, on = 'sales_id',  suffixes=( '_company', '_sales')) [['name_company', 'name_sales']]
    red_company_sales =  merged_df [merged_df.name_company == 'RED']['name_sales']
    return pd.DataFrame ({'name': 
            sales_person[~ sales_person['name'].isin(red_company_sales)]['name']
    })

(or)
merged_df = orders.merge(company ,on = 'com_id') 
red_sales_ids = merged_df[merged_df['name'] == 'RED']['sales_id']
result_df = sales_person[~sales_person['sales_id'].isin(red_sales_ids)][['name']]
return result_df

24. Customers Who Never Order
def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    return customers[~ customers.id.isin(orders.customerId)]['name'].to_frame('Customers')
   
(or)
customers[~ customers.id.isin(orders.customerId)][['name']].rename(columns={'name': 'Customers'}

(or)
customers.rename(columns = {'name':'Customers'}, inplace=True)
return customers.loc[~customers.id.isin(orders.customerId), ['Customers']]

25. Actors and Directors Who Cooperated At Least Three Times
def actors_and_directors(actor_director: pd.DataFrame) -> pd.DataFrame:
    df = actor_director.groupby(['actor_id', 'director_id'], as_index = False).count().rename(columns={'timestamp': 'count_value'})
    return df[df.count_value.ge(3)][['actor_id', 'director_id']] 

(or)
 df = actor_director.groupby(['actor_id', 'director_id'], as_index = False).agg(
        count_value=('director_id', 'count') 
    )
return df[df.count_value.ge(3)][['actor_id', 'director_id']]

(or)
df = actor_director.groupby(['actor_id', 'director_id'], as_index = False).size().rename(columns={'size': 'count_value'})
return df[df.count_value.ge(3)][['actor_id', 'director_id']]
    
26. Department Top Three Salaries
def top_three_salaries(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    employee['rank'] = employee.groupby('departmentId').salary.rank(method='dense', ascending=False)
    merged_df = employee.merge(department, left_on = 'departmentId', right_on = 'id',
    suffixes = ('_employee', '_department'))  

    return merged_df[merged_df['rank'].le(3)][['name_department', 'name_employee', 'salary']].rename(
        columns={'name_department': 'Department',
        'name_employee': 'Employee', 'salary':'Salary'})

27. Find Customer Referee
def find_customer_referee(customer: pd.DataFrame) -> pd.DataFrame:
    return customer [customer.referee_id.ne(2) | customer.referee_id.isnull()][['name']]

28. Customers Who Bought All Products
def find_customers(customer: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    unique_product_count = product['product_key'].nunique()
    df = customer.groupby(['customer_id'],as_index=False)['product_key'].agg(
         num_unique_products= 'nunique') 
    return df[df['num_unique_products'].eq(unique_product_count)][['customer_id']]

(or)
unique_product_count = product['product_key'].nunique()
return  customer.groupby(['customer_id'],as_index=False).filter(
        lambda x: x.product_key.nunique() == unique_product_count
    )[['customer_id']].drop_duplicates()

29. List the Products Ordered in a Period
def list_products(products: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    df = products.merge(orders[(orders.order_date.dt.month == 2 ) & (orders.order_date.dt.year == 2020)],
     on = 'product_id').groupby(['product_name'], as_index = False).agg(
         unit = ('unit', 'sum')
     )
    df = df[df['unit'].ge(100)]
    return df

30. Triangle Judgement
def triangle_judgement(triangle: pd.DataFrame) -> pd.DataFrame:
    triangle['triangle'] = triangle.apply(lambda row: 'Yes' if (row['x']+row['y'] > row['z'])
                                                        and
                                                        (row['x']+row['z'] > row['y'])
                                                        and 
                                                        (row['y']+row['z'] > row['x'])
                                                        else 'No', axis=1)
    return triangle
