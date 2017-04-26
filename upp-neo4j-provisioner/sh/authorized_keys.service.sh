#!/usr/bin/env bash

OUTPUT="/var/log/jumpbox.log"
ROOTDIR='/opt/up'
mkdir -p ${ROOTDIR}
echo  "BEGIN - $(date)" | tee -a ${OUTPUT}
cd ${ROOTDIR}
if [[ -d "./upp-provisioners/upp-neo4j-provisioner" ]]; then
    cd upp-provisioners/upp-neo4j-provisioner/
    git pull
else
  git clone https://github.com/Financial-Times/upp-provisioners.git | tee -a ${OUTPUT}
  cd upp-provisioners/upp-neo4j-provisioner/
fi
sh/authorized_keys.sh | tee -a ${OUTPUT}
echo  "END - $(date)" | tee -a ${OUTPUT}
