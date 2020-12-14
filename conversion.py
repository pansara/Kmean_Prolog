import pandas as pd
import numpy as np

df = pd.read_csv('carbonemissiondata.csv')

list_of_lists = df.values.tolist()

my_formatted_list = [[np.round(float(i), 3) for i in nested] for nested in list_of_lists]

print(my_formatted_list)