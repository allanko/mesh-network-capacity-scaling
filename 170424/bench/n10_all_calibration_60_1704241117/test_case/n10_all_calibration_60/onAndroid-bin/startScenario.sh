#!/system/xbin/bash -login

usage () {
echo "$0 <start_time> <runid> <exp_name>"
echo "<start_time>: time zero for this experiment in seconds since the epoch"
echo "Starts the scenario by launching the exerciser."
}

basetime=$1
runid=$2
expRoot=$3
expName=$4
nodeName=`cat /proc/sys/kernel/hostname`
nodeNum=$(echo $nodeName | sed -e 's/node//g' | sed -e 's/^0*//g')

runScripts=$( ls ${expRoot}/${expName}/$nodeName/run*.sh | sort)

for r in $runScripts;
do
   bash $r $nodeName $nodeNum $runid $expRoot $expName $basetime
done

exit 0
