DOCKER_COMPOSE_PATH    := $(shell which docker-compose)
DOCKER_CONTAINER_ALIAS ?= $(MAKE_BIN)/container_alias

define only_outside_docker
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $1; fi;
endef

define docker_run_or_plain
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $(DOCKER_COMPOSE) run --rm $3 -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 `$(DOCKER_CONTAINER_ALIAS) $1` $2; else $2; fi;
endef

define docker_run_with_ports_or_plain
	@$(call docker_run_or_plain,$1,$2,--service-ports $3)
endef

docker-build: $(LOCAL_ENV_FILES) ## Builds all required images
	@$(DOCKER_COMPOSE) build

docker-pull: $(LOCAL_ENV_FILES) ## Pulls all required images
	@$(DOCKER_COMPOSE) pull

docker-push: $(LOCAL_ENV_FILES) ## Pushes the docker image to Dockerhub
	@$(DOCKER_COMPOSE) push

docker-build-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Builds all required images
	@$(DOCKER_COMPOSE) build `$(DOCKER_CONTAINER_ALIAS) $*`

docker-pull-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Pulls all required images
	@$(DOCKER_COMPOSE) pull `$(DOCKER_CONTAINER_ALIAS) $*`

docker-push-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Pushes the docker image to Dockerhub
	@$(DOCKER_COMPOSE) push `$(DOCKER_CONTAINER_ALIAS) $*`

docker-make-%: $(LOCAL_ENV_FILES) ## Executes `make SOMETHING` inside base service
	@$(call docker_run_or_plain,`echo $* | cut -d- -f1`,make -s `echo $* | cut -d- -f2-`)

docker-build-base: ## Builds the base docker image
	@$(DOCKER) build -f $(DOCKER_BASE_FILE) -t $(DOCKER_BASE_IMAGE) -t $(DOCKER_BASE_LATEST) .

docker-push-base: ## Pushes the docker base image to Dockerhub
	@$(DOCKER) push $(DOCKER_BASE_IMAGE)

.PHONY: docker-build docker-pull docker-push docker-build-% docker-pull-% docker-push-% docker-make-% docker-build-base docker-push-base
