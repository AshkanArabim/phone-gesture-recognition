#!/bin/sh
#Inspired from https://utkarshopalkar.medium.com/how-to-run-shell-scripts-on-the-android-os-shell-from-within-your-java-react-native-android-app-72455e78948b
# adb push ./get_data.sh /sdcard/get_data.sh
# adb shell "su -c 'sh /sdcard/get_data.sh p.pcap'"
# echo "Successful Script Run for Data Collection!"
#---VARIABLES---#
file_in_phone_new=$1
len_trial=$2
done_path=$3
packet_num=$4
#---------------#
for i in $(seq 1 1 $len_trial)
do
	tcpdump -i wlan0 -c $packet_num -vv dst port 5500 -w $file_in_phone_new --immediate-mode >/dev/null 2>&1
	touch $done_path

	
done
echo "Done with Data Collection"
exit



