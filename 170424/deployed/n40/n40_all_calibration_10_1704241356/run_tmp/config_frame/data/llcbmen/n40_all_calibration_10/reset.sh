#!/system/xbin/bash -login

usage () {
cat <<EOF
reset experiment
EOF
}

ret=0

CBMENPKG="cbmen.comet.workflow.cascade"
pm uninstall ${CBMENPKG}

# Delete COMET log files
rm /sdcard/node*.log /sdcard/*.json

killall gcn
killall beaconer
killall olsrd
killall mgen
killall monitor.sh
killall babeld
killall edu.mit.ll.NletLog.android 
killall edu.mit.ll.cbmen.monitor 
killall mchttpd
rm -r /sdcard/cascade
rm -r /sdcard/CBMEN
rm -r /sdcard/llcbmen/ISI # Exerciser temporary files
rm -r /sdcard/Android/data/cbmen.comet.workflow.cascade
rm /sdcard/registrar.db
rm -f /sdcard/pparams /sdcard/abealphabet.xml /sdcard/policyfilter.xml /sdcard/abekey-*
rm -f /sdcard/cbmen.properties
rm -f /sdcard/static_neighbors.txt

# Clear logcat and install APKs
logcat -c

exit $ret
