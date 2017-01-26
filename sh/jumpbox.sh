#!/usr/bin/env bash

source $(dirname $0)/functions.sh || echo "Failed to source functions.sh"

OUTPUT="/var/log/jumpbox.log"
ROOTDIR='/tmp'

info  "BEGIN - $(date)" | tee ${OUTPUT}

if [[ "${PPID}" -eq "1" ]]; then
  info "Parent PID 1 indicates we are running inside Docker container, skip tagging and package installation" | tee ${OUTPUT}
else
  # Update Name tag
  info "Setting hostname in AWS console" | tee ${OUTPUT}
  /usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) delete-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name
  /usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) create-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=$(wget -q -O - http://169.254.169.254/latest/meta-data/hostname)
  info "Hostname set" | tee ${OUTPUT}
  # Install packages for deployment
  /usr/bin/yum install -y puppet3 git | tee ${OUTPUT}
  puppet --version | tee ${OUTPUT}
  git --version | tee ${OUTPUT}
fi

cd ${ROOTDIR}
if [[ -d "./up-neo4j-ha-cluster" ]]; then
    cd up-neo4j-ha-cluster/
    git pull
else
  git clone https://github.com/Financial-Times/up-neo4j-ha-cluster.git | tee ${OUTPUT}
  cd up-neo4j-ha-cluster/
fi

puppet apply --modulepath ./puppet -e "class { 'neo4jha::jumpbox': }" | tee ${OUTPUT}
sh/authorized_keys.sh
info  "END - $(date)" | tee ${OUTPUT}
