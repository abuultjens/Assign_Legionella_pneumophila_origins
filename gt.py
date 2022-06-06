
import numpy as np
import pandas as pd

import sys
X = float(sys.argv[1])
THRESHOLD = float(sys.argv[2])
#data = pd.read_csv(THRESHOLD, header=None, index_col=None)

#if X >= data[0]:
if (X <= THRESHOLD):
    print(1)
else:
    print(0)
