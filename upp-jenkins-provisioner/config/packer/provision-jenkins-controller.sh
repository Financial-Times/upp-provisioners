#!/usr/bin/env bash

set -euox pipefail
IFS=$'\n\t'

echo "Install Jenkins"
# Ensure Jenkins use the same UID and GID. This way files in /var/lib/jenkins
# will have always the corret user and group
sudo mkdir /var/lib/jenkins
sudo groupadd -g 800 jenkins
sudo adduser -u 800 -g 800 -s /bin/false -d /var/lib/jenkins -M -c 'Jenkins Automation Server' jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins

sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

### 2020-07-28: The Jenkins gpg key use to sign our packages has been updated on
### 16th of April 2020. That breaks the older package that we want to install.
### It looks for the old gpg key at the moment. The workaround is to disable the gpgcheck
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo sed -i 's/gpgcheck=1/gpgcheck=0/' /etc/yum.repos.d/jenkins.repo

sudo yum -y update
sudo yum -y upgrade
sudo yum -y install java-1.8.0-openjdk-devel "${JENKINS_PACKER_RPM_VERSION}"
sudo systemctl stop jenkins
sudo systemctl enable jenkins

sudo mv /tmp/sysconfig_jenkins_template.conf /etc/sysconfig/jenkins
sudo chown root:root /etc/sysconfig/jenkins

echo "Install Docker CE"
sudo amazon-linux-extras install docker
sudo usermod -a -G docker jenkins
sudo systemctl stop docker
sudo systemctl enable docker
