.DEFAULT_GOAL := rebuild
IMAGE_NAME=upp-jenkins-provisioner

.PHONY: \
	rebuild \
	rebuild-files \
	shell \
	create-ami \
	deploy-jenkins \
	delete-jenkins

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
		-h ${IMAGE_NAME}-${JENKINS_UID} \
		-e "JENKINS_UID=${JENKINS_UID}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		${IMAGE_NAME}:local

create-ami:
	docker run -it --rm \
		-h ${IMAGE_NAME}-${JENKINS_UID} \
		-e "JENKINS_UID=${JENKINS_UID}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		${IMAGE_NAME}:local create-ami

deploy-jenkins:
	docker run -it --rm \
		-h ${IMAGE_NAME}-${JENKINS_UID} \
		-e "JENKINS_UID=${JENKINS_UID}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		${IMAGE_NAME}:local deploy-jenkins

delete-jenkins:
	docker run -it --rm \
		-h ${IMAGE_NAME}-${JENKINS_UID} \
		-e "JENKINS_UID=${JENKINS_UID}" \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		${IMAGE_NAME}:local delete-jenkins
