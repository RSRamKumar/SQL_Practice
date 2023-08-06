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
