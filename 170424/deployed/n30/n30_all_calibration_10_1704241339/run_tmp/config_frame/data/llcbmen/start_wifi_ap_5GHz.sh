#!/system/xbin/bash -login

#GD-2014-04-04: Added sleep statements after each step - 
#GD-2014-04-05: Make BSSID an argument

adb=/opt/android/platform-tools/adb

CHANNEL=5
SSID="samsung_s4_net"
AP=00:11:22:33:44:55

if [ "$1" = "" ]; then
  echo "$0 <IP address> [ssid] [ap]"
  exit -1
fi
IP="$1"

if [ "$2" != "" ]; then
  SSID="$2"
fi

if [ "$3" != "" ]; then
  AP="$3"
fi

echo "Configure the phone WiFi region for US"
iw reg set US

echo Starting Wifi...

echo Removing kernel module
rmmod dhd.ko
sleep 5

echo Inserting kernel module
insmod /system/lib/modules/dhd.ko \
    firmware_path=/system/etc/wifi/bcmdhd_ibss.bin \
    nvram_path=/system/etc/wifi/nvram_net.txt
sleep 5

echo Setting wlan0 down
busybox ifconfig wlan0 down
sleep 10

echo Setting up wireless parameters
iwconfig wlan0 mode ad-hoc \
    essid $SSID \
    channel $CHANNEL \
    ap $AP
sleep 10

echo "Setting wlan0 up"
busybox ifconfig wlan0 $IP netmask 255.255.255.0 up && echo SUCCESS || echo FAILURE
iwconfig wlan0 | grep -A 1 wlan0
busybox ifconfig usb0 | grep -A 1 usb0
sleep 10

echo "Changing Channel to 36"
CHANNEL=36
iwconfig wlan0 mode ad-hoc \
    essid $SSID \
    channel $CHANNEL \
    ap $AP
sleep 10
iwconfig wlan0 mode ad-hoc \
    essid $SSID \
    channel $CHANNEL \
    ap $AP

iwconfig wlan0 | grep -A 1 wlan0
busybox ifconfig usb0 | grep -A 1 usb0


