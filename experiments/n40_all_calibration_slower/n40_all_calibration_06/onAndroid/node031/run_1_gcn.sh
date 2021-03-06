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
60.0 ON 1 UDP SRC 5001 DST 10.1.1.1/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 2 UDP SRC 5001 DST 10.1.1.2/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 3 UDP SRC 5001 DST 10.1.1.3/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 4 UDP SRC 5001 DST 10.1.1.4/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 5 UDP SRC 5001 DST 10.1.1.5/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 6 UDP SRC 5001 DST 10.1.1.6/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 7 UDP SRC 5001 DST 10.1.1.7/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 8 UDP SRC 5001 DST 10.1.1.8/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 9 UDP SRC 5001 DST 10.1.1.9/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 10 UDP SRC 5001 DST 10.1.1.10/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 11 UDP SRC 5001 DST 10.1.1.11/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 12 UDP SRC 5001 DST 10.1.1.12/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 13 UDP SRC 5001 DST 10.1.1.13/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 14 UDP SRC 5001 DST 10.1.1.14/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 15 UDP SRC 5001 DST 10.1.1.15/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 16 UDP SRC 5001 DST 10.1.1.16/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 17 UDP SRC 5001 DST 10.1.1.17/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 18 UDP SRC 5001 DST 10.1.1.18/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 19 UDP SRC 5001 DST 10.1.1.19/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 20 UDP SRC 5001 DST 10.1.1.20/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 21 UDP SRC 5001 DST 10.1.1.21/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 22 UDP SRC 5001 DST 10.1.1.22/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 23 UDP SRC 5001 DST 10.1.1.23/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 24 UDP SRC 5001 DST 10.1.1.24/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 25 UDP SRC 5001 DST 10.1.1.25/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 26 UDP SRC 5001 DST 10.1.1.26/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 27 UDP SRC 5001 DST 10.1.1.27/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 28 UDP SRC 5001 DST 10.1.1.28/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 29 UDP SRC 5001 DST 10.1.1.29/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 30 UDP SRC 5001 DST 10.1.1.30/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 32 UDP SRC 5001 DST 10.1.1.32/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 33 UDP SRC 5001 DST 10.1.1.33/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 34 UDP SRC 5001 DST 10.1.1.34/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 35 UDP SRC 5001 DST 10.1.1.35/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 36 UDP SRC 5001 DST 10.1.1.36/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 37 UDP SRC 5001 DST 10.1.1.37/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 38 UDP SRC 5001 DST 10.1.1.38/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 39 UDP SRC 5001 DST 10.1.1.39/5001 POISSON [0.6 128] INTERFACE wlan0
60.0 ON 40 UDP SRC 5001 DST 10.1.1.40/5001 POISSON [0.6 128] INTERFACE wlan0
300.0 OFF 1
300.0 OFF 2
300.0 OFF 3
300.0 OFF 4
300.0 OFF 5
300.0 OFF 6
300.0 OFF 7
300.0 OFF 8
300.0 OFF 9
300.0 OFF 10
300.0 OFF 11
300.0 OFF 12
300.0 OFF 13
300.0 OFF 14
300.0 OFF 15
300.0 OFF 16
300.0 OFF 17
300.0 OFF 18
300.0 OFF 19
300.0 OFF 20
300.0 OFF 21
300.0 OFF 22
300.0 OFF 23
300.0 OFF 24
300.0 OFF 25
300.0 OFF 26
300.0 OFF 27
300.0 OFF 28
300.0 OFF 29
300.0 OFF 30
300.0 OFF 32
300.0 OFF 33
300.0 OFF 34
300.0 OFF 35
300.0 OFF 36
300.0 OFF 37
300.0 OFF 38
300.0 OFF 39
300.0 OFF 40
''' > /sdcard/exp.mgen

echo "Starting mgen."
olsrd -d 0 -i wlan0 > $olsrLogFile
sleep 1
mgen input /sdcard/exp.mgen > $mgenLogFile
sleep 1
exit 0
