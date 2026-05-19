.PHONY: rosette-provisioner staging-rosette-ras destroy-staging-rosette-ras prod-rosette-ras destroy-prod-rosette-ras help

help:    ## Show this help.
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)

rosette-ras-provisioner: ## Build  provisioner
	@docker build -t rosette-ras-provisioner:local .

staging-rosette-ras: ## Deploy staging rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-ras-provisioner:local provision.sh staging

prod-rosette-ras: ## Deploy prod rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-ras-provisioner:local provision.sh prod

destroy-staging-rosette-ras: ## Destroys staging rosette steack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-ras-provisioner:local destroy.sh staging

destroy-prod-rosette-ras: ## Destroys prod rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-ras-provisioner:local destroy.sh prod
