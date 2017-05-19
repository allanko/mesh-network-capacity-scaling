#!/system/xbin/bash -login

waitUntil () {
untilTime=$1
currentTime=$(gettime)
sleepTime=$(dc $BASETIME $untilTime + $currentTime - p)
if [[ $sleepTime > 0 ]] ; then
   sleep $sleepTime
fi
}

Leave () {
currentTime=$(gettime)
am broadcast -a cbmen.comet.workflow.cascade.intent.action.cds.CDSService --es originalSquad leave
nodeName=$( cat /proc/sys/kernel/hostname )
currentTimeMillis=${currentTime/.*/}${currentTime: -6 : 3}
echo "Sent leave intent at epoch time $currentTime, scenario time $(dc $currentTime $BASETIME - p)"
am broadcast -a edu.mit.ll.NletLog --es name c.cascadeLeave --es source $nodeName.plannedDeparture --es timestamp $currentTimeMillis --es value '{}'
echo
}   

Join () {
currentTime=$(gettime)
am broadcast -a cbmen.comet.workflow.cascade.intent.action.cds.CDSService --es originalSquad join
nodeName=$( cat /proc/sys/kernel/hostname )
currentTimeMillis=${currentTime/.*/}${currentTime: -6 : 3}
echo "Sent join intent at epoch time $currentTime, scenario time $(dc $currentTime $BASETIME - p)"
am broadcast -a edu.mit.ll.NletLog --es name c.cascadeJoin --es source $nodeName.plannedDeparture --es timestamp $currentTimeMillis --es value '{}'
echo
}   

