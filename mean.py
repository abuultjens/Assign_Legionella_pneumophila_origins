
import numpy as np
import pandas as pd

import sys
DATA = str(sys.argv[1])
PREFIX = sys.argv[2]
#PREFIX='TEST'

data = pd.read_csv(DATA, header=None, index_col=None)
mean = (sum(data[0]))/(len(data[0]))

MEAN = np.array([mean])
np.savetxt("%s_mean.csv" % PREFIX, MEAN, delimiter=",", fmt="%s")