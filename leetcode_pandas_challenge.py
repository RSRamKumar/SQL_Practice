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
