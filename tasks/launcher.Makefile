SERVICES := $(shell /bin/sh -c "cat $(MONOREPO_PATH)/docker-compose.yml | grep -e '\.clspt:$$' | sed -e 's/  //g' | sed -e 's/\://g' | sed '/volumes/d' | sed '/base/d'")

HEROKU_WEB_APP_NAME   := classpert-web-app
HEROKU_POSTGREST_NAME := classpert-postgrest
HEROKU_USER_DASH_NAME := clspt-user-dashboard
HEROKU_DEV_DASH_NAME  := clspt-developers-dashboard
HEROKU_VIDEO_NAME     := classpert-video-service
HEROKU_POSTGREST_NAME := napoleon-postgrest-
HEROKU_PRD_APP        := napoleon-the-crawler
HEROKU_STG_APP        := napoleon-stg

run: $(LOCAL_ENV_FILES) ## Runs all containers attached
	$(DOCKER_COMPOSE) up $(SERVICES)

run-%: $(LOCAL_ENV_FILES) ## Run a given container attached
	$(DOCKER_COMPOSE) up `$(MAKE_BIN)/container_alias $*`

up: $(LOCAL_ENV_FILES) ## Run all containers dettached
	$(DOCKER_COMPOSE) up -d $(SERVICES)

up-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Run a given container dettached
	$(DOCKER_COMPOSE) up -d `$(MAKE_BIN)/container_alias $*`

up-persistence: up-search up-database up-s3 ## Run all persistence related containers

down: clean ## Alias to clean

down-%: $(LOCAL_ENV_FILES) ## Stops a given container
	$(DOCKER_COMPOSE) stop `$(MAKE_BIN)/container_alias $*`
	$(DOCKER_COMPOSE) rm -f `$(MAKE_BIN)/container_alias $*`

clean: $(LOCAL_ENV_FILES) ## Stops all containers and clean docker env BUT KEEP VOLUMES
	@$(DOCKER_COMPOSE) down --rmi local --remove-orphans
	@docker system prune -f

wipe: $(LOCAL_ENV_FILES) ## Stops all containers and clean docker env AND DELETE VOLUMES
	@$(DOCKER_COMPOSE) down -v --rmi local --remove-orphans
	@docker system prune -f

restart-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Restarts a given container
	@$(DOCKER_COMPOSE_VARS) $(MAKE_BIN)/remote_or_dev $* "heroku ps:restart --app `$(MAKE_BIN)/remote_alias $*`" "docker-compose restart `$(MAKE_BIN)/container_alias $*`"

console-%: LESS_PRIORITY-% ## Run console for a given app, local or remote
	@$(DOCKER_COMPOSE_VARS) $(MAKE_BIN)/remote_or_dev $* "heroku run console --app `$(MAKE_BIN)/remote_alias $*`" "docker-compose run --rm `$(MAKE_BIN)/container_alias $*` make console"

psql-%:
	@$(DOCKER) run --rm -it --env-file $(MONOREPO_PATH)/`$(MAKE_BIN)/database_alias $*` -v `pwd`:/repo -w /repo --network classpert postgres:11.4-alpine sh -c 'psql `echo $$POSTGRES_URL | sed "s/?.*//g"`'

bash: bash-app ## Alias to bash-app

bash-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Runs bash for a given container
	@$(DOCKER_COMPOSE_VARS) $(MAKE_BIN)/remote_or_dev $* "heroku run bash --app `$(MAKE_BIN)/remote_alias $*`" "docker-compose run --rm `$(MAKE_BIN)/container_alias $*` /bin/bash"

bash-ports-%: $(LOCAL_ENV_FILES) ## Runs bash for a given container with service ports
	@$(call docker_run_with_ports_or_plain,$*,/bin/bash)

sh: sh-app ## Alias to sh-app

sh-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Runs sh for a given container
	@$(DOCKER-COMPOSE) run --rm `$(MAKE_BIN)/container_alias $*` /bin/sh

sh-ports-%: $(LOCAL_ENV_FILES) ## Runs sh for a given container with service ports
	@$(call docker_run_with_ports_or_plain,$*,/bin/sh)

detached-make-%: ## On `make detached-make-REMOTE_APP-ENV-REMOTE_TASK` Executes `make REMOTE_TASK` detached at a given REMOTE_APP with given ENV
	@$(eval REMOTE := $(shell echo $* | cut -d- -f1))
	@$(eval TASK   := $(shell echo $* | cut -d- -f2-))
	@heroku run:detached make $(TASK) --app `$(MAKE_BIN)/remote_alias $(REMOTE)`

attached-make-%: ## ## On `make detached-make-REMOTE_APP-ENV-REMOTE_TASK` Executes `make REMOTE_TASK` attached at a given REMOTE_APP with given ENV
	@$(eval REMOTE := $(shell echo $* | cut -d- -f1-2))
	@$(eval TASK   := $(shell echo $* | cut -d- -f3-))
	@heroku run make $(TASK) --app `$(MAKE_BIN)/remote_alias $(REMOTE)`

logs: $(LOCAL_ENV_FILES) ## Display and follow all dev logs
	@$(DOCKER_COMPOSE) logs -f

logs-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Display and follow dev logs for a given container
	@$(DOCKER_COMPOSE_VARS) $(MAKE_BIN)/remote_or_dev $* "heroku logs -t --app `$(MAKE_BIN)/remote_alias $*`" "docker-compose logs -f `$(MAKE_BIN)/container_alias $*`"

watch: $(LOCAL_ENV_FILES) ## Inspect running containers
	@watch -n 3 $(DOCKER_COMPOSE) ps

watch-%: ## Inspect running dynos for a remote app
	@watch -n 3 heroku ps --app `$(MAKE_BIN)/remote_alias $*`

.PHONY: run run-% up up-% up-persistence down down-% clean wipe restart-% console-% psql-% bash bash-% bash-ports-% sh sh-% sh-ports-% detached-make-% attached-make-% logs logs-% logs-remote-% watch watch-%
