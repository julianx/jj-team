#!/bin/bash

if [[ $# -eq 3 ]]
then
    export AMBARI_USER=$2
    export AMBARI_PASSWORD=$3
    export AMBARI_PORT=8080
    export AMBARI_HOST=$1
    export AMBARI_CREDS="$AMBARI_USER:$AMBARI_PASSWORD"
    export AMBARI_URLBASE="http://${AMBARI_HOST}:${AMBARI_PORT}/api/v1/clusters"
    export CLUSTER_NAME="$(curl —silent -u ${AMBARI_CREDS} -i -H 'X-Requested-By:ambari' ${AMBARI_URLBASE} | sed -n 's/.*"cluster_name" : "\([^\"]*\)".*/\1/p')"
    export AMBARI_URLCLUSTER=${AMBARI_URLBASE}/${CLUSTER_NAME}
    curl —silent -u ${AMBARI_CREDS} -i -H 'X-Requested-By:ambari' ${AMBARI_URLBASE}/${CLUSTER_NAME}/services > ${CLUSTER_NAME}.services
else
    echo "Usage: $0 AMBARI_HOST AMBARI_USER AMBARI_PASSWORD"
    exit 1
fi
