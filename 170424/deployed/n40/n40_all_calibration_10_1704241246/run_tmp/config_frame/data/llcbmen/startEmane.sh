#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <experiment root> <experiment name> <run id>

Start emane on this node.
EOF
}
EXP_ROOT=$1
EXP_NAME=$2
runId=$3

nodeName=`cat /proc/sys/kernel/hostname`

mkdir -p ${EXP_ROOT}/data/${runId}/data/${nodeName}/

echo "Starting emanetransportd on node $nodeName"
LOGFILE=${EXP_ROOT}/data/${runId}/data/${nodeName}/emanetransportd.log
CONFIGFILE=${EXP_ROOT}/${EXP_NAME}/EMANE/transportdaemon_${nodeName}.xml

emanetransportd -d --logl 3 --logfile $LOGFILE $CONFIGFILE > /dev/null &

#PN=edu.mit.ll.LLLocation
#am startservice -n $PN/$PN.LocationSetter

echo "done."

# FIXME think about error catching
exit 0
