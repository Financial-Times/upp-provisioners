#!/usr/bin/env bash

set -euox pipefail
IFS=$'\n\t'

echo "Install Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y update
sudo yum -y upgrade
sudo yum -y install java-1.8.0-openjdk-devel jenkins-2.190.1-1.1
sudo systemctl stop jenkins
sudo systemctl enable jenkins

echo "Install Docker CE"
sudo amazon-linux-extras install docker
sudo usermod -a -G docker jenkins
sudo systemctl stop docker
sudo systemctl enable docker
