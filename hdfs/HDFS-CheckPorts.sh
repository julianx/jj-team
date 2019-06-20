#!/bin/bash
#
# Author: Jimmy D. Garagorry A. | jgaragorry@hortonworks.com | Technical Support Engineer
HDFS_FILE="/etc/hadoop/conf/hdfs-site.xml"
CORE_FILE="/etc/hadoop/conf/core-site.xml"
NODES_TYPE="datanode journalnode namenode"
PROTOCOL_LIST="http https"
HA_Nodes="$(grep -A 1 dfs.ha.namenodes ${HDFS_FILE} | awk -F"[<|>|,]" '/^ *<va/ {print $3,$4}')"
HA_Service="$(grep -A 1 dfs.nameservices ${HDFS_FILE} | awk -F"[<|>|,]" '/^ *<va/ {print $3}')"

echo "[1mRunning on $(hostname -f)[0m"

for h in ${NODES_TYPE}
do
  echo "[1m[45m[33m${h}[0m"
  for i in ${PROTOCOL_LIST}
  do
    if [[ ${h} != "namenode" ]]
    then
      echo -n "${i} -> $(egrep -A 1 "dfs.${h}.${i}.address" ${HDFS_FILE} | awk -F"[<|>|,|:]" '/^ *<na/ {print $3,": "}')"
      echo -n "$(egrep -A 1 "dfs.${h}.${i}.address" ${HDFS_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}')"
      if lsof -i :$(egrep -A 1 "dfs.${h}.${i}.address" ${HDFS_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}') > /dev/null 2>&1
      then
        echo " [1m[34m[RUNNING][0m"
      else
        echo " [1m[31m[NOT RUNNING][0m"
      fi
    else
      for j in ${HA_Nodes}
      do
	echo -n "${i} -> $(egrep -A 1 "dfs.${h}.${i}-address.${HA_Service}.${j}" ${HDFS_FILE} | awk -F"[<|>|,|:]" '/^ *<na/ {print $3": "}')"
	echo -n "$(egrep -A 1 "dfs.${h}.${i}-address.${HA_Service}.${j}" ${HDFS_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}')"
        if lsof -i :$(egrep -A 1 "dfs.${h}.${i}-address.${HA_Service}.${j}" ${HDFS_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}') > /dev/null 2>&1
        then
          echo " [1m[34m[RUNNING][0m"
        else
          echo " [1m[31m[NOT RUNNING][0m"
        fi
        done
    fi
  done
done
