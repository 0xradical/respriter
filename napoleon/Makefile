HEROKU_POSTGREST_NAME := napoleon-postgrest-
HEROKU_PRD_APP        := napoleon-the-crawler
HEROKU_STG_APP        := napoleon-stg

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
DATABASE_IMAGE_TAG  := $(shell cat ./database/db/structure.sql.env | $(SHA1SUM) | sed -e 's/ .*//g')
DATABASE_IMAGE      := $(DATABASE_IMAGE_NAME):$(DATABASE_IMAGE_TAG)

DOCKER              := docker
DOCKER_COMPOSE      := DATABASE_IMAGE=$(DATABASE_IMAGE) APP_IMAGE=$(APP_IMAGE) docker-compose
DOCKER_COMPOSE_PATH := $(shell which docker-compose)

WORKERS         ?= 1
DB_DUMPS_FOLDER := ./db/dumps
SEEDS_DIR       := ./db/seeds
SEEDS_FILES     := $(shell ls providers/*/*.sql.erb | sed 's/.erb//' | sed 's/providers\//\.\/db\/seeds\//')

ifeq ($(RAILS_ENV), production)
	CUSTOM_ENV_FILES := LESS_PRIORITY-noop
else
	CUSTOM_ENV_FILES := $(shell ls envs/dev/* | sed 's/\/dev\//\/local\//g' | xargs)
endif

define docker_run_or_plain
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $(DOCKER_COMPOSE) run --rm $3 -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 `$(MAKE_BIN)/container_alias $1` $2; else $2; fi;
endef

define docker_run_with_ports_or_plain
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $(DOCKER_COMPOSE) run --rm --service-ports -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 `$(MAKE_BIN)/container_alias $1` $2; else $2; fi;
endef

default: help
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-seeds: $(SEEDS_FILES) ## Creates or updates seeds for each provider (only those that are required)

build-provider-%: $(SEEDS_DIR)/%/setup.sql ## Creates or updates for a given provider

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

db-download: db-download-prd ## Alias to db-download-prd

db-download-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) ## Creates a database dump for a given env
	@$(call docker_run_or_plain,base,bin/db_download ./envs/$*/database.env $(DB_DUMPS_FOLDER)/$*)

db-load: db-load-dev-prd ## Alias to db-load-dev-prd

db-load-dev-%: $(CUSTOM_ENV_FILES) ## At dev database, apply dump from a given env
	@$(call docker_run_or_plain,napoleon,bin/db_load ./envs/dev/database.env $(DB_DUMPS_FOLDER)/$*)

db-load-prd-%: ./envs/prd/database.env $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## [BE CAREFULL] At prd database, apply dump from a given env
	@$(call docker_run_or_plain,base,bin/db_load ./envs/prd/database.env $(DB_DUMPS_FOLDER)/$*)

db-load-stg-%: ./envs/stg/database.env $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## [BE CAREFULL] At stg database, apply dump from a given env
	@$(call docker_run_or_plain,base,bin/db_load ./envs/stg/database.env $(DB_DUMPS_FOLDER)/$*)

db-reset: db-reset-dev ## Alias to db-reset-dev

db-reset-dev: ./envs/dev/database.env $(CUSTOM_ENV_FILES) ## Resets dev database
	@$(call docker_run_or_plain,napoleon,bin/db_reset envs/dev/database.env)

db-reset-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## Resets Database for a given env
	@$(call docker_run_or_plain,base,bin/db_reset envs/$*/database.env)

db-migrate: db-migrate-dev ## Alias to db-migrate-dev

db-migrate-dev: ./envs/dev/database.env $(CUSTOM_ENV_FILES) ## Migrates env database
	@$(call docker_run_or_plain,napoleon,bin/db_migrate ./envs/dev/database.env ./database/db/migrations)

db-migrate-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## Migrates database for a given env
	@$(call docker_run_or_plain,base,bin/db_migrate ./envs/$*/database.env ./database/db/migrations)

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

restart-prd: ## Restarts all napoleon prd dynos
	@heroku ps:restart --app $(HEROKU_PRD_APP)

