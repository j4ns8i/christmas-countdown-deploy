IMAGE := christmas-countdown-deploy:latest

DOCKER_RUN_CMD = docker run \
				  --rm \
				  -ti \
				  -w /christmas-countdown-deploy \
				  -v $(PWD):/christmas-countdown-deploy \
				  -v $(HOME)/.config/gcloud:/home/deploy/.config/gcloud:ro \
				  $(IMAGE)

.PHONY: docker-build
docker-build:
	docker build \
		-t christmas-countdown-deploy \
		--build-arg USER_ID=$(shell id -u) \
		--build-arg GROUP_ID=$(shell id -g) \
		.

.PHONY: terraform-fmt
terraform-fmt: docker-build
	$(DOCKER_RUN_CMD) terraform fmt

.PHONY: terraform-plan
terraform-plan: docker-build
	$(DOCKER_RUN_CMD) terraform plan

.PHONY: terraform-apply
terraform-apply: docker-build
	$(DOCKER_RUN_CMD) terraform apply

.PHONY: shell
shell: docker-build
	$(DOCKER_RUN_CMD)
