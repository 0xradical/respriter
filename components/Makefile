NAME   :=	classpert/components
TAG    :=	1.0.0
IMG    :=	${NAME}\:${TAG}
LATEST :=	${NAME}\:latest

ENV ?= development
DOCKER_COMPOSE_RUN = @docker-compose run $(DOCKER_COMPOSE_FLAGS) npm_$(ENV)
BASH_ENTRYPOINT = --entrypoint /bin/bash
NPM_RUN = $(DOCKER_COMPOSE_RUN) run
NPM_VERSION = $(DOCKER_COMPOSE_RUN) version

.PHONY: help clean bump-semver tty down docker-build docker-push git-push git-push-tags

help:
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

dev: DOCKER_COMPOSE_FLAGS = --service-ports
dev: ## Run webpack-dev-server
	$(NPM_RUN) dev

bump-semver: ENV = production
bump-semver:
	$(NPM_VERSION) $(v)

git-push:
	@git push origin $$(git branch --show-current)

git-push-tags:
	@git push origin --tags

clean: ## Clean build
	@rm -rf ./build

tty: DOCKER_COMPOSE_FLAGS = $(BASH_ENTRYPOINT)
tty: ## Attach a tty to the app container. Usage e.g: make tty
	$(DOCKER_COMPOSE_RUN)

down: ## Run docker-compose down
	@docker-compose down

docker-build: Dockerfile ## Builds the docker image
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

docker-push: ## Pushes the docker image to Dockerhub
	@docker push ${NAME}

%: | examples/%.example
	cp -n $| $@
