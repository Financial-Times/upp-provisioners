.DEFAULT_GOAL := rebuild
IMAGE_NAME=upp-ontotext-backup-rds-provisioner

.PHONY: \
	rebuild \
	rebuild-files \
	deploy \
	delete

rebuild:
	docker build \
		--no-cache \
		--tag ${IMAGE_NAME}:local \
		--file Dockerfile .

rebuild-files:
	docker build \
		--no-cache \
		--tag ${IMAGE_NAME}:local \
		--file Dockerfile.files .

deploy:
	docker run -it --rm \
		-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "DB_NAME=ontotext_backup" \
		-e "MASTER_USER=uppadmin" \
		-e "MASTER_PASSWORD=${MASTER_PASSWORD}" \
		${IMAGE_NAME}:local deploy-rds

delete:
	docker run -it --rm \
		-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		${IMAGE_NAME}:local delete-rds
