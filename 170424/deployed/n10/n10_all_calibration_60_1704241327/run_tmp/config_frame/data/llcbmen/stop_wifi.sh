#!/system/xbin/bash -login

rmmod dhd.ko

# Commented out, because above takes down device
#busybox ifconfig wlan0 down
