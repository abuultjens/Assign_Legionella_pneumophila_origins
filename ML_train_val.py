
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
#val_pos = np.count_nonzero(val_labels == 1)
#val_neg = np.count_nonzero(val_labels == 0)
test_pos = np.count_nonzero(test_target_all.values.ravel() == 1)
test_neg = np.count_nonzero(test_target_all.values.ravel() == 0)

total = train_pos + train_neg

#weight_for_0 = (1 / train_neg) * (total / 2.0)
#weight_for_1 = (1 / train_pos) * (total / 2.0)

#weight_for_0 = 0.5
#weight_for_1 = 0.5

class_weight = {0: weight_for_0, 1: weight_for_1}

print('Weight for class 0: {:.2f}'.format(weight_for_0))
print('Weight for class 1: {:.2f}'.format(weight_for_1))

test_pos_array = np.array([test_pos])
#np.savetxt("%s_test_pos.csv" % PREFIX, test_pos_array, delimiter=",", fmt="%s")
test_neg_array = np.array([test_neg])
#np.savetxt("%s_test_neg.csv" % PREFIX, test_neg_array, delimiter=",", fmt="%s")


#------------------------------------------------------------------------------
# define the model 
         
if MODEL == "LGR":
	from sklearn.linear_model import LogisticRegression
	estimator=LogisticRegression(random_state = 42, class_weight=class_weight)
                  
if MODEL == "RFC":
	from sklearn.ensemble import RandomForestClassifier
	estimator = RandomForestClassifier(random_state=42,
		 n_estimators=900,
		 min_samples_split=8,
		 min_samples_leaf=1,
		 max_features='sqrt',
		 max_depth=327,
		 criterion='gini',
		 bootstrap=False)
     
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
                  
if MODEL == "GBC":
	from sklearn.ensemble import GradientBoostingClassifier
	estimator = GradientBoostingClassifier(random_state=42)

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

# make arrays
all_val_target = np.array([])
all_y_pred = np.array([])
all_y_proba = np.array([])

# train test split seed
for d in range(1, 11):

	train, val, train_target, val_target = train_test_split( 
		train_all, 
		train_target_all.values.ravel(), 
		test_size = 0.8, 
		random_state = d,
		stratify = train_target_all.values.ravel())

	# concatenate all y_test
	all_val_target = np.concatenate([all_val_target, val_target])
	all_val_target_list = all_val_target.reshape(-1, 1)
	all_val_target = np.array([])

	# append all y_test to file
	f=open("%s_TMP-FILE_all_val_target.txt" % RAND, "a+")
	np.savetxt(f, all_val_target_list)
	f.close()

	# subset matrix with target index
	#train = train_tr[train_target.index].T
	#test = train_tr[test_target.index].T

	##################################
	# fit model to val
	##################################

	test = test_all
	test_target = test_target_all

	# Feature selection:
	if K != 'all':
	 from sklearn.feature_selection import chi2
	 from sklearn.feature_selection import SelectKBest
	 selector = SelectKBest(chi2, k=K)
	 selector.fit(train, train_target)
	 mask = selector.get_support()
	 new_features = train.columns[mask]
	 train = train[new_features]
	 val = val[new_features]
	 test = test[new_features]

#	print("train shape")
#	print(train.shape)
#	print("val shape")
#	print(val.shape)
#	print("test shape")
#	print(test.shape)

	print("train-val loop:")
	print(d)

#	train_pos = np.count_nonzero(train_target == 1)
#	print("train_pos")
#	print(train_pos)
#	train_neg = np.count_nonzero(train_target == 0)
#	print("train_neg")
#	print(train_neg)	
#	val_pos = np.count_nonzero(val_target == 1)
#	print("val_pos")
#	print(val_pos)
#	val_neg = np.count_nonzero(val_target == 0)
#	print("val_neg")
#	print(val_neg)
        
	# fit model
	estimator.fit(train, train_target)

	# predict
	y_pred = estimator.predict(val)

	# concatenate all predictions
	all_y_pred = np.concatenate([all_y_pred, y_pred])
	all_y_pred_list = all_y_pred.reshape(-1, 1)
	all_y_pred = np.array([])

	# append all predictions to file
	f=open("%s_TMP-FILE_all_pred.txt" % RAND, "a+")
	np.savetxt(f, all_y_pred_list)
	f.close()

	# proba
	y_proba = estimator.predict_proba(val)[:, 1]

	# concatenate all proba
	all_y_proba = np.concatenate([all_y_proba, y_proba])
	all_y_proba_list = all_y_proba
	all_y_proba = np.array([])

	# append all proba to file
	f=open("%s_TMP-FILE_all_proba.txt" % RAND, "a+")
	np.savetxt(f, all_y_proba_list)
	f.close()
    
