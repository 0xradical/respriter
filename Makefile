NAME   :=	classpert/respriter
TAG    :=	1.0.0
IMG    :=	${NAME}\:${TAG}
LATEST :=	${NAME}\:latest

ENV ?= development
DOCKER_COMPOSE_PATH := $(shell which docker-compose)
DOCKER_COMPOSE := docker-compose
DOCKER_CONTAINER := respriter_$(ENV)

define only_outside_docker
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $1; fi;
endef

define docker_run_or_plain
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $(DOCKER_COMPOSE) run --rm $2 $(DOCKER_CONTAINER) $1; else $1; fi;
endef

define docker_run_with_ports_or_plain
	@$(call docker_run_or_plain,$1,--service-ports $2)
endef

.PHONY: help setup prepare clean dev force-deploy-stg build tty bash down docker-build docker-push

help:
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: .env .env.production docker-compose.yml ## Setup project
	@make docker-pull
	@make docker-build
	@$(call docker_run_or_plain,npm install)

serve: ## Run server
	@$(call docker_run_with_ports_or_plain,npm run serve)

test: ## Run tests
	@$(call docker_run_or_plain,bundle exec rspec)

force-deploy-stg:
	@git commit --allow-empty-message -m ''
	@git push origin master:staging

clean: ## Clean build
	@rm -rf dist/**

tty: ## Attach a tty to the app container. Usage e.g: make tty
	@$(call docker_run_or_plain,/bin/sh,--entrypoint '' $2)

bash: tty

console: ## Open a Pry console with Respriter loaded
	@$(call docker_run_or_plain,bundle exec pry -r ./lib/respriter.rb,--entrypoint '' $2)

down: ## Run docker-compose down
	@docker-compose down

docker-build: Dockerfile ## Builds the docker image
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

docker-push: ## Pushes the docker image to Dockerhub
	@docker push ${NAME}

docker-pull: ## Pulls the docker image from Dockerhub
	@docker pull ${NAME}

%: | examples/%.example
	cp -n $| $@
