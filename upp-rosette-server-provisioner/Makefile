.PHONY: rosette-provisioner-provisioner staging-rosette-server destroy-staging-rosette-server prod-rosette-server destroy-prod-rosette-server help

help:    ## Show this help.
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)

rosette-server-provisioner: ## Build  provisioner
	@docker build -t rosette-server-provisioner:local .

staging-rosette-server: ## Deploy staging rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-server-provisioner:local provision.sh staging

prod-rosette-server: ## Deploy prod rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-server-provisioner:local provision.sh prod

destroy-staging-rosette-server: ## Destroys staging rosette steack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-server-provisioner:local destroy.sh staging

destroy-prod-rosette-server: ## Destroys prod rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-server-provisioner:local destroy.sh prod
