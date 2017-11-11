#!/bin/bash

/usr/bin/aws s3 cp s3://ft-ce-repository/amazon-ftbase/releases/bootstrap.sh . 
bash ./bootstrap.sh -s cloudenablement -e d -s eng -e p

echo "#######################################################################"
echo "################    Starting Puppet / FTPlatform 2    ###########################"
echo "######################################################################"

set -x 

# Carefully install puppet-3.5.1 - the ordering here is important!
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum install -y ruby-augeas virt-what libselinux-ruby rubygem-json ruby18 rubygems18
yum install -y --disablerepo=amzn-main puppet-3.5.1

# Disable yum repos

yum-config-manager --disable epel puppetlabs-deps puppetlabs-products

alternatives --set ruby /usr/bin/ruby1.8


# Configure ftplatform's puppet agent
puppet config set certname upp-k8s-jenkins.contentplatform.prod.eu-west-1.cloud.ft.com --section main
puppet config set server ftppm521-lvuk-uk-p.osb.ft.com --section agent
puppet config set report true --section agent
puppet config set pluginsync true --section agent
puppet config set environment `facter -p nodegroup` --section agent

# Set ft_environment fact
mkdir -p /etc/facter/facts.d
echo "ft_environment: p" > /etc/facter/facts.d/amazon-linux-facts.yaml
echo "ft_vm_email: universal.publishing.platform@ft.com" >> /etc/facter/facts.d/amazon-linux-facts.yaml
echo "ft_patch_group: a" >> /etc/facter/facts.d/amazon-linux-facts.yaml
echo "ft_vm_platform: AWS" >> /etc/facter/facts.d/amazon-linux-facts.yaml
echo "10.118.109.110 ftppm521-lvuk-uk-p.osb.ft.com" >> /etc/hosts

# Enable puppet service and start it
chkconfig puppet on
service puppet start

# Set up the ftplatform ppmorch privileged account
groupadd -g 15006 ppmorch
useradd -m -u 15006 -g 15006 ppmorch
mkdir /home/ppmorch/.ssh
echo "ppmorch ALL=(root) NOPASSWD: /usr/bin/puppet
ppmorch ALL=(root) NOPASSWD: /etc/init.d
ppmorch ALL=(root) NOPASSWD: /sbin/service
ppmorch ALL=(root) NOPASSWD: /bin/cat /var/lib/puppet/state/last_run_report.yaml
" > /etc/sudoers.d/ppmorch-sudoers

echo "Defaults:splunk !requiretty
splunk        ALL=(root) NOPASSWD: /opt/puppet/bin/facter, /usr/bin/facter" > /etc/sudoers.d/splunkforwarder-sudoers

echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtUKLGBSa+vX7tHNWDElHgWN+p53WBFdVE5V7x44CXfaSVYkN4VR+njmOZmOHka9mXRAeuZSNOJZlkMvFdER7MOkJsgfOHOqLc2bmA7Vwax4x7gI+QF+pMCyvxqQgmrzf9BIq+9jrzXhuhiFS9RMVztWDMG1dDAL1EJaCu8oEjcI1xspT8a0RQdeUl33WANWXfvH4ObwCaf2wsl+3sHTubr3Dnnj8ISY7u7AyJmGxDwvkQslZ94pep6i863WgGt6NBprU+PnPfVEtK9ZDvuJc+mBGqLgwSgmLIX8kzF3bHs03CGQCzppX85trycVJCrTGScuR8mud7ZARX5GT0uRB1Q== root@ftppm521-lvuk-uk-p
" >> /home/ppmorch/.ssh/authorized_keys
chown -R ppmorch:ppmorch /home/ppmorch/.ssh
chmod 0700 /home/ppmorch/.ssh
chmod 0600 /home/ppmorch/.ssh/authorized_keys
chmod 440 /etc/sudoers.d/splunkforwarder-sudoers
chmod 440 /etc/sudoers.d/ppmorch-sudoers
