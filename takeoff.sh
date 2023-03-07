#!/bin/sh /etc/rc.common

START=99
STOP=15

start() {

  cpuUsage=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
  ramUsage=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
  romUsage=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')

echo  " CPU: $cpuUsage RAM: $ramUsage HDD: $romUsage"
echo  " -------------------------------------DHCP------------------------------------"
echo -e " IP Address\tName\tMAC Address"
for interface in `iw dev | grep Interface | cut -f 2 -s -d" "`
do

  maclist=`iw dev $interface station dump | grep Station | cut -f 2 -s -d" "`

  for mac in $maclist
  do

    ip="UNKN"
    host=""
    ip=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 2 -s -d" "`
    host=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 3 -s -d" "`

    echo -e " $ip\t$host\t$mac"
  done
done

}

stop() {
        echo stop
}