#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <bin dir> <exp root> <exp name> <run id> <basetime> <duration> [-a <apkPairs] [-l <logFiles>] [-i <ifaces>] 
[-b <beaconerInterval> <beaconerNeighbors>] [-t <tcpdumpInterfaces>] 

Executes an entire run.

EOF
}

nodeName=$(cat /proc/sys/kernel/hostname)
nodeNum=$(echo $nodeName | sed -e 's/node//g' | sed -e 's/^0*//g')

binDir=$1
expRoot=$2
expName=$3
runId=$4
basetime=$5
duration=$6

dataDir="${expRoot}/data/${runId}"
mkdir -p ${dataDir}/data/${nodeName}/

# redirect stdio
exec 1<&-
exec 2<&-
exec 1>>"${dataDir}/data/${nodeName}/uberRun.log" 
exec 2>&1

shift 6
doAPK="N"
logFiles=""
ifaces=""
si2Args=""
while [ $# -gt 0 ] ; do
    if [ "$1" == "-b" ] ; then
	si2Args="$si2Args $1 $2 $3"
	shift 3
    elif [ "$1" == "-t" ] ; then
	si2Args="$si2Args $1 $2"
	shift 2
    elif [ "$1" == "-a" ] ; then
	doAPK="Y"
	apkList=$2
	apkList=${apkList//,/ }
	shift 2
    elif [ "$1" == "-l" ] ; then
	logFiles=$2
	logFiles=${logFiles//,/ }
	shift 2
    elif [ "$1" == "-i" ] ; then
	ifaces=$2
	ifaces=${ifaces//,/ }
	shift 2
    else
	echo "Unexpected argument $1"
	shift
    fi
done

ret=0

echo "Starting uberRun3.sh at time $(date) = $(gettime) with basetime $basetime"
echo

# Clear logcat and install APKs
logcat -c
if [ $doAPK == "Y" ] ; then
    $binDir/installAPK.sh $apkList
fi
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with installAPKs.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/$expName/resetCBMEN.sh $expName $runId
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with resetCBMEN.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/startInstrument.sh $runId $expRoot $expName $ifaces
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startInstrument.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/$expName/start_wifi_node.sh $nodeNum
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with start_wifi_node.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/startInstrument2.sh $runId $expRoot $expName $si2Args
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startInstrument2.sh."
    ret=$(expr $ret + 1 )
fi

# Wait until 5 minutes before basetime
echo
$binDir/uberWait.sh $basetime -60

echo
echo "Starting CBMEN at time $(date) = $(gettime)"
echo
$binDir/$expName/startCBMEN.sh $expName
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startCBMEN.sh."
    ret=$(expr $ret + 1 )
fi

# Wait until 30 seconds before basetime to start Exerciser
echo
$binDir/uberWait.sh $basetime -30

echo
echo "Starting scenario at time $(date) = $(gettime)"
echo
$binDir/$expName/startScenario.sh $basetime $runId $expName
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startScenario.sh."
    ret=$(expr $ret + 1 )
fi

# Wait until basetime + duration
echo
echo "Waiting through scenario duration..."
$binDir/uberWait.sh $basetime $duration

# cleanup

# Stop scenario
echo
echo "Stopping scenario at time $(date) = $(gettime)"
echo
$binDir/$expName/stopScenario.sh
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopScenario.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/$expName/stopCBMEN.sh $expName
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopCBMEN.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/stopInstrument2.sh
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopInstrument2.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/stopInstrument.sh $dataDir $logFiles
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopInstrument.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/$expName/stop_wifi_node.sh
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stop_wifi_node.sh."
    ret=$(expr $ret + 1 )
fi

echo
echo "FINISHED uberRun3.sh at time $(date) = $(gettime)"
echo

exit $ret

