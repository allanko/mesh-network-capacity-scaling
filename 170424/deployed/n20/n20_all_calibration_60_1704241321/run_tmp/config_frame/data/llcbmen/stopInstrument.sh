#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <datadir> [<logfile> [<logfile>]]

datadir: data directory for this run, without the data/<node> part
Stop instrumentation for the experiment.
EOF
}

datadir=$1
shift
firstFile=$1
logFiles=$@

nodeName=$(cat /proc/sys/kernel/hostname)

# Stop monitor service
PN=edu.mit.ll.cbmen.monitor
am startservice -a android.intent.action.MAIN -n $PN/$PN.MonitorService \
     --es $PN.COMMAND StopMonitor

# Stop logger service
PN=edu.mit.ll.NletLog.android
am startservice -a android.intent.action.MAIN -n $PN/.LoggerService \
  --ez $PN.STOP_SERVICE true

# collect logs from various places
mkdir -p ${datadir}/data/${nodeName}
if [ ! -z "$firstFile" ]; then
    for file in $logFiles; do
	cp $file ${datadir}/data/${nodeName}
    done
fi

# logcat buffer is finite so we collect it as we go
killall logcat

# FIXME think about error checking
exit 0
