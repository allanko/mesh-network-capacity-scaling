#!/system/xbin/bash

vpnHost=134.207.254.115
phoneSerial=$(/system/bin/getprop ro.serialno)
try=0

# begin loop

while /system/xbin/true; do
  try=$(expr $try + 1)

  # detect if our vpnHost is reachable
  if ! /system/bin/ping -c 1 -w 1 $vpnHost > /dev/null; then
    /system/bin/sleep 1
    continue
  fi

  # put our serial number
  echo "[!] logging serial number to vpn server"
  printf "$(date) - loop count %.5i - $phoneSerial - Hello vpn server\n" $try | /system/xbin/ssh -y -i /data/llcbmen/id_rsa phonevpn@${vpnHost} "cat >> ~/phonelog.log"

  # look up my host number on the vpn Server
  echo "[!] Looking up my node number on $vpnHost"
  nodeNumber=$(/system/xbin/ssh -y -i /data/llcbmen/id_rsa phonevpn@${vpnHost} "grep $phoneSerial ~/hostList" | tail -1 | awk '{print $2}')
  #nodeNumber=$(grep ${phoneSerial} /data/llcbmen/hostList | awk '{print $2}')

  if [ -z "${nodeNumber}" ]; then
    echo "Missing my node number.  Sleeping and will try again in 30"
    printf "$(date) - loop count %.5i - $phoneSerial - missing node number, will try again in 30 seconds\n" $try | /system/xbin/ssh -y -i /data/llcbmen/id_rsa phonevpn@${vpnHost} "cat >> ~/phonelog.log"
    /system/bin/sleep 30
  else
    echo "[!] establishing vpn"
    #printf "$(date) - loop count %.5i - $phoneSerial - node %i vpn established\n" $try $nodeNumber | 
    ssh -R $(printf "2%.3i" $nodeNumber):127.0.0.1:22 -y -i /data/llcbmen/id_rsa phonevpn@${vpnHost} "~/vpnwatch.sh $try $phoneSerial $nodeNumber"
  fi
done
