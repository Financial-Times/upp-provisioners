.PHONY: build-provisioner provision-sqs-testaccount-eu remove-sqs-testaccount-eu provision-sqs-testaccount-us remove-sqs-testaccount-us provision-sqs-prod-eu remove-sqs-prod-eu provision-sqs-prod-us remove-sqs-prod-us help

help:    ## Show this help.
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)

build-provisioner: ## Build  provisioner
	@docker build -t sqs-provisioner:local .

provision-sqs-testaccount-eu: ## Deploy all SQS in TEST EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sqs-provisioner:local /bin/bash deploy-sqs.sh cloudformation/sqs-testaccount-eu.yaml upp-sqs-testaccount-eu

remove-sqs-testaccount-eu: ## Delete all SQS in TEST EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sqs-provisioner:local /bin/bash remove-sqs.sh upp-sqs-testaccount-eu


provision-sqs-testaccount-us: ## Deploy all SQS in TEST US
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=us-east-1" \
			sqs-provisioner:local /bin/bash deploy-sqs.sh cloudformation/sqs-testaccount-us.yaml upp-sqs-testaccount-us

remove-sqs-testaccount-us: ## Delete all SQS in TEST US
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=us-east-1" \
			sqs-provisioner:local /bin/bash remove-sqs.sh upp-sqs-testaccount-us

provision-sqs-prod-eu: ## Deploy all SQS in PROD EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sqs-provisioner:local /bin/bash deploy-sqs.sh cloudformation/sqs-prod-eu.yaml upp-sqs-prod-eu

remove-sqs-prod-eu: ## Delete all SQS in PROD EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sqs-provisioner:local /bin/bash remove-sqs.sh upp-sqs-prod-eu

provision-sqs-prod-us: ## Deploy all SQS in PROD US
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=us-east-1" \
			sqs-provisioner:local /bin/bash deploy-sqs.sh cloudformation/sqs-prod-us.yaml upp-sqs-prod-us

remove-sqs-prod-us: ## Delete all SQS in PROD US
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=us-east-1" \
			sqs-provisioner:local /bin/bash remove-sqs.sh upp-sqs-prod-us
