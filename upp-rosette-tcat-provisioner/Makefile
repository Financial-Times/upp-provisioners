.PHONY: rosette-tcat-provisioner rosette-tcat destroy-rosette-tcat help

help:    ## Show this help.
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)

rosette-tcat-provisioner: ## Build  provisioner
	@docker build -t rosette-tcat-provisioner:local .

rosette-tcat-instance: ## Deploy staging rosette tcat instance
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-tcat-provisioner:local provision.sh staging

destroy-rosette-tcat: ## Destroys staging rosette tcat instance
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-tcat-provisioner:local destroy.sh staging

