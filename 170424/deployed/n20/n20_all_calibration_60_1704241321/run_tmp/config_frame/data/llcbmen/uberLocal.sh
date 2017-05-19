#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <bin dir> <exp root> <exp name> <run id> <basetime> <duration> [-a <apkPairs] [-l <logFiles>] [-i <ifaces>] 
[-b <beaconerInterval> <beaconerNeighbors>] [-t <tcpdumpInterfaces>] 

Executes an entire run.

EOF
}

nodeName=$(cat /proc/sys/kernel/hostname)

binDir=$1
expRoot=$2
expName=$3
runId=$4
basetime=$5
duration=$6
allargs=$*

dataDir="${expRoot}/data/${runId}"
mkdir -p ${dataDir}/data/${nodeName}/

# redirect stdio
exec 1<&-
exec 2<&-
exec 1>>"${dataDir}/data/${nodeName}/uberRun.log" 
exec 2>&1

ret=0

echo "Starting uberLocal.sh at time $(date) = $(gettime) with basetime $basetime"
echo

echo
echo $allargs >> multiRunList.txt
#(nohup $binDir/$expName/uberLocal.sh $allargs > ${dataDir}/data/${nodeName}/uberLocal.log 2>&1 < /dev/null &  ) & disown
$binDir/$expName/uberLocal.sh $allargs > ${dataDir}/data/${nodeName}/uberLocal.log 2>&1 < /dev/null &
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with uberLocal.sh."
    ret=$(expr $ret + 1 )
fi

# Wait until experiment done
echo "leaving..."
#$binDir/uberWait.sh $basetime $duration

exit $ret

