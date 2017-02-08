#!/usr/bin/env bash

echo "Creating stack for environment ${ENVIRONMENT_TAG:?No environment tag provided.}"
set AWS_ACCESS_KEY_ID = "${AWS_ACCESS_KEY_ID:?AWS Access Key not set.}"
set AWS_SECRET_ACCESS_KEY = "${AWS_SECRET_ACCESS_KEY:?AWS Secret Access Key not set.}"
set SERVICES_DEFINITION_ROOT_URI = "${SERVICES_DEFINITION_ROOT_URI:?Service file definition not set.}"
set SPLUNK_HEC_TOKEN = "${SPLUNK_HEC_TOKEN:?Splunk HEC Token not set.}"
set SPLUNK_HEC_URL = "${SPLUNK_HEC_URL:?Splunk HEC URL not set.}"
set KONSTRUCTOR_API_KEY = "${KONSTRUCTOR_API_KEY:?Konstructor API Key not set.}"
TOKEN_URL=$(curl -s https://discovery.etcd.io/new?size=3)
set TOKEN_URL = "${TOKEN_URL:?Etcd2 token url not set.}"
set NEO_EXTRA_CONF_URL = "${NEO_EXTRA_CONF_URL:?Neo4J Extra Conf URL not provided.}"

read -r -d '' CF_PARAMS <<EOM
[
    {
        "ParameterKey": "KonstructorAPIKey",
        "ParameterValue": "${KONSTRUCTOR_API_KEY}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "ServicesDefinitionRootURI",
        "ParameterValue": "${SERVICES_DEFINITION_ROOT_URI}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "CocoEnvironmentTag",
        "ParameterValue": "${ENVIRONMENT_TAG}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "SplunkHecURL",
        "ParameterValue": "${SPLUNK_HEC_URL}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "SplunkHecToken",
        "ParameterValue": "${SPLUNK_HEC_TOKEN}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "EtcdToken",
        "ParameterValue": "${TOKEN_URL}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "ExtraNeoConf",
        "ParameterValue": "${NEO_EXTRA_CONF_URL}",
        "UsePreviousValue": false
    }
]
EOM
aws cloudformation create-stack --stack-name=up-neo4j-${ENVIRONMENT_TAG} --template-body=file://./cloudformation/neo4jhacluster.yaml --parameters="${CF_PARAMS}"
