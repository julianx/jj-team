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
clear
for i in ${PROTOCOLS}
do
  echo
  echo "Using: [1m[31m${i}[0m with ${i}:$(grep -A 1 "${PARAMETER}" ${CORE_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}')/"
  hdfs dfs -ls ${i}:$(grep -A 1 "${PARAMETER}" ${CORE_FILE} | awk -F"[<|>|,|:]" '/^ *<va/ {print $4}')/ 2>/dev/null
  echo
done
