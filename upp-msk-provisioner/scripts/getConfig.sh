#!/usr/bin/env bash

set -x

#Get MSK configuration

aws kafka list-clusters | jq -r '.ClusterInfoList[0].ClusterArn' > clusterArn
echo "Zookeper" > bootstrapCluster
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

cat global-config | jq -r --arg broker "$broker" '.data["kafka-msk.url"]=$broker' > tmp_f && mv tmp_f global-config
cat global-config | jq -r --arg kafkaHost "$kafkaHost" '.data["kafka-msk.host"]=$kafkaHost' > tmp_f && mv tmp_f global-config
cat global-config | jq -r --arg kafkaPort "$kafkaPort" '.data["kafka-msk.port"]=$kafkaPort' > tmp_f && mv tmp_f global-config
cat global-config | jq -r --arg brokerTLS "$brokerTLS" '.data["kafka-msk.url-tls"]=$brokerTLS' > tmp_f && mv tmp_f global-config
cat global-config | jq -r --arg zookeeperHost "$zookeeperHost" '.data["zookeeper-msk.host"]=$zookeeperHost' > tmp_f && mv tmp_f global-config
cat global-config | jq -r --arg zookeeperPort "$zookeeperPort" '.data["zookeeper-msk.port"]=$zookeeperPort' > tmp_f && mv tmp_f global-config
cat global-config | jq -r --arg zookeeper "$zookeeper" '.data["zookeeper-msk.url"]=$zookeeper' > tmp_f && mv tmp_f global-config

#Apply global config to the cluster

kubectl patch cm global-config --patch "$(cat global-config)"

#Delete pods related to MSK

kubectl delete pod -l "app in (kafka-rest-proxy-msk, locations-smartlogic-notifier, native-ingester-cms, native-ingester-metadata, smartlogic-concept-transformer, smartlogic-concordance-transformer, smartlogic-notifier, wikidata-concept-transformer)"
