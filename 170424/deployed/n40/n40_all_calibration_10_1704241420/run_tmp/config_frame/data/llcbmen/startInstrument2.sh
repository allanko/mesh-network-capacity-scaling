#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <run_id> <exp_root> <exp_name> [-b <beaconer interval> <addr>,<addr>,<addr>] [-t <tcpdump_interface>,<tcpdump_intervace>]

Starts instrumentation for the experiment that must be started after
the NUT is running. Data is sent to <exp_root>/data/<run_id>/data/<node>

<run_id>: run_id for this experiment
<exp_root>: directory where harness files live
<exp_name>: name of the experiment
EOF
}

runId=$1
expRoot=$2
expName=$3
shift 3

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
	interfaceList=$1
	shift
    else
	echo "Unexpected argument $1"
	shift
    fi
done

nodeName=$(cat /proc/sys/kernel/hostname)

mkdir -p ${expRoot}/data/${runId}/data/${nodeName}

if [ "$doTCPdump" == "Y" ]; then
    sleep 1
    for iface in ${interfaceList//,/ } ; do
        tcpdump -p -i $iface -s 128 -w ${expRoot}/data/${runId}/data/${nodeName}/tcpdump_${iface}.pcap > ${expRoot}/data/${runId}/data/${nodeName}/tcpdump_${iface}.log 2>&1 &
    done
    sleep 1
fi

if [ $beaconerInterval -gt 0 ]; then
    for addrPair in ${beaconList//,/ } ; do
	addr=${addrPair/:*/}
	port=${addrPair/*:/}
	addrSafe=${addr//./_}
        sleep 0.$RANDOM
	beaconer -m -N -n $nodeName -i $beaconerInterval -a $addr -p $port -L ${expRoot}/data/${runId}/data/${nodeName}/beaconer_${addrSafe}.llg >&  ${expRoot}/data/${runId}/data/${nodeName}/beaconer_${addrSafe}.log &
    done
fi

# FIXME think about error checking
exit 0
