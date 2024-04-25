#!/bin/bash

#echo contents > filename.type       Overwrite the contents of the original file.
#echo contents >> filename.type     Additions tothe original document.
#sed -i 's/old_content/new_content/' filename.tpye  Replace the contents of the orginial file.

#network_conf path /etc/sysconfig/network-scripts/ifcfg-ens33,test ifcfg-ens33
network_PATH=~/ifcfg-ens33
     install 替换
sed -i 's/static/dhcp/' ~/ifcfg-ens33

sed -i 's/ONBOOT=no/ONBOOT=yes/' $network_path

#contents
c0=GATEWAY=192.168.30.2
c1=NETMASK=255.255.255.0
c2=DNS1=114.114.114.114
c3=DNS2=8.8.8.8

echo IPADDR=192.168.30.3 >> $network_path
echo $c0 >> $network_path
echo $c1 >> $network_path
echo $c2 >> $network_path
echo $c3 >> $network_path


