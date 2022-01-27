'''

'''

import csv
from datetime import date
import pandas as pd
from pathlib import Path

# import connection section of the db

file = 'File Splitter\8cf646ca-2d9a-4bb5-892a-5e39c90a1cfa.CSV'

df = pd.read_csv(file)
df = df.fillna('NA')

#df.groupby(['ClientName','CarrierName'])
#print(df.columns)

today = date.today().strftime("%Y%b%d")
Path('File Splitter\\'+today).mkdir(parents=True,exist_ok=True)


destination = 'File Splitter\\'+today+'\\{}_'+today+'.csv'
for i, g in df.groupby(['ClientName','CarrierName','Email']):
     i = '_'.join(i)
     #print(destination.format(i.split('/')[0]))
     g.to_csv(destination.format(i.split('/')[0]), index=False)