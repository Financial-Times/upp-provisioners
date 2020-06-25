build-provisioner:
	@docker build -t ccf-dynamodb:local .

provision-dynamodb:
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=${AWS_REGION}" \
			-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
			-e "ENVIRONMENT_TYPE=${ENVIRONMENT_TYPE}" \
			ccf-dynamodb:local /bin/bash provision.sh

decommission-dynamodb:
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=${AWS_REGION}" \
			-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
			ccf-dynamodb:local /bin/bash decom.sh
