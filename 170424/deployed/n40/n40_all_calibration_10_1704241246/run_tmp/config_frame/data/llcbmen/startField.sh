#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <bin dir> <exp root> <exp name> <run id> <ifaces> [startInstrument2.sh options]

Executes resetCBMEN.sh, startInstrument.sh, startInstrument2.sh, and startCBMEN.sh back-to-back for efficient field operations.

ifaces is the list of interfaces for startInstrument.sh, but comma-separated

EOF
}

binDir=$1
expRoot=$2
expName=$3
runId=$4
ifacesComma=$5
shift 5
si2Args=$@

nodeName=$(cat /proc/sys/kernel/hostname)

ret=0
$binDir/$expName/resetCBMEN.sh $expName $runId
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with resetCBMEN.sh."
    ret=$(expr $ret + 1 )
fi

ifaces=${ifacesComma//,/ }
$binDir/startInstrument.sh $runId $expRoot $expName $ifaces
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startInstrument.sh."
    ret=$(expr $ret + 1 )
fi


$binDir/startInstrument2.sh $runId $expRoot $expName $si2Args
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startInstrument2.sh."
    ret=$(expr $ret + 1 )
fi

$binDir/$expName/startCBMEN.sh $expName
if [ ! $? ] ; then
    echo "$0:$nodeName: ERROR: Problem with startCBMEN.sh."
    ret=$(expr $ret + 1 )
fi

exit $ret

