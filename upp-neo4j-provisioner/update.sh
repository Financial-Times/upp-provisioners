#!/usr/bin/env bash

# abort stack creation if ENVIRONMENT_TAG doesn't end with -data
if [[ $ENVIRONMENT_TAG != *-data ]] ; then
    echo -e "\nENVIRONMENT_TAG must end with '-data'"
    echo -e "Please update your ENVIRONMENT_TAG variable and try again\n"
    exit 1
fi

echo "Updating stack for environment ${ENVIRONMENT_TAG:?No environment tag provided.}"
set AWS_ACCESS_KEY_ID = "${AWS_ACCESS_KEY_ID:?AWS Access Key not set.}"
set AWS_SECRET_ACCESS_KEY = "${AWS_SECRET_ACCESS_KEY:?AWS Secret Access Key not set.}"
set SERVICES_DEFINITION_ROOT_URI = "${SERVICES_DEFINITION_ROOT_URI:?Service file definition not set.}"
set SPLUNK_HEC_TOKEN = "${SPLUNK_HEC_TOKEN:?Splunk HEC Token not set.}"
set SPLUNK_HEC_URL = "${SPLUNK_HEC_URL:?Splunk HEC URL not set.}"
set KONSTRUCTOR_API_KEY = "${KONSTRUCTOR_API_KEY:?Konstructor API Key not set.}"
set TOKEN_URL = "${TOKEN_URL:?Failed to get etcd2 token URL}"
set NEO_EXTRA_CONF_URL = "${NEO_EXTRA_CONF_URL:?Neo4J Extra Conf URL not provided.}"
set AWS_DEFAULT_REGION = "${AWS_DEFAULT_REGION:?AWS Region not set.}"
set ENVIRONMENT_TYPE = "${ENVIRONMENT_TYPE:?Environment type not set.}"

case "$AWS_DEFAULT_REGION" in
    eu-west-1)
        export VPC_ID="vpc-36639c52"
        export SUBNET1="subnet-a32021d5"
        export SUBNET2="subnet-f11956a9"
        export SUBNET3="subnet-00d8db64"
        export SNAPSHOT="snap-08ce671d2f33e9e5d"
        export AMI=$(curl -s https://coreos.com/dist/aws/aws-stable.json | jq '."eu-west-1".hvm')
        ;;
    us-east-1)
        export VPC_ID="vpc-1d25657a"
        export SUBNET1="subnet-4158091a"
        export SUBNET2="subnet-64005a49"
        export SUBNET3="subnet-1f383356"
        export SNAPSHOT="snap-0c0978a76e7255bcd"
        export AMI=$(curl -s https://coreos.com/dist/aws/aws-stable.json | jq '."us-east-1".hvm')
        ;;
    *)
        echo "Can only be deployed in eu-west-1 or us-east-1"
        exit 1
esac


read -r -d '' CF_PARAMS <<EOM
[
    {
        "ParameterKey": "TagEnvironment",
        "ParameterValue": "${ENVIRONMENT_TYPE}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "ImageId",
        "ParameterValue": ${AMI},
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "EbsSnapshot",
        "ParameterValue": "${SNAPSHOT}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "VPC",
        "ParameterValue": "${VPC_ID}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "Subnet1",
        "ParameterValue": "${SUBNET1}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "Subnet2",
        "ParameterValue": "${SUBNET2}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "Subnet3",
        "ParameterValue": "${SUBNET3}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "AWSAccessKeyId",
        "ParameterValue": "${AWS_ACCESS_KEY_ID}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "AWSSecretAccessKey",
        "ParameterValue": "${AWS_SECRET_ACCESS_KEY}",
        "UsePreviousValue": false
    },
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

# Update the cloudformation stack
aws cloudformation update-stack --stack-name=upp-${ENVIRONMENT_TAG} --use-previous-template --parameters="${CF_PARAMS}"