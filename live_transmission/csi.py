from dep import *

import numpy as np
import os
import logging
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3' 
#logging.getLogger('csiread').setLevel(logging.CRITICAL)
import tensorflow as tf
import csiread
print("Packages loaded")

model = tf.keras.models.load_model("most_recent.h5")
i = 0
tot = np.zeros((49,64))
csi_path = "csi_new.pcap"
done_path = "done_uploading.txt"
# csidata = csiread.Nexmon(csi_path, chip='4339', bw=20) # we capture with a bandwidth of 20
# csidata.read()
# original = np.array(csidata.csi)
# print(csi_path[:-14])
#print(os.path.exists(csi_path))
#print(os.path.exists(done_path))
gestures=["block", "circlex", "knock", "palmfist", "voldown"]
if os.path.exists(done_path):
    os.remove(done_path)
print("Running...")
err_ct=0
def get_csi_info(path,chip='4339',bw=20):
    csidata = csiread.Nexmon(csi_path, chip='4339', bw=20) # we capture with a bandwidth of 20
    csidata.read()
    original = np.array(csidata.csi)
    return original
while( True ):
    if os.path.isfile(done_path):
        os.remove(done_path)
        
        try:
            #buffer = io.StringIO()
            #sys.stdout = buffer
            original=get_csi_info(csi_path)
            #original=np.random.rand(49,64)
            # print(original)
            #sys.stdout = sys.__stdout__
            # print(cl.shape)
            # print(cl.shape)
            # print(tot.shape)
            tot = np.concatenate((tot,original))
            if tot.shape[0] > 50:
                tot = tot[-50:]
            
            cl = clean(tot)
            subcarSpectrogram(cl)

            w = widen_samp(cl)
            #print(w.shape)
            #est = model.predict(np.asarray([w]),verbose = 0)[0]

            #est_pct = [ round((x - min(est))*100 / (sum(est)-len(est)*min(est))) for x in est ]
            #d = dict(zip(est_pct, gestures)) 
            #print(d)
            #if max(est_pct) >= 50:
            #    pass
                #print(d[max(est_pct)])
            # print(i)
            i+=1
        except Exception as error:
            err_ct+=1
            print(f"An error occurred: {error}. Running Again. Error count: {err_ct}")
            
       

# # w = widen_samp(cl)
# # print(w.shape)
# # est = model.predict(np.asarray([w]),verbose = 0)
# # print(est)
