.DEFAULT_GOAL := help

.PHONY: \
	shell-k8s-test \
	shell-k8s-staging \
	shell-k8s-prod \
	help

help:
	@echo "This is a helper to run predefined setups"

shell-k8s-test:
	export JENKINS_UID="k8s-test" && \
	export AWS_PROFILE="upp-jenkins-provisioner-test" && \
	bash -x get_creds_and_make.sh

shell-k8s-staging:
	export JENKINS_UID="k8s-staging" && \
	export AWS_PROFILE="upp-jenkins-provisioner-prod" && \
	bash -x get_creds_and_make.sh

shell-k8s-prod:
	export JENKINS_UID="k8s-prod" && \
	export AWS_PROFILE="upp-jenkins-provisioner-prod" && \
	bash -x get_creds_and_make.sh

shell-content-staging:
	export JENKINS_UID="content-staging" && \
	export AWS_PROFILE="upp-jenkins-provisioner-prod" && \
	bash -x get_creds_and_make.sh

shell-content-prod:
	export JENKINS_UID="content-prod" && \
	export AWS_PROFILE="upp-jenkins-provisioner-prod" && \
	bash -x get_creds_and_make.sh
