#!/usr/bin/env bash

OUTPUT="/var/log/jumpbox.log"
ROOTDIR='/tmp'

echo  "BEGIN - $(date)" | tee -a ${OUTPUT}

if [[ "${PPID}" -eq "1" ]]; then
  echo "Parent PID 1 indicates we are running inside Docker container, skip tagging and package installation" | tee -a ${OUTPUT}
else
  # Create Name tag if not already done so
  TAGGED=$(aws ec2 describe-instances --region $(curl -s http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) \
  --instance-ids $(curl -s http://169.254.169.254/latest/meta-data/instance-id) \
  --filters "Name=tag:Name",Values="$(curl -s http://169.254.169.254/latest/meta-data/hostname)" \
  --query 'Reservations[].Instances[].PrivateIpAddress' --output text)
  if [[ -z ${TAGGED} ]]; then
    echo "Setting hostname in AWS console" | tee -a ${OUTPUT}
    /usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) delete-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name
    /usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) create-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=$(wget -q -O - http://169.254.169.254/latest/meta-data/hostname)
    echo "Hostname set" | tee -a ${OUTPUT}
    # Install packages for deployment unless already installed
    test -x $(which puppet) || /usr/bin/yum install -y puppet3 | tee -a ${OUTPUT}
    test -x $(which git) || /usr/bin/yum install -y git | tee -a ${OUTPUT}
  fi
fi

cd ${ROOTDIR}
if [[ -d "./up-neo4j-ha-cluster" ]]; then
    cd up-neo4j-ha-cluster/
    git pull
else
  git clone https://github.com/Financial-Times/up-neo4j-ha-cluster.git | tee -a ${OUTPUT}
  cd up-neo4j-ha-cluster/
fi

puppet apply --modulepath ./puppet -e "class { 'neo4jha::jumpbox': }" | tee -a ${OUTPUT}
sh/authorized_keys.sh
echo  "END - $(date)" | tee -a ${OUTPUT}
