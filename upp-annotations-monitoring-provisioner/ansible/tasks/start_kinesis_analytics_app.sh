#!/bin/bash

if [[ -z $APPLICATION_NAME ]]; then
   echo "Usage - please set the environment variable APPLICATION_NAME to the Kinesis Analytics Application you wish to start."
   exit 1
fi

for id in $(aws kinesisanalytics describe-application --region=$AWS_REGION --application-name $APPLICATION_NAME --query 'ApplicationDetail.InputDescriptions[].InputId' --output text); do
   aws kinesisanalytics start-application \
      --region=$AWS_REGION \
      --application-name $APPLICATION_NAME \
      --input-configurations "Id=${id},InputStartingPositionConfiguration={InputStartingPosition=NOW}"
done
