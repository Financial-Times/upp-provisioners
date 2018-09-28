#!/usr/bin/env bash

/usr/bin/aws s3 cp s3://ft-ce-repository/amazon-ftbase/releases/bootstrap.sh /
bash /bootstrap.sh -s eng -e ${EnvironmentType}
yum update -y
yum install git -y

# Clone the k8s auth setup repo with the kubeconfig in it
cd /etc/skel
git clone git@github.com:Financial-Times/content-k8s-auth-setup.git
echo "export KUBECONFIG=${HOME}/content-k8s-auth-setup/kubeconfig" > /etc/skel/.bashrc
source /etc/skel/.bashrc
echo "${KubectlLoginFile}" >> .kubectl-login.json

echo "${SSHConfig}" >> /etc/ssh/ssh_config
chmod 0644 /etc/ssh/ssh_config
echo "${SSHAgent}" >> /etc/profile.d/z0_ssh_agent.sh
chmod 0644 /etc/profile.d/z0_ssh_agent.sh
echo "${K8sCluster}" >> /etc/profile.d/z2_k8s_clusters.sh
chmod 0644 /etc/profile.d/z2_k8s_clusters.sh
echo 0644 "${ListClusters}" >> /usr/local/bin/list-clusters
chmod +x /usr/local/bin/list-clusters

cd /home/ec2-user
# Install kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v1.7.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
# Install kubectl-login
KUBECTL_LOGIN_VERSION=$(curl -sS -D - https://github.com/Financial-Times/kubectl-login/releases/latest -o /dev/null | grep Location | sed -E "s/^.*tag\/([0-9.]+).*$/\1/g")
curl -L -s -o /usr/local/bin/kubectl-login https://github.com/Financial-Times/kubectl-login/releases/download/$KUBECTL_LOGIN_VERSION/kubectl-login-linux
chmod 755 /usr/local/bin/kubectl-login
# Install cluster-login.sh
curl -L -s -o /usr/local/bin/cluster-login.sh https://github.com/Financial-Times/kubectl-login/releases/download/$KUBECTL_LOGIN_VERSION/cluster-login.sh
chmod 755 /usr/local/bin/cluster-login.sh
# Install docker for PAC failover
yum install docker -y
service docker start
