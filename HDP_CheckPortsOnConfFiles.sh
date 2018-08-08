#!/bin/bash
#
CONF_DIR="/etc/hadoop/conf"
clear
echo "Start Checking on: [$(hostname -f)]"
echo
for i in $(netstat -putan | grep -i listen | egrep -i "python|java" | tr -s "      " " " | awk -F"[ |:]" '{print $5}')
do
   if grep ${i} ${CONF_DIR}/*.xml > /dev/null 2>&1
   then
      echo "Port ${i}: is Declared in:"
      grep -l ${i} ${CONF_DIR}/*.xml
      echo
   else
      echo -e "Port ${i}: It's open but not in the configuration files inside ${CONF_DIR} \n"
   fi
done
echo
echo "End of Check on: [$(hostname -f)]"
echo

