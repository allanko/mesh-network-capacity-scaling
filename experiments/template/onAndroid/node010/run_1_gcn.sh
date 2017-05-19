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
0.0 ON 1 UDP SRC 5001 DST 10.1.1.9/5001 POISSON [1000000 128] INTERFACE wlan0
0.0 LISTEN UDP 5001
300.0 OFF 1
''' > /sdcard/exp.mgen

echo "Starting mgen."
olsrd -d 0 -i wlan0 > $olsrLogFile
sleep 1
mgen input /sdcard/exp.mgen > $mgenLogFile
sleep 1
exit 0
