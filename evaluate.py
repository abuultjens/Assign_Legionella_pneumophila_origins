
import numpy as np
import pandas as pd
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.metrics import f1_score

import sys
DATA = sys.argv[1]
PREFIX = sys.argv[2]

df = pd.read_csv(DATA, header=0, index_col=None)

CM = confusion_matrix(df['ORIGINAL_CLASS'], df['PRED_CLASS'])
np.savetxt("%s_confusion_matrix_dist.csv" % PREFIX, CM, delimiter=",", fmt="%s")

F1 = f1_score(df['ORIGINAL_CLASS'], df['PRED_CLASS'])
F1 = np.array([F1])
np.savetxt("%s_f1_score_dist.csv" % PREFIX, F1, delimiter=",", fmt="%s")

