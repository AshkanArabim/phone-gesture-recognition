import csiread
import numpy as np
from dep import *
import time
csidata = csiread.Nexmon("csi_test.pcap", chip='4339', bw=20) # we capture with a bandwidth of 20
csidata.read()
original = np.array(csidata.csi)
#chopped = np.delete(original, [0, 1, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38], axis = 1)
#magMatrix = np.abs(chopped)
#no_outlier = df_anomaly_removal(magMatrix, 2)
#subcarSpectrogram(no_outlier, trim_line=False)
subcarSpectrogram(clean(original))



