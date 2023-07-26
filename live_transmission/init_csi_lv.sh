#!/bin/sh
# adb push ./init_csi.sh /sdcard/init_csi.sh
# adb shell "su -c 'sh /sdcard/init_csi.sh ldABEQAAAQCY2sSOTY4AAAAAAAAAAAAAAAAAAAAAAAAAAA=='"
# also ldABEQAAAQCY2sSOTY4AAAAAAAAAAAAAAAAAAAAAAAAAAA==
echo "Initializing..."
ifconfig wlan0 up
nexutil -Iwlan0 -s500 -b -l34 -v $1
#nexutil -Iwlan0 -s500 -b -l34 -v ldABEQAAAQCY2sSOTY4AAAAAAAAAAAAAAAAAAAAAAAAAAA==
nexutil -Iwlan0 -m1
mkdir /sdcard/csi_data_realtime -p
echo "Ready"
