IMAGE_NAME=upp-content-exporter-s3-provisioner

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
	@docker run --rm -it \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
		${IMAGE_NAME}:local provision.sh

delete:
	@docker run --rm -it \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}" \
		${IMAGE_NAME}:local decom.sh
