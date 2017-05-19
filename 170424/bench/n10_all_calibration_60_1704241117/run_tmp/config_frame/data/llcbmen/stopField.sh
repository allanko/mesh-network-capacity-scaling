#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <bin dir> <<exp name> <data dir> <log files>

Executes stopCBMEN.sh, stopInstrument2.sh, and stopInstrument.sh back-to-back for efficient field operations.

EOF
}

binDir=$1
expName=$2
dataDir=$3
shift 3
logFiles=$@

nodeName=$(cat /proc/sys/kernel/hostname)



ret=0
$binDir/$expName/stopCBMEN.sh $expName
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopCBMEN.sh."
    ret=$(expr $ret + 1 )
fi

$binDir/stopInstrument2.sh
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopInstrument2.sh."
    ret=$(expr $ret + 1 )
fi

$binDir/stopInstrument.sh $dataDir $logFiles
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with stopInstrument.sh."
    ret=$(expr $ret + 1 )
fi

exit $ret

