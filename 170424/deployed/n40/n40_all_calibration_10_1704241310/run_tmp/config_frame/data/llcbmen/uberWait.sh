#!/system/xbin/bash -login

usage () { 
cat <<EOF
$0 <basetime> <offset>

Waits until time basetime + offset arrives. Returns immediately if basetime + offset is in the past. basetime is in Epoch time. offset is in seconds and can be either positive or negative.
EOF
}

basetime=$1
offset=$2

currentTime=$(gettime)
sleepTime=$(dc $basetime $offset + $currentTime - p)
if [[ $sleepTime > 0 ]] ; then
    echo "Sleeping $sleepTime sec until basetime + $offset = $(dc $basetime $offset + p)"
    sleep $sleepTime
else
    echo "Skipping ahead because basetime + $offset = $(dc $basetime $offset + p) is in the past."
fi
