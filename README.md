#Docker image to provision a cluster

##Building
```
# Build the image
docker build -t coco/coreos-up-setup .

# Set all the required variables
VAULT_PASS=xxxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxx
AWS_ACCESS_KEY_ID=xxxxxxxx
BINARY_WRITER_BUCKET=xxxxxxxx
AWS_MONITOR_TEST_UUID=xxxxxxxx
UCS_MONITOR_TEST_UUID=xxxxxxxx

# [optional]
SERVICE_DEFINITION_LOCATION=https://raw.githubusercontent.com/Financial-Times/fleet/master/services.yaml
ENVIRONMENT_TAG=xxxx

# Run the image
docker run --env "VAULT_PASS=$VAULT_PASS" \ 
	   --env "SERVICE_DEFINITION_LOCATION=$SERVICE_DEFINITION_LOCATION" \ 
	   --env "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
	   --env "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
	   --env "ENVIRONMENT_TAG=$ENVIRONMENT_TAG" \
           --env "BINARY_WRITER_BUCKET=$BINARY_WRITER_BUCKET" \
	   --env "AWS_MONITOR_TEST_UUID=$AWS_MONITOR_TEST_UUID" \
           --env "UCS_MONITOR_TEST_UUID=$UCS_MONITOR_TEST_UUID" coco/coreos-up-setup
```

