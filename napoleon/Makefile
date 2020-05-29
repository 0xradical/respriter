HEROKU_POSTGREST_NAME := napoleon-postgrest-
HEROKU_PRD_APP        := napoleon-the-crawler
HEROKU_STG_APP        := napoleon-stg

MAKE_BIN := ./bin

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	SHA1SUM := gsha1sum
else
	# assume linux
	SHA1SUM := sha1sum
endif

APP_IMAGE_NAME := classpert/napoleon
APP_IMAGE_TAG  := $(shell cat Gemfile.lock | $(SHA1SUM) | sed -e 's/ .*//g')
APP_IMAGE      := $(APP_IMAGE_NAME):$(APP_IMAGE_TAG)

DATABASE_IMAGE_NAME := classpert/napoleon_database
DATABASE_IMAGE_TAG  := $(shell cat ../napoleon-database/db/structure.sql.env | $(SHA1SUM) | sed -e 's/ .*//g')
DATABASE_IMAGE      := $(DATABASE_IMAGE_NAME):$(DATABASE_IMAGE_TAG)

DOCKER              := docker
DOCKER_COMPOSE      := DATABASE_IMAGE=$(DATABASE_IMAGE) APP_IMAGE=$(APP_IMAGE) docker-compose
DOCKER_COMPOSE_PATH := $(shell which docker-compose)

