#!/system/xbin/bash -login

usage () {
echo "$0"
}

killall tcpdump
killall gcn
killall beaconer
killall olsrd
killall mgen
killall monitor.sh
killall babeld
killall edu.mit.ll.NletLog.android 
killall edu.mit.ll.cbmen.monitor 

exit 0 
