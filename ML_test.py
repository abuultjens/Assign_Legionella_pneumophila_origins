
# load
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.utils import shuffle
from sklearn import metrics

from sklearn.metrics import f1_score
from sklearn.metrics import recall_score
from sklearn.metrics import precision_score
from sklearn.metrics import accuracy_score
from sklearn.metrics import roc_auc_score
from sklearn.metrics import roc_curve
from sklearn.metrics import classification_report, confusion_matrix

# generate random prefix for all tmp files
import string
import random
N = 7
RAND = ''.join(random.choices(string.ascii_uppercase + string.digits, k = N))

# load pos args
import sys
TRAIN = sys.argv[1]
TRAIN_TARGET = sys.argv[2]
TEST = sys.argv[3]
TEST_TARGET = sys.argv[4]
PREFIX = sys.argv[5]
K = sys.argv[6]
if K == 'all':
	K = str(K)
else:    
	K = int(K)
MODEL = sys.argv[7]
weight_for_0 = float(sys.argv[8])
weight_for_1 = float(sys.argv[9])

# define train datasets
train_tr = pd.read_csv(TRAIN, header=0, index_col=0)
train_all = train_tr.transpose() 
train_target_all = pd.read_csv(TRAIN_TARGET, header=0, index_col=0)

# define test datasets
test_tr = pd.read_csv(TEST, header=0, index_col=0)
test_all = test_tr.transpose() 
test_all = test_all[train_all.columns]
test_target_all = pd.read_csv(TEST_TARGET, header=0, index_col=0)

# determine number of observations per class for the datasets
train_pos = np.count_nonzero(train_target_all.values.ravel() == 1)
train_neg = np.count_nonzero(train_target_all.values.ravel() == 0)
test_pos = np.count_nonzero(test_target_all.values.ravel() == 1)
test_neg = np.count_nonzero(test_target_all.values.ravel() == 0)

total = train_pos + train_neg

class_weight = {0: weight_for_0, 1: weight_for_1}

print('Weight for class 0: {:.2f}'.format(weight_for_0))
print('Weight for class 1: {:.2f}'.format(weight_for_1))

test_pos_array = np.array([test_pos])
test_neg_array = np.array([test_neg])

#------------------------------------------------------------------------------
# define the model 
         
         
if MODEL == "LGR":
	from sklearn.linear_model import LogisticRegression
	estimator=LogisticRegression(random_state = 42, class_weight=class_weight)
                  
if MODEL == "RFC":
	from sklearn.ensemble import RandomForestClassifier
	estimator = RandomForestClassifier(random_state=42, class_weight=class_weight)

if MODEL == "SVC-linear":
    from sklearn.svm import SVC
    estimator = SVC(random_state=42, probability=True, kernel = 'linear', class_weight=class_weight)

if MODEL == "SVC-poly":
    from sklearn.svm import SVC
    estimator = SVC(random_state=42, probability=True, kernel = 'poly', class_weight=class_weight)

if MODEL == "SVC-rbf":
    from sklearn.svm import SVC
    estimator = SVC(random_state=42, probability=True, kernel = 'rbf', class_weight=class_weight)
                   
if MODEL == "SVC-sigmoid":
	from sklearn.svm import SVC
	estimator = SVC(random_state=42, probability=True, kernel = 'sigmoid', class_weight=class_weight)

#------------------------------------------------------------------------------

# remove any existing outfiles
import os

if os.path.exists("%s_TMP-FILE_all_pred.txt" % RAND):
	os.remove("%s_TMP-FILE_all_pred.txt" % RAND)
  
if os.path.exists("%s_TMP-FILE_all_val_target.txt" % RAND):
	os.remove("%s_TMP-FILE_all_val_target.txt" % RAND)
  
if os.path.exists("%s_TMP-FILE_all_proba.txt" % RAND):
	os.remove("%s_TMP-FILE_all_proba.txt" % RAND)
  
#------------------------------------------------------------------------------

##################################
# fit model to test
##################################

train = train_all
train_target = train_target_all

test = test_all
test_target = test_target_all

##################################

all_train_pos = np.count_nonzero(train_target == 1)
all_train_neg = np.count_nonzero(train_target == 0)

all_train_pos_array = np.array([all_train_pos])
all_train_neg_array = np.array([all_train_neg])

##################################

# Feature selection:
if K != 'all':
 from sklearn.feature_selection import chi2
 from sklearn.feature_selection import SelectKBest
 selector = SelectKBest(chi2, k=K)
 selector.fit(train, train_target)
 mask = selector.get_support()
 new_features = train.columns[mask]
 train = train[new_features]
 test = test[new_features]

print("train shape")
print(train.shape)
print("test shape")
print(test.shape)

# fit model
estimator.fit(train, train_target.values.ravel())

# predict
pred = estimator.predict(test)

# proba
proba = estimator.predict_proba(test)[:, 1]

# make dataframe
df = pd.DataFrame()
df['col1'] = test.index.values.ravel()
df['col2'] = test_target.values.ravel().round()
df['col3'] = pred.round()
df['col4'] = proba
df.columns = ["INDEX", "ORIGINAL", "PREDICT", "PROBA"]

# write dataframe of original predict to file
np.savetxt("%s_ORIGINAL-PREDICT_test.csv" % PREFIX, df, delimiter=",", fmt="%s", header= 'INDEX,ORIGINAL,PREDICT,PROBA', comments='')

# calculate confusion_matrix
CM = confusion_matrix(df['ORIGINAL'], df['PREDICT'])
print("confusion_matrix [test]:")
print(CM)
# write confusion_matrix file
np.savetxt("%s_confusion_matrix_test.csv" % PREFIX, CM, delimiter=",", fmt="%s")

# calculate precision_score
PS = precision_score(df['ORIGINAL'], df['PREDICT'])
# write precision_score to file
PS = np.array([PS])
np.savetxt("%s_precision_score_test.csv" % PREFIX, PS, delimiter=",", fmt="%s")

# calculate recall_score
RS = recall_score(df['ORIGINAL'], df['PREDICT'])
# write recall_score to file
RS = np.array([RS])
np.savetxt("%s_recall_score_test.csv" % PREFIX, RS, delimiter=",", fmt="%s")

# calculate f1_score
F1 = f1_score(df['ORIGINAL'], df['PREDICT'])
# write f1_score to file
F1 = np.array([F1])
np.savetxt("%s_f1_score_test.csv" % PREFIX, F1, delimiter=",", fmt="%s")

# calculate AUC
AUC = metrics.roc_auc_score(df['ORIGINAL'], df['PROBA']).reshape(1, -1)

# write AUC file
np.savetxt("%s_AUC_test.csv" % PREFIX, AUC, delimiter=",", fmt="%s")
print("AUC:")
print(AUC)
