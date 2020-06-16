NAME   :=	classpert/spriter
TAG    :=	1.0.0
IMG    :=	${NAME}\:${TAG}
LATEST :=	${NAME}\:latest

ENV ?= development
DOCKER_COMPOSE_RUN = @docker-compose run $(DOCKER_COMPOSE_FLAGS) npm_$(ENV)
BASH_ENTRYPOINT = --entrypoint /bin/sh
NPM_RUN = $(DOCKER_COMPOSE_RUN) run
NPM_VERSION = $(DOCKER_COMPOSE_RUN) version

.PHONY: help setup prepare clean bump-semver dev build tty bash down docker-build docker-push git-push

help:
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: .env .env.production docker-compose.yml ## Setup project
	@make docker-build

build: ## Build assets
	@rm -rf dist/**
	$(NPM_RUN) build
	@rm -rf dist/main.js dist/index.html dist/test.js

release: ENV = production
release: build bump-semver git-commit git-push git-push-tags publish ## Bump elements to version identified by [v] | e.g make release v={minor,major,patch,$version}

publish: ## Run npm publish
	$(DOCKER_COMPOSE_RUN) publish

dev: DOCKER_COMPOSE_FLAGS = --service-ports
dev: ## Run webpack-dev-server
	$(NPM_RUN) dev

bump-semver: ENV = production
bump-semver:
	$(NPM_VERSION) $(v)

git-commit:
	@git add .
	@git commit -m "Adding build for version $(v)"

git-push:
	@git push origin $$(git branch --show-current)

git-push-tags:
	@git push origin --tags

clean: ## Clean build
	@rm -rf dist/**

tty: DOCKER_COMPOSE_FLAGS = $(BASH_ENTRYPOINT)
tty: ## Attach a tty to the app container. Usage e.g: make tty
	$(DOCKER_COMPOSE_RUN)

bash: tty

down: ## Run docker-compose down
	@docker-compose down

docker-build: Dockerfile ## Builds the docker image
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

docker-push: ## Pushes the docker image to Dockerhub
	@docker push ${NAME}

%: | examples/%.example
	cp -n $| $@
