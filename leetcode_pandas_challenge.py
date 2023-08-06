1.  Big Countries
import pandas as pd

def big_countries(world: pd.DataFrame) -> pd.DataFrame:
    big_countries_df  = world[(world['area'] >= 3000000 ) | (world['population']  >= 25000000)]
    return big_countries_df [['name', 'population', 'area']]

2. Recyclable and Low Fat Products
import pandas as pd

def find_products(products: pd.DataFrame) -> pd.DataFrame:
    return products[(products['low_fats'] == 'Y') & (products['recyclable'] == 'Y')][['product_id']]
