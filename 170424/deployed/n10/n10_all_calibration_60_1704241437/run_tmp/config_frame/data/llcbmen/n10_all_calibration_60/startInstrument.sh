#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <run_id> <exp_root> <exp_name> <monitor_interfaces>

Starts instrumentation for the experiment that can be started before
the NUT is running. Data is sent to <exp_root>/data/<run_id>

<run_id>: run_id for this experiment
<exp_root>: directory where harness files live
<exp_name>: name of the experiment
<monitor_interfaces>: space-separate list of interfaces
EOF
}

runId=$1
binDir=$2
expRoot=$3
expName=$4
basetime=$5
shift 5
beaconerInterval=0
doTCPdump="N"
while [ $# -gt 0 ] ; do
    if [ "$1" == "-b" ] ; then
	shift
	beaconerInterval=$1
	shift
	beaconList=$1
	shift
    elif [ "$1" == "-t" ] ; then
	doTCPdump="Y"
	shift
	dumpIfaceList=$1
	shift
    elif [ "$1" == "-i" ] ; then
	shift
        monitorIfaceList=$1
	shift
    else
	echo "Unexpected argument $1"
	shift
    fi
done

nodeName=$(cat /proc/sys/kernel/hostname)
nodeNum=$(echo $nodeName | sed -e 's/node//g' | sed -e 's/^0*//g')

mkdir -p ${expRoot}/data/${runId}/data/${nodeName}

echo $runId > /sdcard/current_runid.txt

# Start logcat to a file
lcFile=${expRoot}/data/${runId}/data/${nodeName}/logcat.log
logcat -v threadtime -f $lcFile < /dev/null > /dev/null 2>&1 &

monitorlog=${expRoot}/data/$runId/data/$nodeName/monitor.log
$binDir/$expName/monitor.sh $runId $expRoot $expName $monitorIfaceList > $monitorlog 2>&1 < /dev/null & 

basetimellg=${expRoot}/data/$runId/data/$nodeName/basetime.llg
echo "0,0,c.basetime,RunExp,${basetime}000,\"{\"\"time_secs\"\":${basetime}, \"\"runid\"\": \"\"${runId}\"\"}\"" > $basetimellg

if [ "$doTCPdump" == "Y" ]; then
    sleep 1
    for iface in ${dumpIfaceList//,/ } ; do
        pcapFile=${expRoot}/data/${runId}/data/${nodeName}/tcpdump_${iface}.pcap
        tcpdumpLog=${expRoot}/data/${runId}/data/${nodeName}/tcpdump_${iface}.log
        tcpdump -p -i $iface -s 128 -w $pcapFile > $tcpdumpLog 2>&1 &
    done
    sleep 1
fi

if [ $beaconerInterval -gt 0 ]; then
    for addrPair in ${beaconList//,/ } ; do
	addr=${addrPair/:*/}
	port=${addrPair/*:/}
	addrSafe=${addr//./_}
        sleep 0.$RANDOM
	beaconerllg=${expRoot}/data/${runId}/data/${nodeName}/beaconer_${addrSafe}.llg 
        beaconerlog=${expRoot}/data/${runId}/data/${nodeName}/beaconer_${addrSafe}.log 
#        beaconer -m -N -n $nodeName -i $beaconerInterval -a $addr -p $port -L $beaconerllg >& $beaconerlog  &
    done
fi

# FIXME think about error checking
exit 0


