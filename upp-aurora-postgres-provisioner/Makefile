.DEFAULT_GOAL := rebuild
IMAGE_NAME=upp-aurora-postgres-rds-provisioner

# The default for Macs with M1 is 'linux/arm64/v8' and there are missing dependencies for that platform
PLATFORM="linux/amd64"

.PHONY: \
	rebuild \
	rebuild-files \
	deploy \
	delete

rebuild:
	docker build --platform ${PLATFORM} \
		--no-cache \
		--tag ${IMAGE_NAME}:local \
		--file Dockerfile .

rebuild-files:
	docker build \
		--no-cache \
		--tag ${IMAGE_NAME}:local \
		--file Dockerfile.files .

deploy:
	docker run -it --rm --platform ${PLATFORM} \
		-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
		-e "REGION=${REGION}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "CF_TEMPLATE=${CF_TEMPLATE}" \
		-e "DB_NAME=${DB_NAME}" \
		-e "MASTER_USER=uppadmin" \
		-e "MASTER_PASSWORD=${MASTER_PASSWORD}" \
		${IMAGE_NAME}:local deploy-rds

delete:
	docker run -it --rm --platform ${PLATFORM} \
		-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
		-e "REGION=${REGION}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "CF_TEMPLATE=${CF_TEMPLATE}" \
		${IMAGE_NAME}:local delete-rds
