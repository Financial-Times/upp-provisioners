#!/usr/bin/env bash

OUTPUT="/var/log/jumpbox.log"
ROOTDIR='/opt/up'
mkdir -p ${ROOTDIR}

echo  "BEGIN - $(date)" | tee -a ${OUTPUT}
cd ${ROOTDIR}
if [[ -d "./up-neo4j-ha-cluster" ]]; then
    cd up-neo4j-ha-cluster/
    git pull
else
  git clone https://github.com/Financial-Times/up-neo4j-ha-cluster.git | tee -a ${OUTPUT}
  cd up-neo4j-ha-cluster/
fi

/usr/bin/curl -s https://raw.githubusercontent.com/Financial-Times/up-neo4j-ha-cluster/master/sh/authorized_keys.sh | /bin/bash | tee -a ${OUTPUT}
