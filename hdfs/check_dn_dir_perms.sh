#!/bin/bash
#
for Nodes in $(su -l hdfs -c "hdfs dfsadmin -report" | awk '/^Hostname:/ {print $NF}')
do
  echo ${Nodes}
  for DataNode in $(ssh root@${Nodes} "grep -C 2 'dfs.datanode.data.dir<' /etc/hadoop/conf/hdfs-site.xml | awk -F '[<|>]' '/value/ {print \$3}' | sed 's|,| |g'")
  do
   namei -l ${DataNode}
   echo
  done
done
