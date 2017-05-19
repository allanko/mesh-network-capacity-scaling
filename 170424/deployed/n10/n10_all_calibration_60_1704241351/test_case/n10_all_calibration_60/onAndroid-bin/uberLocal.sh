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
startWait=$7

dataDir="${expRoot}/data/${runId}"
mkdir -p ${dataDir}/data/${nodeName}/

# redirect stdio
#exec 1<&-
#exec 2<&-
#exec 1>>"${dataDir}/data/${nodeName}/uberRun.log" 
#exec 2>&1

shift 7
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

echo "nodeName $nodeName"
echo "nodeNum $nodeNum"
echo "binDir $binDir"
echo "expRoot $expRoot"
echo "runId $runId"
echo "basetime $basetime"
echo "duration $duration"
echo "startWait $startWait"
echo "dataDir $dataDir"
echo "doAPK $doAPK"
echo "logFiles $logFiles"
echo "ifaces $ifaces"
echo "si2Args $si2Args"

echo
echo "Resetting at time $(date) = $(gettime)"
$binDir/$expName/reset.sh
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with reset.sh."
    ret=$(expr $ret + 1 )
fi

# Wait until startWait before basetime
echo "Waiting until prep time..."
$binDir/uberWait.sh $basetime -$startWait


echo "Starting uberLocal.sh at time $(date) = $(gettime) with basetime $basetime"
echo

echo "Starting instruments at time $(date) = $(gettime)"
$binDir/$expName/startInstrument.sh $runId $binDir $expRoot $expName $basetime -i $ifaces $si2Args
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startInstrument.sh."
    ret=$(expr $ret + 1 )
fi

# Wait until 30 seconds before basetime to start Exerciser
echo
$binDir/uberWait.sh $basetime -10

echo
echo "Starting scenario at time $(date) = $(gettime)"
$binDir/$expName/startScenario.sh $basetime $runId $expRoot $expName
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startScenario.sh."
    ret=$(expr $ret + 1 )
fi

# Wait until basetime + duration
echo
echo "Waiting through scenario duration..."
$binDir/uberWait.sh $basetime $duration

# cleanup

echo
echo "Stopping scenario at time $(date) = $(gettime)"
$binDir/$expName/stopScenario.sh
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopScenario.sh."
    ret=$(expr $ret + 1 )
fi

echo
$binDir/$expName/stopInstrument.sh $dataDir $logFiles
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopInstrument.sh."
    ret=$(expr $ret + 1 )
fi

echo
echo "FINISHED uberLocal.sh at time $(date) = $(gettime)"
echo

exit $ret

