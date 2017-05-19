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
shift
expRoot=$1
shift
expName=$1
shift
iface1=$1
shift
iface2=$1
shift
ifacesRest=$@

nodeName=$(cat /proc/sys/kernel/hostname)

mkdir -p ${expRoot}/data/${runId}/data/${nodeName}

echo $runId > /sdcard/current_runid.txt

export BOOTCLASSPATH=/system/framework/core.jar:/system/framework/core-junit.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/mms-common.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/apache-xml.jar:/system/framework/telephony-msim.jar

# Start logcat to a file
lcFile=${expRoot}/data/${runId}/data/${nodeName}/logcat.log
logcat -v threadtime -f $lcFile < /dev/null > /dev/null 2>&1 &

# Start logger service
PN=edu.mit.ll.NletLog.android
am startservice -a android.intent.action.MAIN -n ${PN}/.LoggerService \
  --es ${PN}.LOG_FILE_NAME ${expRoot}/data/${runId}/data/${nodeName}/logger.llg \
  --es ${PN}.CFG_FILE_NAME ${expRoot}/${expName}/Logger.json

# Start monitor service
PN=edu.mit.ll.cbmen.monitor
if [ -z $iface1 ]; then
   am startservice -a android.intent.action.MAIN -n $PN/$PN.MonitorService \
        --es $PN.COMMAND StartMonitor \
        --es $PN.NODE_NAME $nodeName \
        --ei $PN.INTERVAL 2000    
elif [ -z $iface2 ]; then
   am startservice -a android.intent.action.MAIN -n $PN/$PN.MonitorService \
        --es $PN.COMMAND StartMonitor \
        --es $PN.IF1_NAME $iface1 \
        --es $PN.NODE_NAME $nodeName \
        --ei $PN.INTERVAL 2000
elif [ -z "$ifacesRest" ]; then
   am startservice -a android.intent.action.MAIN -n $PN/$PN.MonitorService \
        --es $PN.COMMAND StartMonitor \
        --es $PN.IF1_NAME $iface1 \
        --es $PN.IF2_NAME $iface2 \
        --es $PN.NODE_NAME $nodeName \
        --ei $PN.INTERVAL 2000
else
   ifacelist=${ifacesRest// /,}
   am startservice -a android.intent.action.MAIN -n $PN/$PN.MonitorService \
        --es $PN.COMMAND StartMonitor \
        --es $PN.IF1_NAME $iface1 \
        --es $PN.IF2_NAME $iface2 \
        --es $PN.IF_NAME $ifacelist \
        --es $PN.NODE_NAME $nodeName \
        --ei $PN.INTERVAL 2000
fi

# FIXME think about error checking
exit 0


