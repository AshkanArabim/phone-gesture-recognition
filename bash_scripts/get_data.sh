#!/bin/sh
#Inspired from https://utkarshopalkar.medium.com/how-to-run-shell-scripts-on-the-android-os-shell-from-within-your-java-react-native-android-app-72455e78948b

echo "Successful Script Run for Data Collection!"
#---VARIABLES---#
# in case something doesn't work, manually generate the parameters (e.g. ndABEQAAAQCY2sSOTY4AAAAAAAAAAAAAAAAAAAAAAAAAAA==)
person=1
packet_num=50 # usually 50 for testing
sample_per_gesture=25
data_dir=/sdcard
params=$1
#---------------#

ifconfig wlan0 up
nexutil -Iwlan0 -s500 -b -l34 -v $params
nexutil -Iwlan0 -m1

cd $data_dir
rm csi_data -r
mkdir csi_data
cd csi_data
dash=_

printf "\033c"
for environment in 1
do
	printf "\033c"
	for gesture in block circlex knock palmfist voldown
	# for gesture in circlex 
	do 
		mkdir $gesture
		printf "\033c"

		echo "recording for **$gesture** starts in..."
		for counter in 3 2 1
		do
			sleep 1
			echo $counter
		done

		for sample in $(seq 1 1 $sample_per_gesture)
		do
			echo "Environment: $environment Gesture: $gesture, Sample: $sample."
			echo "Collecting..."
			tcpdump -i wlan0 -c $packet_num -vv dst port 5500 -w ~/sdcard/csi_data/$gesture/$gesture$dash$environment$person$sample.pcap #>/dev/null 2>&1
			echo "Done!"
			echo " "
			sleep 0.5

		done
	done

done
echo -e "Done! Saving has started. "
exit


