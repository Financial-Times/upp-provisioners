#!/bin/bash

OUTPUT="/tmp/deployment.log"

echo  "BEGIN - $(date)" > ${OUTPUT}
puppet --version >> ${OUTPUT}
git --version >> ${OUTPUT}

cd /tmp
git clone https://github.com/Financial-Times/up-neo4j-ha-cluster.git
cd up-neo4j-ha-cluster/
sudo puppet apply --modulepath ./puppet -e "class { 'neo4jha': profile => 'prod' }"
echo  "END - $(date)" >> ${OUTPUT}
