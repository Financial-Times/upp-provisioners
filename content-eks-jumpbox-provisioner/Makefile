.PHONY: jumpbox-provisioner staging-jumpbox destroy-staging-jumpbox help

help:    ## Show this help.
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)

jumpbox-provisioner: ## Build  provisioner
	@docker build --platform linux/amd64 -t jumpbox-provisioner:local .

staging-jumpbox: ## Deploy staging jumpbox
	@docker run --platform linux/amd64 --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			jumpbox-provisioner:local provision.sh staging

prod-jumpbox: ## Deploy prod jumpbox
	@docker run --platform linux/amd64 --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			jumpbox-provisioner:local provision.sh prod

destroy-staging-jumpbox: ## Destroys staging jumpbox
	@docker run --platform linux/amd64 --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			jumpbox-provisioner:local destroy.sh staging

destroy-prod-jumpbox: ## Destroys prod jumpbox
	@docker run --platform linux/amd64 --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			jumpbox-provisioner:local destroy.sh prod
