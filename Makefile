BASH=$(shell which bash)
SHELL ?= $(BASH)
VERSION=$(shell git describe --tags --abbrev=0 2>/dev/null)
# VERSION=$(shell echo ${VERSION:-1.0})
NEXT_VERSION=$(shell echo ${VERSION} | awk -F. '{$$NF+=1; OFS="."; print $$0}')
# NEXT_VERSION=${NEXT_VERSION:-1.0}
DOCKER_ID_USER=raoptimus
DOCKER_IMAGE=go-magick

version:
	@echo "current: ${VERSION}, next: ${NEXT_VERSION}"

build: version
	docker build -f ./Dockerfile -t ${DOCKER_ID_USER}/${DOCKER_IMAGE}:"${NEXT_VERSION}" -t ${DOCKER_ID_USER}/${DOCKER_IMAGE}:latest  ./

release: version build
	@read -p "Press enter to confirm and push to origin ..."
	git tag $(NEXT_VERSION)
	git push origin $(NEXT_VERSION)
	docker push ${DOCKER_ID_USER}/${DOCKER_IMAGE}:"${NEXT_VERSION}"
	docker push ${DOCKER_ID_USER}/${DOCKER_IMAGE}:latest

    