#!/usr/bin/env bash

set -x

#Get MSK configuration

aws kafka list-clusters | jq -r '.ClusterInfoList[0].ClusterArn' > clusterArn
aws kafka describe-cluster --cluster-arn $(cat clusterArn) |jq -r '.ClusterInfo.ZookeeperConnectString' >> ZookeeperConnectString
aws kafka get-bootstrap-brokers --cluster-arn $(cat clusterArn) > brokers
cat ./brokers |jq '.BootstrapBrokerString' | tr -d '"' >> BootstrapBrokerString
cat ./brokers |jq '.BootstrapBrokerStringTls' | tr -d '"' >> BootstrapBrokerStringTls

#Exract needed values

export zookeeper=`cat ./ZookeeperConnectString`
export broker=`cat ./BootstrapBrokerString`
export brokerTLS=`cat ./BootstrapBrokerStringTls`
export kafkaHost=`echo $broker| cut -d',' -f 1| cut -d':' -f 1`
export kafkaPort=`echo $broker| cut -d',' -f 1| cut -d':' -f 2`
export zookeeperHost=`echo $zookeeper | cut -d',' -f 1| cut -d':' -f 1`
export zookeeperPort=`echo $zookeeper | cut -d',' -f 1| cut -d':' -f 2`

#Get global-config

kubectl get cm global-config -ojson > global-config

#Edit global global-config

if [[ $K8S_API_SERVER == *"-publish-"* ]]; then
	cat global-config | jq -r --arg broker "$broker" '.data["kafka.url"]=$broker' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg kafkaHost "$kafkaHost" '.data["kafka.host"]=$kafkaHost' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg kafkaPort "$kafkaPort" '.data["kafka.port"]=$kafkaPort' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg zookeeperHost "$zookeeperHost" '.data["zookeeper.host"]=$zookeeperHost' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg zookeeperPort "$zookeeperPort" '.data["zookeeper.port"]=$zookeeperPort' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg zookeeper "$zookeeper" '.data["zookeeper.url"]=$zookeeper' > tmp_f && mv tmp_f global-config
	# Required by kafka-rest-proxy-msk
	cat global-config | jq -r --arg broker "$broker" '.data["kafka-msk.url"]=$broker' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg brokerTLS "$brokerTLS" '.data["kafka-msk.url-tls"]=$brokerTLS' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg zookeeper "$zookeeper" '.data["zookeeper-msk.url"]=$zookeeper' > tmp_f && mv tmp_f global-config
else
	cat global-config | jq -r --arg broker "$broker" '.data["kafka-msk.url"]=$broker' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg kafkaHost "$kafkaHost" '.data["kafka-msk.host"]=$kafkaHost' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg kafkaPort "$kafkaPort" '.data["kafka-msk.port"]=$kafkaPort' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg brokerTLS "$brokerTLS" '.data["kafka-msk.url-tls"]=$brokerTLS' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg zookeeperHost "$zookeeperHost" '.data["zookeeper-msk.host"]=$zookeeperHost' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg zookeeperPort "$zookeeperPort" '.data["zookeeper-msk.port"]=$zookeeperPort' > tmp_f && mv tmp_f global-config
	cat global-config | jq -r --arg zookeeper "$zookeeper" '.data["zookeeper-msk.url"]=$zookeeper' > tmp_f && mv tmp_f global-config
fi

#Apply global config to the cluster

kubectl patch cm global-config --patch "$(cat global-config)"

#Delete pods related to MSK

kubectl delete pod -l "app in (kafka-rest-proxy-msk, locations-smartlogic-notifier, smartlogic-notifier, cms-metadata-notifier, cms-notifier, pac-annotations-mapper, annotations-mapper, annotations-rw-neo4j, suggestions-rw-neo4j, annotations-writer-ontotext, post-publication-combiner, concept-suggestion-api, burrow, upp-next-video-annotations-mapper, cms-kafka-bridge-pub, cms-metadata-kafka-bridge-pub, v2-content-annotator)"
kubectl get pod | grep transformer | awk '{ print $1}' | xargs kubectl delete pod
kubectl get pod | grep ingester | awk '{ print $1}' | xargs kubectl delete pod
kubectl get pod | grep validator | awk '{ print $1}' | xargs kubectl delete pod
# burrow should be running before restarting kafka-lagcheck
kubectl delete pod -l "app in (kafka-lagcheck)"
