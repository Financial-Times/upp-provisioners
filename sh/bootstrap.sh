#!/bin/bash

OUTPUT="/tmp/deployment.log"

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
git clone https://github.com/Financial-Times/up-neo4j-ha-cluster.git >> ${OUTPUT}
cd up-neo4j-ha-cluster/
sudo puppet apply --modulepath ./puppet -e "class { 'neo4jha': profile => 'prod' }" >> ${OUTPUT}
echo  "END - $(date)" >> ${OUTPUT}
