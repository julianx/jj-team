#!/usr/bin/env bash
export KAFKA_ZOOKEEPER=localhost.localdomain:2181   # $(awk -F "=" '/zookeeper.connect=/ {print $NF}' /etc/kafka/conf/server.properties)
export KAFKA_SERVERS=localhost.localdomain:6667     # $(awk -F "[=|:|//]" '/listeners/ {print $5":"$NF}' /etc/kafka/conf/server.properties)
export PROTOCOL=PLAINTEXT                           # $(awk -F "[=|:|//]" '/listeners/ {print $2}' /etc/kafka/conf/server.properties)
export KAFKA_CONSUMER_GROUP=atlas

while true
do
    echo `date` " " `/usr/hdp/current/kafka-broker/bin/kafka-consumer-groups.sh --describe --bootstrap-server "${KAFKA_SERVERS}" --group ${KAFKA_CONSUMER_GROUP} --security-protocol $PROTOCOL | fgrep ATLAS_HOOK`
sleep 60
done >> kafkaProgress.txt

# =========================

# chmod +x kafkaScript.sh
# nohup ./kafkaScript.sh &
# tail -f kafkaScript.sh