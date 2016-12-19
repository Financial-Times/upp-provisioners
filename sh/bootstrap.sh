#!/bin/bash

OUTPUT="/tmp/bootstrap.log"

echo  "BEGIN - $(date)" > ${OUTPUT}
# Update Name tag
echo "Setting hostname in AWS console" >> ${OUTPUT}
/usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) delete-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name
/usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) create-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=$(wget -q -O - http://169.254.169.254/latest/meta-data/hostname)
echo "Hostname set" >> ${OUTPUT}
# Create ext4 filesystem on EBS volume
/sbin/mkfs.ext4 /dev/sdc >> ${OUTPUT}

# Install packages for deployment
/usr/bin/yum install -y puppet3 git >> ${OUTPUT}
puppet --version >> ${OUTPUT}
git --version >> ${OUTPUT}

cd /tmp
if [[ -d "./up-neo4j-ha-cluster" ]]; then
    cd up-neo4j-ha-cluster/
    git pull
else
  git clone https://github.com/Financial-Times/up-neo4j-ha-cluster.git >> ${OUTPUT}
  cd up-neo4j-ha-cluster/
fi

#Lookup ELB DNS names for this stack
INITIAL_HOSTS=$(sh/initial_hosts.sh)
if [[ -z ${INITIAL_HOSTS} ]]; then
  echo "Failed to lookup initial hosts. Exit 1." >> ${OUTPUT}
  exit 1
else
  echo "INITIAL_HOSTS=${INITIAL_HOSTS}" >> ${OUTPUT}
fi

sudo puppet apply --modulepath ./puppet -e "class { 'neo4jha': profile => 'prod', initial_hosts => \"${INITIAL_HOSTS}\" }" >> ${OUTPUT}
echo  "END - $(date)" >> ${OUTPUT}
