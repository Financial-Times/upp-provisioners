.PHONY: build-provisioner

help:    ## Show this help.
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)

build-provisioner: ## Build  provisioner
	@docker build -t sns-provisioner:local .

deploy-sns-testaccount-eu: ## Deploy SNS in TEST account EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sns-provisioner:local deploy-sns.sh cloudformation/sns-testaccount-eu.yaml upp-testaccount-sns

remove-sns-testaccount-eu: ## Delete all SNS in TEST EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sns-provisioner:local /bin/bash remove-sns.sh upp-testaccount-sns

deploy-sns-prod-eu: ## Deploy SNS in PROD account EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sns-provisioner:local deploy-sns.sh cloudformation/sns-prod-eu.yaml upp-prod-eu-sns

remove-sns-prod-eu: ## Delete all SNS in PROD EU
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=eu-west-1" \
			sns-provisioner:local /bin/bash remove-sns.sh upp-prod-eu-sns

deploy-sns-prod-us: ## Deploy SNS in PROD account US
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=us-east-1" \
			sns-provisioner:local deploy-sns.sh cloudformation/sns-prod-us.yaml upp-prod-us-sns

remove-sns-prod-us: ## Delete all SNS in PROD US
	@docker run --rm -it \
			-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
			-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
			-e "AWS_REGION=us-east-1" \
			sns-provisioner:local /bin/bash remove-sns.sh upp-prod-us-sns
