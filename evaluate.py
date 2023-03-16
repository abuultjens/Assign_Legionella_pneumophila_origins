
import numpy as np
import pandas as pd
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.metrics import f1_score
from sklearn import metrics

import sys
DATA = sys.argv[1]
PREFIX = sys.argv[2]

df = pd.read_csv(DATA, header=0, index_col=None)
# invert the value column
df['VALUE'] = ((df['VALUE'].max())-df['VALUE'])

AUC = metrics.roc_auc_score(df['ORIGINAL_CLASS'], df['VALUE']).reshape(1, -1)
np.savetxt("%s_auc_dist.csv" % PREFIX, AUC, delimiter=",", fmt="%s")

CM = confusion_matrix(df['ORIGINAL_CLASS'], df['PRED_CLASS'])
np.savetxt("%s_confusion_matrix_dist.csv" % PREFIX, CM, delimiter=",", fmt="%s")

F1 = f1_score(df['ORIGINAL_CLASS'], df['PRED_CLASS'])
F1 = np.array([F1])
np.savetxt("%s_f1_score_dist.csv" % PREFIX, F1, delimiter=",", fmt="%s")

### calculate rank
# make arrays
percents = []
percent_obtained = []
total = []
obtained = []
bit = []

df_sorted = df.sort_values('VALUE',ascending=False)

for d in range(1, 1001):
        percents.append((d/1000)*100)

        TOTAL = df['ORIGINAL_CLASS'].value_counts().get(1, 0)
        total.append(TOTAL)
        
        OBTAINED = df_sorted.head(n=(round((int(df['ORIGINAL_CLASS'].count()))*(d/1000))))['ORIGINAL_CLASS'].value_counts().get(1, 0)
        obtained.append(OBTAINED)
        
        percent_obtained.append((OBTAINED/TOTAL)*100)
        
        if ((OBTAINED/TOTAL)*100) == 100:
                BIT="ALL"
        if ((OBTAINED/TOTAL)*100) < 100:
                BIT="NA"
        bit.append(BIT)

RANK = np.vstack([percents, percent_obtained, total, obtained, bit]).T

np.savetxt("%s_RANK_dist.csv" % PREFIX, RANK, delimiter=",", fmt="%s") 

        