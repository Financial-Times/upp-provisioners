#!/bin/bash

OUTPUT="/tmp/bootstrap.log"

echo  "BEGIN - $(date)" > ${OUTPUT}
# Update Name tag
echo "Setting hostname in AWS console" >> ${OUTPUT}
/usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) delete-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name
/usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) create-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=$(wget -q -O - http://169.254.169.254/latest/meta-data/hostname)
echo "Hostname set" >> ${OUTPUT}

# Install packages for deployment
/usr/bin/yum install -y puppet3 git tcpdump >> ${OUTPUT}
puppet --version >> ${OUTPUT}
git --version >> ${OUTPUT}

cd /tmp
if [[ -d "./upp-provisioners/upp-neo4j-provisioner" ]]; then
    cd upp-provisioners/upp-neo4j-provisioner/
    git pull
else
  git clone https://github.com/Financial-Times/up-neo4j-cluster.git >> ${OUTPUT}
  cd upp-provisioners/upp-neo4j-provisioner/
fi

#Lookup PrivateIP for each instance
INITIAL_HOSTS=$(sh/initial_hosts.sh)
if [[ -z ${INITIAL_HOSTS} ]]; then
  echo "Failed to lookup initial hosts. Exit 1." >> ${OUTPUT}
  exit 1
else
  echo "INITIAL_HOSTS=${INITIAL_HOSTS}" >> ${OUTPUT}
fi

sudo puppet apply --modulepath ./puppet -e "class { 'neo4jha': profile => 'prod', initial_hosts => \"${INITIAL_HOSTS}\" }" >> ${OUTPUT}
echo  "END - $(date)" >> ${OUTPUT}
