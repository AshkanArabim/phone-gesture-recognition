i=1
one=1
file_in_phone_old=$1
file_in_computer=$2
len_trial=$3
done_path=$4
done_in_comp=$5
file_in_phone_new=$6
while [ $i -le $len_trial ]
do
	# change this filepath manually - it's very finnicky
	v=$(adb shell '[ -e /sdcard/csi_data_realtime/done.txt ]; echo $?' | tr -d '\n' | cut -c1)
	v=$(expr $v + 1)
	# for testing - adb shell '[ -e /sdcard/csi_data_realtime/done.txt ]; echo $?'
	#echo $v
	if [ $v -eq 1 ]
	then
		#echo "File exists! Pulling $file_in_phone_old now"
		#adb shell ls /sdcard/csi_data_realtime
		#echo "Done Listing Directory"
		#echo $done_path
		adb pull $file_in_phone_old $file_in_computer #>/dev/null 2>&1
		adb shell "su -c 'rm $done_path'"
		test -e $done_in_comp && echo "Falling behind - replacing unread data!" 
		
		touch $done_in_comp
		i=$(expr $i + $one)
	fi

done


