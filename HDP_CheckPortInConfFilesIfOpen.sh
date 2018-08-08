#!/bin/bash
#
# Author: Jimmy D. Garagorry A. | jgaragorry@hortonworks.com | Technical Support Engineer

CONF_DIR="/etc/hadoop/conf"
clear
echo "[1m[34mStart Checking on:[0m [$(hostname -f)]"
echo
for i in ${CONF_DIR}/*.xml
do
   if egrep "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:" ${i} >/dev/null 2>&1
   then
      echo -e "Reading ${i} \n"
      for ports in $(egrep "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:" ${i} | awk -F"[<|>|:]" '{print $4}')
      do
         if lsof -i :${ports} > /dev/null 2>&1
         then
            echo "Port Number: [1m[31m${ports}[0m is open and listening"
            echo -e "Configured by: [1m[31m$(egrep -B 1 "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:$ports" ${i} | awk -F"[<|>|:]" '/^ *<na/ {print $3}')[0m in [1m[31m${i}[0m \n"
         else
            echo -e "Port Number: [1m[31m${ports}[0m is closed but configuerd in ${i} \n"
         fi
      done
   fi
done
