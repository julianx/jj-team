#!/bin/bash
#
# Author: Jimmy D. Garagorry A. | jgaragorry@hortonworks.com | Technical Support Engineer
HDFS_FILE="/etc/hadoop/conf/hdfs-site.xml"
CORE_FILE="/etc/hadoop/conf/core-site.xml"
PROTOCOLS="hdfs webhdfs"
PARAMETER="fs.defaultFS"
HA_Nodes="$(grep -A 1 dfs.ha.namenodes ${HDFS_FILE} | awk -F"[<|>|,]" '/^ *<va/ {print $3,$4}')"
#HA_Service="$(grep -A 1 dfs.nameservices ${CORE_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}')"
HOST_RUNNING=$(hostname -f)

for i in ${HA_Nodes}
do
   for h in $(grep -A 1 "\.$i" ${HDFS_FILE} | awk -F "[<|>|:]" '/^ *<val/ {print $3}' | sort | uniq)
   do
      if [[ ${h} == ${HOST_RUNNING} ]]
      then
         HA_SERVICE_ID=${i}
      fi
   done
done

for i in ${PROTOCOLS}
do
   HA_NODE_STATE=$(su -l hdfs -c "hdfs haadmin -getServiceState ${HA_SERVICE_ID}")
   if [[ ${HA_NODE_STATE} != standby ]]
   then
      echo
      echo "Using: [1m[31m${i}[0m with ${i}:$(grep -A 1 "${PARAMETER}" ${CORE_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}')/"
      hdfs dfs -ls ${i}:$(grep -A 1 "${PARAMETER}" ${CORE_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}')/ 2>/dev/null
   else
      echo "Excecute this command from a node different to ${HA_NODE_STATE} state"
      exit 1
   fi
done
