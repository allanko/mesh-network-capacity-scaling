#!/system/xbin/bash -login

runId=$1
expRoot=$2
expName=$3
iface=$4

nodeName=$(cat /proc/sys/kernel/hostname)
nodeNum=$(echo $nodeName | sed -e 's/node//g' | sed -e 's/^0*//g')

routelog=${expRoot}/data/$runId/data/$nodeName/routes.log
ratellg=${expRoot}/data/$runId/data/$nodeName/rates.llg

c=0
while [ "0" -lt "1" ];
do
c=$(( $c + 1 ))
devStats=$(cat /proc/net/dev | grep $iface)
devStatsArr=($(echo $devStats | sed -e 's/://g' -e 's/ /\n/g'))

tsus=$(gettime)
tsms=$(echo $tsus | awk '{printf "%.0f", $1*1000}')
echo "0,$c,c.netIfCount.$iface,$nodeName.LLMonitor,$tsms,\"{\"\"txPkts\"\":${devStatsArr[10]},\"\"txBytes\"\":${devStatsArr[9]},\"\"rxPkts\"\":${devStatsArr[2]},\"\"rxBytes\"\":${devStatsArr[1]}}\"" >> $ratellg

echo $(gettime) >> $routelog
route -n >> $routelog
sleep 2
done
