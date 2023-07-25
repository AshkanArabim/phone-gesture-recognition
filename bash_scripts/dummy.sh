# bash ./dummy.sh [ROUTER_NAME] 50
# bash ./dummy.sh TP-Link_4D8F_5G 50

# only run the following line if your are running WSL
shopt -s expand_aliases # used to support my adb alias on windows
source /etc/bash.bashrc

# to start: bash ./dummy.sh TP-Link_4D8F_5G
echo "In Computer | PLACE SCIRPT IN NEXMON FOLDER"

init_dir=$(pwd)
SSID=$1
begin_time=$(date +%s)

# install any missing packages
sudo apt install git gawk qpdf adb flex bison

# NOTE: uncomment the make commands if you want to install the utilities on your nexus 5 phone
# better option: follow this link: 'nexmon.org/csi'

source setup_env.sh
# make
cd ./utilities
# make
# make install
cd ../patches/bcm4339/6_37_34_43/
git clone https://github.com/seemoo-lab/nexmon_csi.git
cd ./nexmon_csi/utils/makecsiparams/

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
echo $params

sleep 1
cd "$init_dir"
adb push ./get_data.sh /sdcard/get_data.sh
adb shell "su -c 'sh /sdcard/get_data.sh $params'"
end_sampling_time=$(date +%s)

# Assign the handler function to the SIGINT signal
trap handler SIGINT
adb pull sdcard/csi_data ./csi_data

time_taken=$(expr $end_sampling_time - $begin_time)
echo "Sampling took $time_taken seconds"