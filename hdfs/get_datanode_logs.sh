#!/bin/bash
## Execute in each datanode
#Name: 10.182.71.142:50010 (oswego-pdn3008.amers.ibechtel.com)
#Name: 10.182.69.184:50010 (oswego-pdn3001.amers.ibechtel.com)
#Name: 10.182.69.169:50010 (oswego-pdn3010.amers.ibechtel.com)
#Name: 10.182.71.72:50010 (oswego-pdn3002.amers.ibechtel.com)
#Name: 10.182.69.241:50010 (oswego-pdn3004.amers.ibechtel.com)
#Name: 10.182.71.127:50010 (oswego-pdn3009.amers.ibechtel.com)
#Name: 10.182.70.217:50010 (oswego-pdn3005.amers.ibechtel.com)
#Name: 10.182.71.103:50010 (oswego-pdn3003.amers.ibechtel.com)
#Name: 10.182.68.15:50010 (oswego-pdn3007.amers.ibechtel.com)
#Name: 10.182.71.245:50010 (oswego-pdn3006.amers.ibechtel.com)

HOSTNAME=$(hostname -f)
OUTPUT_FILE=/mnt/data01/${HOSTNAME}.tgz
OUTPUT_DIR=${HOSTNAME}_HWX
mkdir $OUTPUT_DIR
cp /var/log/messages* $OUTPUT_DIR
dmesg >> $OUTPUT_DIR/dmesg.out
df -h >> $OUTPUT_DIR/df.out
cp -r /var/log/hadoop/hdfs $OUTPUT_DIR

tar cvzf $OUTPUT_FILE $OUTPUT_DIR
