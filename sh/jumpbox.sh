#!/bin/bash

OUTPUT="/var/log/bootstrap.log"

echo  "BEGIN - $(date)" > ${OUTPUT}
# Update Name tag
echo "Setting hostname in AWS console" >> ${OUTPUT}
/usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) delete-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name
/usr/bin/aws ec2 --region $(/usr/bin/wget -q -O - http://169.254.169.254/latest/meta-data/hostname | cut -d . -f 2) create-tags --resources $(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=$(wget -q -O - http://169.254.169.254/latest/meta-data/hostname)
echo "Hostname set" >> ${OUTPUT}
echo  "END - $(date)" >> ${OUTPUT}
