# OpenWRT-CLI-SSH-Onload-Info-Script
My personal after SSH/UCI authorization info script about CPU/RAM/HDD/DHCP connected devices via WiFi for Asus RT-AX53U OpenWRT 22.03 CLI/SSH.

![ss1](https://user-images.githubusercontent.com/85984736/223528502-2230d915-a436-4726-ad4c-c4c6d1f2ecbf.png)
</br>
1) USA/NSA Prism Logo/ASCII Art from /etc/banner -> https://github.com/semazurek/OpenWRT-Banner-NSA
2) Script Showing CPU/RAM/HDD(ROM) + WiFi DHCP -> /etc/init.d/takeoff.sh
```shell
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
```

3)Making it executable:

```shell
chmod +x /etc/init.d/takeoff
```

4)Enable takeoff service:

```shell
service takeoff enable
```

5)Adding **&& /etc/init.d/takeoff.sh** into /etc/profile:

```shell
vi /etc/profile
```

```shell
[ -f /etc/banner ] && cat /etc/banner && /etc/init.d/takeoff start
```
