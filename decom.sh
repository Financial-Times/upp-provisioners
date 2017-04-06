#!/usr/bin/env bash

# abort stack decommissioning if ENVIRONMENT_TAG doesn't end with -data
if [[ $ENVIRONMENT_TAG != *-data ]] ; then
    echo -e "\nENVIRONMENT_TAG must end with '-data'"
    echo -e "Please update your ENVIRONMENT_TAG variable and try again\n"
    exit 1
fi

echo "Deleting stack for environment ${ENVIRONMENT_TAG:?No environment tag provided.}"
set AWS_ACCESS_KEY_ID = "${AWS_ACCESS_KEY_ID:?AWS Access Key not set.}"
set AWS_SECRET_ACCESS_KEY = "${AWS_SECRET_ACCESS_KEY:?AWS Secret Access Key not set.}"
set KONSTRUCTOR_API_KEY = "${KONSTRUCTOR_API_KEY:?Konstructor API Key not set.}"

aws cloudformation delete-stack --stack-name=upp-${ENVIRONMENT_TAG}

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
