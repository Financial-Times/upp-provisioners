.PHONY: rosette-provisioner staging-rosette-rts destroy-staging-rosette-rts prod-rosette-rts destroy-prod-rosette-rts help

help:    ## Show this help.
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)

rosette-rts-provisioner: ## Build  provisioner
	@docker build -t rosette-rts-provisioner:local .

staging-rosette-rts: ## Deploy staging rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-rts-provisioner:local provision.sh staging

prod-rosette-rts: ## Deploy prod rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-rts-provisioner:local provision.sh prod

destroy-staging-rosette-rts: ## Destroys staging rosette steack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-rts-provisioner:local destroy.sh staging

destroy-prod-rosette-rts: ## Destroys prod rosette stack
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			rosette-rts-provisioner:local destroy.sh prod