#------------------------------------------------------------------------------

train_pos = np.count_nonzero(train_target == 1)
train_neg = np.count_nonzero(train_target == 0)
val_pos = np.count_nonzero(val_target == 1)
val_neg = np.count_nonzero(val_target == 0)

train_pos_array = np.array([train_pos])
#np.savetxt("%s_train_pos.csv" % PREFIX, train_pos_array, delimiter=",", fmt="%s")
train_neg_array = np.array([train_neg])
#np.savetxt("%s_train_neg.csv" % PREFIX, train_neg_array, delimiter=",", fmt="%s")

val_pos_array = np.array([val_pos])
#np.savetxt("%s_val_pos.csv" % PREFIX, val_pos_array, delimiter=",", fmt="%s")
val_neg_array = np.array([val_neg])
#np.savetxt("%s_val_neg.csv" % PREFIX, val_neg_array, delimiter=",", fmt="%s")

#------------------------------------------------------------------------------


# read all y_test file
all_val_target_file = pd.read_csv('%s_TMP-FILE_all_val_target.txt' % RAND, header=None, index_col=None)
print(" all_val_target_file shape")
print(all_val_target_file.shape)

# read all predictions file
all_pred_file = pd.read_csv('%s_TMP-FILE_all_pred.txt' % RAND, header=None, index_col=None)
print(" all_pred_file shape")
print(all_pred_file.shape)

# read all proba file
all_proba_file = pd.read_csv('%s_TMP-FILE_all_proba.txt' % RAND, header=None, index_col=None)
print(" all_proba_file shape")
print(all_proba_file.shape)

if os.path.exists("%s_TMP-FILE_all_val_target.txt" % RAND):
  os.remove("%s_TMP-FILE_all_val_target.txt" % RAND)

if os.path.exists("%s_TMP-FILE_all_pred.txt" % RAND):
  os.remove("%s_TMP-FILE_all_pred.txt" % RAND)

if os.path.exists("%s_TMP-FILE_all_proba.txt" % RAND):
  os.remove("%s_TMP-FILE_all_proba.txt" % RAND)

#------------------------------------------------------------------------------

# make dataframe
tmp = np.hstack([all_val_target_file, all_pred_file, all_proba_file])
df = pd.DataFrame(data=tmp)
df.columns = ["ORIGINAL", "PREDICT", "PROBA"]

# write dataframe of original predict to file
np.savetxt("%s_ORIGINAL-PREDICT.csv" % PREFIX, df, delimiter=",", fmt="%s", header= 'ORIGINAL,PREDICT,PROBA', comments='')

# calculate confusion_matrix
CM = confusion_matrix(df['ORIGINAL'], df['PREDICT'])
print("confusion_matrix [val]:")
print(CM)
# write confusion_matrix file
np.savetxt("%s_confusion_matrix_val.csv" % PREFIX, CM, delimiter=",", fmt="%s")

# calculate precision_score
PS = precision_score(df['ORIGINAL'], df['PREDICT'])
# write precision_score to file
PS = np.array([PS])
np.savetxt("%s_precision_score_val.csv" % PREFIX, PS, delimiter=",", fmt="%s")

# calculate recall_score
RS = recall_score(df['ORIGINAL'], df['PREDICT'])
# write recall_score to file
RS = np.array([RS])
np.savetxt("%s_recall_score_val.csv" % PREFIX, RS, delimiter=",", fmt="%s")

# calculate f1_score
F1 = f1_score(df['ORIGINAL'], df['PREDICT'])
# write f1_score to file
F1 = np.array([F1])
np.savetxt("%s_f1_score_val.csv" % PREFIX, F1, delimiter=",", fmt="%s")

# calculate AUC
AUC = metrics.roc_auc_score(df['ORIGINAL'], df['PROBA']).reshape(1, -1)

# write AUC file
np.savetxt("%s_AUC_val.csv" % PREFIX, AUC, delimiter=",", fmt="%s")
print("AUC:")
print(AUC)
