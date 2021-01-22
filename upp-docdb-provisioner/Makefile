.DEFAULT_GOAL := help

IMAGE_NAME=upp-docdb-provisioner

.PHONY: \
	rebuild \
	rebuild-files \
	shell \
	deploy \
	delete \
	help

help:
	@echo "This is a helper to build and run the provisioner"

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

shell:
	docker run -it --rm \
		-h ${IMAGE_NAME}-${INSTANCE_UID} \
		-e "INSTANCE_UID=${INSTANCE_UID}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "DOC_DB_USERNAME=${DOC_DB_USERNAME}" \
		-e "DOC_DB_PASSWORD=${DOC_DB_PASSWORD}" \
		${IMAGE_NAME}:local
