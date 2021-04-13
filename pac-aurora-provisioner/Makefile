VERSION?=stable
REGISTRY?=docker.io
ORGANIZATION?=coco
IMAGE_NAME="pac-aurora-provisioner"

all: build

release: clean build push clean

# Builds a docker image
build:
	docker build --no-cache -t "${REGISTRY}/${ORGANIZATION}/pac-aurora-provisioner:${VERSION}" .
	docker tag "${REGISTRY}/${ORGANIZATION}/pac-aurora-provisioner:${VERSION}" "${REGISTRY}/${ORGANIZATION}/pac-aurora-provisioner:latest"

# push the image to an registry
push: build
	docker push ${REGISTRY}/${ORGANIZATION}/pac-aurora-provisioner:${VERSION}
	docker push ${REGISTRY}/${ORGANIZATION}/pac-aurora-provisioner:latest

# remove previous images and containers
clean:
	docker rmi -f "${REGISTRY}/${ORGANIZATION}/pac-aurora-provisioner:${VERSION}" || true
	docker rmi -f "${REGISTRY}/${ORGANIZATION}/pac-aurora-provisioner:latest" || true

.PHONY: release clean build push
