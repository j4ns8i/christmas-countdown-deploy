IMAGE := christmas-countdown-deploy:latest

SERVICE_IMAGE     := us-central1-docker.pkg.dev/christmas-countdown-372221/christmas-countdown/christmas-countdown
SERVICE_TAG       := v0.1.0
SERVICE_IMAGE_TAG := $(SERVICE_IMAGE):$(SERVICE_TAG)

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
		.

.PHONY: terraform-fmt
terraform-fmt: docker-build
	$(DOCKER_RUN_CMD) terraform fmt

.PHONY: terraform-plan
terraform-plan: docker-build
	$(DOCKER_RUN_CMD) terraform plan -var 'image=$(SERVICE_IMAGE_TAG)'

.PHONY: terraform-apply
terraform-apply: docker-build
	$(DOCKER_RUN_CMD) terraform apply -var 'image=$(SERVICE_IMAGE_TAG)'

.PHONY: shell
shell: docker-build
	$(DOCKER_RUN_CMD)
