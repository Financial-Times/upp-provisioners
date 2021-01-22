.DEFAULT_GOAL := help

.PHONY: \
	shell-docstore-test-eu \
	help

help:
	@echo "This is a helper to run predefined setups"

shell-docstore-test-eu:
	export INSTANCE_UID="docstore-test-eu" && \
	export AWS_PROFILE="upp-docdb-provisioner-test" && \
	bash -x get-creds-and-make.sh