restart-stg: ## Restarts all napoleon stg dynos
	@heroku ps:restart --app $(HEROKU_STG_APP)

restart-api-%: ## Restarts all napoleon api dynos for a given env
	@heroku ps:restart --app $(HEROKU_POSTGREST_NAME)-$*

worker:
	@$(call docker_run_or_plain,napoleon,bundle exec que -w $(WORKERS) ./app.rb)

console: console-dev ## Alias to console-dev
	@$(call docker_run_or_plain,napoleon,bundle exec pry -r ./app.rb)

console-dev: $(CUSTOM_ENV_FILES) ## Runs console at dev env
	@$(call docker_run_or_plain,$*,bundle exec pry -r ./app.rb)

console-prd: ## Runs console at prd env
	@heroku run console --app $(HEROKU_PRD_APP)

console-stg: ## Runs console at stg env
	@heroku run console --app $(HEROKU_STG_APP)

psql: psql-dev ## Alias to psql-dev

psql-dev: ./envs/dev/database.env $(CUSTOM_ENV_FILES) ## Runs psql console for dev
	@$(call docker_run_or_plain,napoleon,./bin/psql ./envs/dev/database.env)

psql-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) LESS_PRIORITY-% ## Runs psql console for a given env
	@$(call docker_run_or_plain,base,./bin/psql ./envs/$*/database.env)

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

logs-prd: ## Display and follow all napoleon prd logs
	@heroku logs -t --app $(HEROKU_PRD_APP)

logs-stg: ## Display and follow all napoleon stg logs
	@heroku logs -t --app $(HEROKU_STG_APP)

logs-api-%: ## Display and follow all napoleon postgrest api logs for a given env
	@heroku logs -t --app $(HEROKU_POSTGREST_NAME)-$*

watch: $(CUSTOM_ENV_FILES) ## Inspect running containers
	@watch -n 3 $(DOCKER_COMPOSE) ps

watch-prd: ## Inspect running prd dynos
	@watch -n 3 heroku ps --app $(HEROKU_PRD_APP)

watch-stg: ## Inspect running stg dynos
	@watch -n 3 heroku ps --app $(HEROKU_STG_APP)

watch-api-%: ## Inspect running napoleon postgrest api dynos for a given env
	@watch -n 3 heroku ps --app $(HEROKU_POSTGREST_NAME)-$*

clean: $(CUSTOM_ENV_FILES) ## Stops all containers and clean docker env BUT KEEP VOLUMES
	@$(DOCKER_COMPOSE) down --rmi local --remove-orphans
	@docker system prune -f

wipe: $(CUSTOM_ENV_FILES) ## Stops all containers and clean docker env AND DELETE VOLUMES
	@$(DOCKER_COMPOSE) down -v --rmi local --remove-orphans
	@docker system prune -f

LESS_PRIORITY-%:
	@:

$(SEEDS_DIR)/%/setup.sql: ./providers/%.rb ./providers/%
	@mkdir -p `dirname $@`
	@$(call docker_run_or_plain,base,ruby $<)
	@echo "Seed file $@ created or updated!"

./envs/local/%:
	@mkdir -p ./envs/local
	@./bin/create_default_local_env $*

./envs/%/database.env: LESS_PRIORITY-%
	@mkdir -p ./envs/$*
	@./bin/create_remote_database_env $*

.PHONY: build-seeds build-provider-% setup-provider-% setup-provider-dev-% setup-provider-stg-% setup-provider-prd-% clean-pipelines db-download db-download-% db-load db-load-dev-% db-load-prd-% db-load-stg-% db-reset db-reset-dev db-reset-% db-migrate db-migrate-dev db-migrate-% run run-% up up-% down down-% restart-% restart-prd restart-stg worker restart-api-% console console-% console-prd console-stg psql psql-dev psql-% bash bash-% bash-ports-% sh sh-% sh-ports-% test rspec spec cucumber docker-build docker-push logs logs-% logs-prd logs-stg logs-api-% watch watch-prd watch-stg watch-api-% clean wipe LESS_PRIORITY-%
