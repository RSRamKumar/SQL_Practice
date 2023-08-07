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
  
