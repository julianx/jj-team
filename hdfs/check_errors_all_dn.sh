#!/bin/bash
# This script get the DN list from the "hdfs dfsadmin -report" and execute for each DN the command "grep -i error /var/log/message*" to double check for I/O errors (Hardware errors)
# hdfs user must have sudo permissions to read /var/log/messages
for Nodes in $(su -l hdfs -c "hdfs dfsadmin -report" | awk '/^Hostname:/ {print $NF}')
do
  echo "=================================================================================================" >> /tmp/Case00183485-os-messages-$(date +%m%d%y).out
  echo ${Nodes} >> /tmp/Case00183485-os-messages-$(date +%m%d%y).out
  echo "=================================================================================================" >> /tmp/Case00183485-os-messages-$(date +%m%d%y).out
  echo >> /tmp/Case00183485-os-messages-$(date +%m%d%y).out
  ssh root@${Nodes} "grep 'I/O error' /var/log/message*" >> /tmp/Case00183485-os-messages-$(date +%m%d%y).out
  echo >> /tmp/Case00183485-os-messages-$(date +%m%d%y).out


  echo "=================================================================================================" >> /tmp/Case00183485-os-dmesg-$(date +%m%d%y).out
  echo ${Nodes} >> /tmp/Case00183485-os-dmesg-$(date +%m%d%y).out
  echo "=================================================================================================" >> /tmp/Case00183485-os-dmesg-$(date +%m%d%y).out
  echo >> /tmp/Case00183485-os-dmesg-$(date +%m%d%y).out
  ssh root@${Nodes} "dmesg" >> /tmp/Case00183485-os-dmesg-$(date +%m%d%y).out
  echo
done
