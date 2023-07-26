# to start: bash run_lv.sh 1
echo "In Computer | PLACE SCRIPT IN NEXMON FOLDER"
# Change these around a bit
# Realtime folder is automatically created
# change username from vboxuser
loc_in_phone=/sdcard/csi_data_realtime
folder_in_computer=$(pwd)
#mkdir folder_in_computer -p
file_in_phone_old="$loc_in_phone/csi_old.pcap"
file_in_phone_new="$loc_in_phone/csi_new.pcap"
done_path="$loc_in_phone/done.txt"
done_in_comp="$folder_in_computer/done_uploading.txt"
zero=0
SSID=TP-Link_4D8F_5G
len_trial=500
num_packets=600
v=$(ps -ef | grep get_data_lv.sh | tr -s ' ' | cut -d ' ' -f2) 
kill -SIGTERM $v >/dev/null 2>&1
v=$(ps -ef | grep read_lv_immed.sh | tr -s ' ' | cut -d ' ' -f2) 
kill -SIGTERM $v >/dev/null 2>&1
function ctrl_c() {
    #kill any half-finished processes
    v=$(ps -ef | grep get_data_lv.sh | tr -s ' ' | cut -d ' ' -f2) 
    kill -SIGTERM $v >/dev/null 2>&1
    v=$(ps -ef | grep read_lv_immed.sh | tr -s ' ' | cut -d ' ' -f2) 
    kill -SIGTERM $v >/dev/null 2>&1
    exit 0
}
trap ctrl_c SIGINT

if [[ $1 -eq 1 ]]
then
	cd ..
    source setup_env.sh
    make
    cd ./utilities
    make
    make install
    cd ../patches/bcm4339/6_37_34_43/
    cd ./nexmon_csi/utils/makecsiparams/
    make
    # get wifi network information
    adb shell "su -c 'ifconfig wlan0 down'"
    adb shell "su -c 'ifconfig wlan0 up'"
    output=$(adb shell "su -c 'iwlist wlan0 scan | grep -C 5 $SSID'")
    echo $output

    channel=$(echo "$output" | grep -oP '(?<=Channel:)\d+')
    address=$(echo "$output" | grep -oP '(?<=Address: )\S+')

    echo ------------------------------------------------------------------
    echo $channel
    echo $address
    # these params will be passed to the phone when monitoring
    params=$(./makecsiparams -c $channel/20 -C 1 -N 1 -m $address)
    pwd
    echo $params
    cd $folder_in_computer
    adb push init_csi_lv.sh /sdcard/init_csi_lv.sh
    adb shell "su -c 'sh /sdcard/init_csi_lv.sh $params'"
else
    echo
    echo "No second argument supplied. If this is your first time running the script upon boot, make sure to use the \$ bash run_lv 1 command"
    echo
	
fi
adb push ./get_data_lv.sh /sdcard/get_data_lv.sh
adb push ./read_lv_immed.sh /sdcard/read_lv_immed.sh



echo "Starting.."
begin_time=$(($(date +%s%N)/1000000))
adb shell "su -c 'sh /sdcard/get_data_lv.sh $file_in_phone_new $len_trial $done_path $num_packets $done_in_comp'" & bash read_lv_immed.sh $folder_in_computer $len_trial $done_path $done_in_comp  $file_in_phone_new $num_packets & python3 csi.py
samp_end=$(($(date +%s%N)/1000000))
time_taken_samp=$(expr $samp_end - $begin_time)

echo "Sampling took $time_taken_samp ms"
echo "Done with System"


