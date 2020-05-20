APP_NAME := user

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	SHA1SUM := gsha1sum
else
	# assume linux
	SHA1SUM := sha1sum
endif

APP_IMAGE_NAME := classpert/user-dashboard
APP_IMAGE_TAG  := $(shell cat package-lock.json | $(SHA1SUM) | sed -e 's/ .*//g')
APP_IMAGE      := $(APP_IMAGE_NAME):$(APP_IMAGE_TAG)

CYPRESS_IMAGE_NAME := classpert/cypress_user_dashboard
CYPRESS_IMAGE_TAG  := $(shell cat test/package-lock.json | $(SHA1SUM) | sed -e 's/ .*//g')
CYPRESS_IMAGE      := $(CYPRESS_IMAGE_NAME):$(CYPRESS_IMAGE_TAG)

HOST_IP_ADDRESS := $(shell ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $$2 }' | cut -f2 -d: | head -n1)

GITHUB_ACCESS_TOKEN ?= $(shell heroku config:get GITHUB_ACCESS_TOKEN --app clspt-user-dashboard-prd)

LOCAL_NODE_MODULES ?= $(shell [ -f ".local_node_modules" ] && echo "./node_modules:" || echo "")

DOCKER         := DOCKER
DOCKER_COMPOSE := LOCAL_NODE_MODULES=$(LOCAL_NODE_MODULES) APP_IMAGE=$(APP_IMAGE) CYPRESS_IMAGE=$(CYPRESS_IMAGE) docker-compose

define only_on_mac
	if [ "$$(UNAME)" = "Darwin" ]; then echo '$(1)' | sed 's/(\(.*\))/\1/' | sh -; fi;
endef

help: ## List all tasks
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

sh: ## Alias to sh-user
	@make -s sh-$(APP_NAME)

sh-%: ./envs/local.env ## Attach to sh
	@$(DOCKER_COMPOSE) run --entrypoint /bin/sh $*

test: ./envs/local.env ## Runs Cypress headlessly with default browser Electron Headless (because it the fastest)
	@$(DOCKER_COMPOSE) run --rm cypress npx cypress run

test-%: ./envs/local.env LESS_PRIORITY-% ## Runs Cypress headlessly with a given browser (chrome or firefox)
	@$(DOCKER_COMPOSE) run --rm cypress npx cypress run --browser $*

test-all: test test-chrome test-firefox ## Runs Cypress with all browsers

test-gui: ./envs/local.env ## Runs Cypress with GUI exported with X11
	@$(call only_on_mac, (socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$$DISPLAY\" &))
	$(DOCKER_COMPOSE) run --rm -e DISPLAY=$(HOST_IP_ADDRESS):0 --entrypoint cypress cypress open --project .

prepare: ## Make this project ready to use without running it
	@git submodule update
	@make -s npm-install

npm-install: ./envs/local.env ## Install node_modules
	@$(DOCKER_COMPOSE) run $(APP_NAME) npm install

npm-run-%: ./envs/local.env ## Run "npm run SOMETHING" at application
	@$(DOCKER_COMPOSE) run $(APP_NAME) npm run $*

up: ./envs/local.env ## Run containers
	@$(DOCKER_COMPOSE) up -d user mockserver

up-%: ./envs/local.env ## Runs single container
	@$(DOCKER_COMPOSE) up -d $*

down: ./envs/local.env ## Removes all containers and cleans docker environment
	@$(DOCKER_COMPOSE) down --rmi local --remove-orphans
	@$(DOCKER) system prune -f

down-%: ./envs/local.env ## Stops and Removes a service
	$(DOCKER_COMPOSE) stop $*
	$(DOCKER_COMPOSE) rm -f $*

clean: down ## Alias to down

watch: ./envs/local.env ## Monitors container status
	@watch -n 5 $(DOCKER_COMPOSE) ps

logs: ./envs/local.env ## Follow logs
	@$(DOCKER_COMPOSE) logs -f

logs-%: ./envs/local.env ## Follow logs for a given container
	@$(DOCKER_COMPOSE) logs -f $*

docker-build: ./envs/local.env ## Build images
	@$(DOCKER_COMPOSE) build --build-arg "GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN)"

docker-pull: ./envs/local.env ## Pull images
	@$(DOCKER_COMPOSE) pull

docker-push: ## Push Developer Dashboard Image
	@$(DOCKER) push $(APP_IMAGE)
	# @$(DOCKER) push $(CYPRESS_IMAGE)

LESS_PRIORITY-%: # Just a gimmick to order tasks
	@:

./envs/local.env:
	@echo "GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN)" > $@

.PHONY: help sh sh-% test test-% test-all test-gui prepare npm-install npm-run-% up up-% down down-% clean watch logs logs-% docker-build docker-pull docker-push LESS_PRIORITY-%
