
folder_in_computer=$1
len_trial=$2
done_path=$3
done_in_comp=$4
file_in_phone_new=$5
num_packets=$6

i=1

delay=1 #MUST BE AN INTEGER, IN SEC
tm=$(expr $num_packets \* $len_trial / 10 )
while [ $i -le $tm ]
do
	#echo "Immediate Read is Running!"
	
	adb pull $file_in_phone_new $folder_in_computer >/dev/null 2>&1
	touch $done_in_comp
	sleep $delay
	i=$(expr $i + $one)
	
done
echo "Done with Live Read"


