import numpy as np
import matplotlib.pyplot as plt
import sys, os
def subcar_anomaly_removal(subcar, std_threshold):
  z_scores = (subcar - np.mean(subcar)) / np.std(subcar)
  to_ditch = np.where(np.abs(z_scores) > std_threshold)
  # print(to_ditch)
  cleaned = np.copy(subcar)
  cleaned[to_ditch] = np.median(subcar)

  return cleaned

def df_anomaly_removal(df, std_threshold):
  # cleaned_df = df.apply((lambda x: subcar_anomaly_removal(x, std_threshold)), axis = 0)
  cleaned_df = np.apply_along_axis(
      (lambda x: subcar_anomaly_removal(x, std_threshold)),
      axis = 0,
      arr=df
      )
  return cleaned_df

def mov_avg(subcar, width):
  return np.convolve(subcar, np.ones(width), 'valid') / width

# actual script starts here
def clean(original, drop = [0, 1, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38], log = False):

    chopped = np.delete(original, drop, axis = 1)

    magMatrix = np.abs(chopped)
    no_outlier = df_anomaly_removal(magMatrix, 2)
    magSmoothened = np.apply_along_axis((lambda x: mov_avg(x, 2)), arr=no_outlier, axis=0)
    # take log, replace anything below 1 with 0

    if log:
      magSmoothened = np.where(magSmoothened <= 1, 0, np.log(magSmoothened))

    # if len(drop) != 0:
    #   for index in drop:
    #     magSmoothened[:, index] = 0

    return magSmoothened
def widen_samp(csi_samp):
    return np.reshape(np.repeat([csi_samp], 3), (csi_samp.shape[0],csi_samp.shape[1],3))
# VISUALIZATION FUNCTIONS
from matplotlib import colors

def subcarLineChart(gph, log = False): # log: use log scale or not
    packet_index = len(gph)

    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    plt.title("Magnitude of Signal by Channel and Packet Number")
    plt.xlabel("Packet #")
    plt.ylabel("Magnitude")
    ax1.set_yscale("log") if log else None
    plt.plot(gph, lw = .25)

    plt.show(block=False)
    plt.close()
    return fig


def subcarSpectrogram(gph, log = False, subcar_start = 0, subcar_end = -1, trim_line=True): # log: use log scale or not
    subcar_end = len(gph[0]) if subcar_end == -1 else subcar_end # replace -1 with valid final index
    fig=plt.figure()
    show_spect=np.copy(gph)
    if trim_line:
        start = ash_trimming(gph, return_index=True)
        end = start + 19
        dark=np.max(gph)
        show_spect[start]=dark
        show_spect[end]=dark
    plt.imshow(
    show_spect,
    # extent --> left, rigth, bottom, top
    extent = (subcar_start, subcar_end, len(gph), 0),
    norm = colors.LogNorm() if log else None)
    plt.xlabel('Subcarriers')
    plt.ylabel('Packet #')
    plt.colorbar(label = 'magnitude')

        
    plt.savefig("live_csi.png")
    plt.close()
    return fig
  
def rolling_sum(arr, window_size):
    # print(arr.shape)
    return np.convolve(arr, np.ones(window_size), 'valid')

def ash_trimming(csi, n_roll = 20, return_index = False):
    to_trim = csi # will be used later...

    csi = np.apply_along_axis(lambda subcar: rolling_difference_1d(subcar, 3), axis = 0, arr = csi)
    csi = np.apply_along_axis(lambda packet: sum(rolling_difference_1d(packet, 2)), axis = 1, arr = csi)
    csi = rolling_sum(csi, n_roll)
    start_index = np.argmax(csi)
    end_index = start_index + n_roll

    if return_index:
        return start_index
    else:
        # trim the original based on the starting & ending index
        return to_trim[start_index : end_index]

def clean_trim(csi_matrix, drop = [0, 1, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38], log = False, trim = True, window_size = 20, filter_size = 2, filter = ''):
    csi_matrix = np.delete(csi_matrix, drop, axis = 1)

    csi_matrix = np.abs(csi_matrix)
    csi_matrix = df_anomaly_removal(csi_matrix, 2)

    # apply specified filter
    # if nothing specified, does nothing
    if filter == 'average':
        csi_matrix = np.apply_along_axis((lambda x: mov_avg(x, filter_size)), arr = csi_matrix, axis = 0)
    elif filter == 'gaussian':
        filter = gaussian_filter(filter_size, 1)
        csi_matrix = np.apply_along_axis((lambda x: apply_filter(x, filter)), arr = csi_matrix, axis = 0)
    # take log, replace anything below 1 with 0

    if trim:
        csi_matrix = ash_trimming(csi_matrix, n_roll = window_size)

    if log:
        csi_matrix = np.where(csi_matrix <= 1, 0, np.log(csi_matrix))
        
    

    return csi_matrix
def rolling_difference_1d(arr, window_size):
    result = []
    for i in range(len(arr) - window_size + 1):
        result.append(np.abs(arr[i + window_size - 1] - arr[i]))
    # no padding: we just care about the starting index
    return np.array(result)
