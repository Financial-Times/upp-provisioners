#!/usr/bin/env bash

# abort stack decommissioning if ENVIRONMENT_TAG doesn't end with -data
if [[ $ENVIRONMENT_TAG != *-data ]] ; then
    echo -e "\nENVIRONMENT_TAG must end with '-data'"
    echo -e "Please update your ENVIRONMENT_TAG variable and try again\n"
    exit 1
fi

ENVIRONMENT_TYPE=$(aws cloudformation describe-stacks --stack-name upp-${ENVIRONMENT_TAG} | jq -r '.Stacks[].Parameters[] | select(.ParameterKey == "TagEnvironment") .ParameterValue')
if [ "${ENVIRONMENT_TYPE}" == "p" ] ; then
    echo WARNING - upp-${ENVIRONMENT_TAG} is a production stack!
    echo Are you sure you want to decommission it? [y/N]
    read input
    if [ "${input}" != "y" ] ; then
        echo Aborting
        exit 0
    fi
fi

echo "Deleting stack for environment ${ENVIRONMENT_TAG:?No environment tag provided.}"
set AWS_ACCESS_KEY_ID = "${AWS_ACCESS_KEY_ID:?AWS Access Key not set.}"
set AWS_SECRET_ACCESS_KEY = "${AWS_SECRET_ACCESS_KEY:?AWS Secret Access Key not set.}"
set KONSTRUCTOR_API_KEY = "${KONSTRUCTOR_API_KEY:?Konstructor API Key not set.}"

aws cloudformation delete-stack --stack-name=upp-${ENVIRONMENT_TAG}

# Delete cloudwatch alarms for the cluster
echo "Deleting cloudwatch alarms for stack ${ENVIRONMENT_TAG}"
for alarm in $(aws cloudwatch describe-alarms --alarm-name-prefix "com.ft.up.${ENVIRONMENT_TAG}" | grep AlarmName | cut -d '"' -f 4) ; do 
    echo "Deleting $alarm"
    aws cloudwatch delete-alarms --alarm-name $alarm
done

for CNAME in upp-${ENVIRONMENT_TAG}-write-alb-up upp-${ENVIRONMENT_TAG}-read-alb-up ${ENVIRONMENT_TAG}-neo4j-tunnel-up ; do

    echo "Deleting CNAME ${CNAME}.ft.com"
    curl -s -X DELETE \
    --header 'Content-Type: application/json' \
    --header 'Accept: application/json' \
    --header "x-api-key: ${KONSTRUCTOR_API_KEY}" \
    -d "{
      'zone': 'ft.com',
      'name': \"${CNAME}\",
      'emailAddress': 'universal.publishing.platform@ft.com'
    }" 'https://dns-api.in.ft.com/v2'
    echo -e "\n"

done
