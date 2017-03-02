#!/usr/bin/env bash

echo "Deleting stack for environment ${ENVIRONMENT_TAG:?No environment tag provided.}"
echo "The tunnel will not be deleted automatically."
set AWS_ACCESS_KEY_ID = "${AWS_ACCESS_KEY_ID:?AWS Access Key not set.}"
set AWS_SECRET_ACCESS_KEY = "${AWS_SECRET_ACCESS_KEY:?AWS Secret Access Key not set.}"

aws cloudformation delete-stack --stack-name=upp-${ENVIRONMENT_TAG}
