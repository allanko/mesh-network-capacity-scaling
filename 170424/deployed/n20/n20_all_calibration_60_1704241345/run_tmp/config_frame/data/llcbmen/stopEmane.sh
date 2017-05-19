#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 

Stop emane on this node.
EOF
}

nodeName=`cat /proc/sys/kernel/hostname`

killall emanetransportd

#PN=edu.mit.ll.LLLocation
#am force-stop $PN

# FIXME think about error catching
exit 0
