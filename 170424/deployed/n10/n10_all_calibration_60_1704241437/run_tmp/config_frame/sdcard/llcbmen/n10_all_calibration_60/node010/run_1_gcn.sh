#!/system/xbin/bash -login

nodeName=$1
nodeNum=$2
runid=$3
expRoot=$4
expName=$5
basetime=$6

dataFile=$expRoot/data/$runid/data/$nodeName/gcn.llg
mgenLogFile=$expRoot/data/$runid/data/$nodeName/mgen.log
olsrLogFile=$expRoot/data/$runid/data/$nodeName/olsr.log

echo '''
0.0 LISTEN UDP 5001
60.0 ON 1 UDP SRC 5001 DST 10.1.1.1/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 2 UDP SRC 5001 DST 10.1.1.2/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 3 UDP SRC 5001 DST 10.1.1.3/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 4 UDP SRC 5001 DST 10.1.1.4/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 5 UDP SRC 5001 DST 10.1.1.5/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 6 UDP SRC 5001 DST 10.1.1.6/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 7 UDP SRC 5001 DST 10.1.1.7/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 8 UDP SRC 5001 DST 10.1.1.8/5001 POISSON [60 128] INTERFACE wlan0
60.0 ON 9 UDP SRC 5001 DST 10.1.1.9/5001 POISSON [60 128] INTERFACE wlan0
300.0 OFF 1
300.0 OFF 2
300.0 OFF 3
300.0 OFF 4
300.0 OFF 5
300.0 OFF 6
300.0 OFF 7
300.0 OFF 8
300.0 OFF 9
''' > /sdcard/exp.mgen

echo "Starting mgen."
olsrd -d 0 -i wlan0 > $olsrLogFile
sleep 1
mgen input /sdcard/exp.mgen > $mgenLogFile
sleep 1
exit 0
