
import numpy as np
import pandas as pd
from sklearn.utils import resample,shuffle

import sys
TARGET = sys.argv[1]
DATA = sys.argv[2]
PREFIX = sys.argv[3]
US_N = int(sys.argv[4])

# read from file
data  = pd.read_csv(DATA, header=0, index_col=0)
target  = pd.read_csv(TARGET, header=0, index_col=0)

# make subset dfs
target_1 = target[target[target.columns[0]] == 1]
target_0 = target[target[target.columns[0]] != 1]

# count n 0
#N_ZERO = target_0.shape[0]
N_ZERO = US_N

# upsample
target_1_us = resample(target_1,random_state=42,n_samples=N_ZERO,replace=True)
# concatinate 1_us_df with 0_df
target_us = pd.concat([target_1_us, target_0])
# subset data using us target index
data_us = data[target_us.index]

# write to file
target_us.to_csv("data/target_%s.csv" % PREFIX, index=True)
data_us.to_csv("data/data_%s.csv" % PREFIX, index=True)

