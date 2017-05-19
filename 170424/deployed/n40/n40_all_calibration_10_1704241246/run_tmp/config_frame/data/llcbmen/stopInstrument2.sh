#!/system/xbin/bash -login

usage () {
cat <<EOF
$0

Stop instrumentation2 for the experiment.
EOF
}


# Stop TCP Dumps
# let this go
killall -q tcpdump

# Stop beaconer
# want to see in forensics if this one fails, but nothing to do about it probably
killall beaconer

exit 0