WORKERS     ?= 1
SEEDS_DIR   := ./db/seeds
SEEDS_FILES := $(shell ls providers/*/*.sql.erb | sed 's/.erb//' | sed 's/providers\//\.\/db\/seeds\//')

ifeq ($(RAILS_ENV), production)
	CUSTOM_ENV_FILES := LESS_PRIORITY-noop
else
	CUSTOM_ENV_FILES := $(shell ls envs/dev/* | sed 's/\/dev\//\/local\//g' | xargs)
endif

define docker_run_or_plain
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $(DOCKER_COMPOSE) run --rm $3 -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 `$(MAKE_BIN)/container_alias $1` $2; else $2; fi;
endef

define docker_run_with_ports_or_plain
	@$(call docker_run_or_plain,$1,$2,--service-ports $3)
endef

default: help
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-seeds: $(SEEDS_FILES) ## Creates or updates seeds for each provider (only those that are required)

build-provider-%: ## Creates or updates for a given provider
	@make -s $(SEEDS_DIR)/$*/setup.sql

setup-provider-%: LESS_PRIORITY-% ## Alias to setup-provider-dev-%
	@make -s setup-provider-dev-$*

setup-provider-dev-%: $(CUSTOM_ENV_FILES) ## Setups given provider creating its PipelineTemplate for env dev
	@$(call docker_run_or_plain,napoleon,./bin/psql ./envs/dev/database.env -f $(SEEDS_DIR)/$*/setup.sql)

setup-provider-stg-%: $(CUSTOM_ENV_FILES) ## Setups given provider creating its PipelineTemplate for env stg
	@$(call docker_run_or_plain,base,./bin/psql ./envs/stg/database.env -f $(SEEDS_DIR)/$*/setup.sql)

setup-provider-prd-%: $(CUSTOM_ENV_FILES) ## Setups given provider creating its PipelineTemplate for env prd
	@$(call docker_run_or_plain,base,./bin/psql ./envs/prd/database.env -f $(SEEDS_DIR)/$*/setup.sql)

clean-pipelines: $(CUSTOM_ENV_FILES) ## Deletes all que_jobs, pipeline_templates, pipelines and pipe_processes in development
	@echo "Cleaning Pipelines"
	@$(call docker_run_or_plain,napoleon,./bin/psql ./envs/dev/database.env -c "DELETE FROM que_jobs; DELETE FROM app.pipeline_templates; DELETE FROM app.pipelines; DELETE FROM app.pipe_processes;")

run: $(CUSTOM_ENV_FILES) ## Runs all containers attached
	$(DOCKER_COMPOSE) up

run-%: $(CUSTOM_ENV_FILES) ## Run a given container attached
	$(DOCKER_COMPOSE) up `$(MAKE_BIN)/container_alias $*`

up: $(CUSTOM_ENV_FILES) ## Run all containers dettached
	$(DOCKER_COMPOSE) up -d

up-%: $(CUSTOM_ENV_FILES) ## Run a given container dettached
	$(DOCKER_COMPOSE) up -d `$(MAKE_BIN)/container_alias $*`

down: clean ## Alias to clean

down-%: $(CUSTOM_ENV_FILES) ## Stops a given container
	$(DOCKER_COMPOSE) down `$(MAKE_BIN)/container_alias $*`
	$(DOCKER_COMPOSE) rm -f `$(MAKE_BIN)/container_alias $*`

restart-%: $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## Restarts a given container
	$(DOCKER_COMPOSE) restart `$(MAKE_BIN)/container_alias $*`

worker:
	@$(call docker_run_or_plain,napoleon,bundle exec que -w $(WORKERS) ./app.rb)

console: ## Runs console at dev env
	@$(call docker_run_or_plain,napoleon,bundle exec pry -r ./app.rb)

psql: ## Alias to psql-dev
	@make -s psql-dev

psql-%: ## Opens psql console for a given env
	@cd .. && make -s psql-napoleon-$*

bash: bash-napoleon ## Alias to bash-napoleon

bash-%: $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## Runs bash for a given container
	@$(call docker_run_or_plain,$*,/bin/bash)

bash-ports-%: $(CUSTOM_ENV_FILES) ## Runs bash for a given container with service ports
	@$(call docker_run_with_ports_or_plain,$*,/bin/bash)

sh: sh-napoleon ## Alias to sh-napoleon

sh-%: $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## Runs sh for a given container
	@$(call docker_run_or_plain,$*,/bin/sh)

sh-ports-%: $(CUSTOM_ENV_FILES) ## Runs sh for a given container with service ports
	@$(call docker_run_with_ports_or_plain,$*,/bin/sh)

test: $(CUSTOM_ENV_FILES) ## Runs all tests
	@$(call docker_run_or_plain,test,make spec cucumber)

rspec: spec ## Alias to spec

spec: $(CUSTOM_ENV_FILES) ## Runs rspec tests
	@$(call docker_run_or_plain,test,bundle exec rspec)

cucumber: $(CUSTOM_ENV_FILES) ## Runs cucumber tests
	@$(call docker_run_or_plain,test,sh -c "bundle exec cucumber --tags @ignore-webmock && bundle exec cucumber --tags 'not @ignore-webmock'")

docker-build: $(CUSTOM_ENV_FILES) ## Builds all containers described at docker-compose.yml
	@$(DOCKER_COMPOSE) build

docker-push: ## Pushes Napoleon App and Database images to DockerHub
	@$(DOCKER) push $(DATABASE_IMAGE)
	@$(DOCKER) push $(APP_IMAGE)

logs: $(CUSTOM_ENV_FILES) ## Display and follow all dev logs
	@$(DOCKER_COMPOSE) logs -f

logs-%: $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## Display and follow dev logs for a given container
	@$(DOCKER_COMPOSE) logs -f `$(MAKE_BIN)/container_alias $*`

watch: $(CUSTOM_ENV_FILES) ## Inspect running containers
	@watch -n 3 $(DOCKER_COMPOSE) ps

clean: $(CUSTOM_ENV_FILES) ## Stops all containers and clean docker env BUT KEEP VOLUMES
	@$(DOCKER_COMPOSE) down --rmi local --remove-orphans
	@docker system prune -f

wipe: $(CUSTOM_ENV_FILES) ## Stops all containers and clean docker env AND DELETE VOLUMES
	@$(DOCKER_COMPOSE) down -v --rmi local --remove-orphans
	@docker system prune -f

LESS_PRIORITY-%:
	@:

./db/seeds/%/setup.sql: ./providers/%.rb ./providers/%
	@mkdir -p `dirname $@`
	@$(call docker_run_or_plain,base,ruby $<)
	@echo "Seed file $@ created or updated!"

./envs/local/%:
	@mkdir -p ./envs/local
	@./bin/create_default_local_env $*

./envs/%/database.env: LESS_PRIORITY-%
	@mkdir -p ./envs/$*
	@./bin/create_remote_database_env $*

.PHONY: build-seeds build-provider-% setup-provider-% setup-provider-dev-% setup-provider-stg-% setup-provider-prd-% clean-pipelines run run-% up up-% down down-% restart-% worker console psql psql-% bash bash-% bash-ports-% sh sh-% sh-ports-% test rspec spec cucumber docker-build docker-push logs logs-% watch clean wipe LESS_PRIORITY-%
