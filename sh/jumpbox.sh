#!/bin/bash

OUTPUT="/var/log/jumpbox.log"
ROOTDIR='/tmp'
echo  "BEGIN - $(date)" >> ${OUTPUT}
# Update Name tag
if [[ "$(ping -c 1 -w 1 169.254.169.254 ; echo $?)" -ne "1" ]]; then
  echo "Setting hostname in AWS console" >> ${OUTPUT}
  /usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) delete-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name
  /usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) create-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=$(wget -q -O - http://169.254.169.254/latest/meta-data/hostname)
  echo "Hostname set" >> ${OUTPUT}
  # Install packages for deployment
  /usr/bin/yum install -y puppet3 git >> ${OUTPUT}
  puppet --version >> ${OUTPUT}
  git --version >> ${OUTPUT}
else
  echo "Host 169.254.169.254 not responding. Skipping tagging." >> ${OUTPUT}
fi

cd ${ROOTDIR}
if [[ -d "./up-neo4j-ha-cluster" ]]; then
    cd up-neo4j-ha-cluster/
    git pull
else
  git clone https://github.com/Financial-Times/up-neo4j-ha-cluster.git >> ${OUTPUT}
  cd up-neo4j-ha-cluster/
fi

puppet apply --modulepath ./puppet -e "class { 'neo4jha::jumpbox': }" >> ${OUTPUT}
sh/authorized_keys.sh
echo  "END - $(date)" >> ${OUTPUT}
