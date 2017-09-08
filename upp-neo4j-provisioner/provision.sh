#!/usr/bin/env bash

# abort stack creation if ENVIRONMENT_TAG doesn't end with -data
if [[ $ENVIRONMENT_TAG != *-data ]] ; then
    echo -e "\nENVIRONMENT_TAG must end with '-data'"
    echo -e "Please update your ENVIRONMENT_TAG variable and try again\n"
    exit 1
fi

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
set NEO_HEAP_SIZE = "${NEO_HEAP_SIZE:?Neo4J Heap Size not provided.}"
set NEO_CACHE_SIZE = "${NEO_CACHE_SIZE:?Neo4J Page Cache Size not provided.}"

case "$AWS_DEFAULT_REGION" in
    eu-west-1)
        export VPC_ID="vpc-36639c52"
        export SUBNET1="subnet-a32021d5"
        export SUBNET2="subnet-f11956a9"
        export SUBNET3="subnet-00d8db64"
        export SNAPSHOT="snap-0e9ecacdd229f9d29"
        export AMI=$(curl -s https://coreos.com/dist/aws/aws-stable.json | jq '."eu-west-1".hvm')
        ;;
    us-east-1)
        export VPC_ID="vpc-1d25657a"
        export SUBNET1="subnet-4158091a"
        export SUBNET2="subnet-64005a49"
        export SUBNET3="subnet-1f383356"
        export SNAPSHOT="snap-068322a1e3e643d35"
        export AMI=$(curl -s https://coreos.com/dist/aws/aws-stable.json | jq '."us-east-1".hvm')
        ;;
    *)
        echo "Can only be deployed in eu-west-1 or us-east-1"
        exit 1
esac

echo "EtcdToken=${TOKEN_URL}" >> /tmp/ft-env-variables
echo "AWSAccessKeyId=${AWS_ACCESS_KEY_ID}" >> /tmp/ft-env-variables
echo "AWSSecretAccessKey=${AWS_SECRET_ACCESS_KEY}" >> /tmp/ft-env-variables
echo "KonstructorAPIKey=${KONSTRUCTOR_API_KEY}" >> /tmp/ft-env-variables
echo "ServicesDefinitionRootURI=${SERVICES_DEFINITION_ROOT_URI}" >> /tmp/ft-env-variables
echo "CocoEnvironmentTag=${ENVIRONMENT_TAG}" >> /tmp/ft-env-variables
echo "SplunkHecURL=${SPLUNK_HEC_URL}" >> /tmp/ft-env-variables
echo "SplunkHecToken=${SPLUNK_HEC_TOKEN}" >> /tmp/ft-env-variables
echo "ExtraNeoConf=${NEO_EXTRA_CONF_URL}" >> /tmp/ft-env-variables
echo "HeapMaxSize=${NEO_HEAP_SIZE}" >> /tmp/ft-env-variables
echo "PageCacheSize=${NEO_CACHE_SIZE}" >> /tmp/ft-env-variables

/substitute-ft-env-variables.sh
/bin/base64 /userdata.yml | tr -d '\n' > /userdata.base64
/usr/bin/split -b 4096 userdata.base64

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
        "ParameterKey": "CocoEnvironmentTag",
        "ParameterValue": "${ENVIRONMENT_TAG}",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "UserData1",
        "ParameterValue": "$(cat /xaa)",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "UserData2",
        "ParameterValue": "$(cat /xab)",
        "UsePreviousValue": false
    },
    {
        "ParameterKey": "UserData3",
        "ParameterValue": "$(cat /xac)",
        "UsePreviousValue": false
    }
]
EOM

# if the stack doesn't exist, create it
# otherwise, update it
aws cloudformation describe-stacks --stack-name=upp-${ENVIRONMENT_TAG} > /dev/null 2>&1
status=$?

if [ ${status} != 0 ]; then
    echo "Creating stack upp-${ENVIRONMENT_TAG}"
    aws cloudformation create-stack --stack-name=upp-${ENVIRONMENT_TAG} --template-body=file:///neo4jhacluster.yaml --parameters="${CF_PARAMS}"
else
    echo "Updating stack upp-${ENVIRONMENT_TAG}"
    aws cloudformation update-stack --stack-name=upp-${ENVIRONMENT_TAG} --template-body=file:///neo4jhacluster.yaml --parameters="${CF_PARAMS}"
fi

echo -e "Tunnel CNAME:"
echo -e "${ENVIRONMENT_TAG}-neo4j-tunnel-up.ft.com\n"

echo -e "Write ALB:"
echo -e "upp-${ENVIRONMENT_TAG}-write-alb-up.ft.com\n"

echo -e "Read ALB:"
echo -e "upp-${ENVIRONMENT_TAG}-read-alb-up.ft.com\n"
