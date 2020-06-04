ifeq ("$(shell pwd)","/app")
  include ./tasks/docker_mocked.Makefile
  CUSTOM_ENV_FILES := LESS_PRIORITY-noop
else
  MONOREPO_PATH := ..
  MAKE_BIN      := ../bin
  SERVICES      := $(shell /bin/sh -c "cat ./docker-compose.yml | grep -e '\.clspt:$$' | sed -e 's/  //g' | sed -e 's/\://g' | sed '/proxy/d'")

  DOCKER_CONTAINER_ALIAS := ./bin/container_alias

  include ../tasks/images.Makefile
  include ../tasks/docker.Makefile
  include ../tasks/launcher.Makefile

  GITHUB_ACCESS_TOKEN ?= $(shell heroku config:get GITHUB_ACCESS_TOKEN --app $(HEROKU_WEB_APP_NAME)-prd)
  LOCAL_NODE_MODULES  ?= $(shell [ -f "$(MONOREPO_PATH)/.local_node_modules" ] && echo "./node_modules:" || echo "")

  DOCKER              := docker
  DOCKER_COMPOSE_VARS := LOCAL_NODE_MODULES=$(LOCAL_NODE_MODULES) GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN) $(DOCKER_COMPOSE_IMAGES)
  DOCKER_COMPOSE      := $(DOCKER_COMPOSE_VARS) docker-compose

  CUSTOM_ENV_FILES := $(shell ls ../envs/dev/* | sed 's/\/dev\//\/local\//g' | xargs)
endif

WORKERS     ?= 1
SEEDS_DIR   := db/seeds
SEEDS_FILES := $(shell ls providers/*/*.sql.erb | sed 's/.erb//' | sed 's/providers\//\.\/db\/seeds\//')

.DEFAULT_GOAL := help

help: ## Get help
	@grep -hE '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

build-seeds: $(SEEDS_FILES) ## Creates or updates seeds for each provider (only those that are required)

build-seeds-%: ## Creates or updates for a given provider
	@make -s $(SEEDS_DIR)/$*/setup.sql

setup-provider-%: LESS_PRIORITY-% ## Set ups provider by name
	@cd $(MONOREPO_PATH) && ./bin/psql napoleon-`echo $* | rev | cut -d- -f1 | rev` -f ./napoleon/$(SEEDS_DIR)/`echo $* | rev | cut -d- -f2- | rev`/setup.sql

clean-pipelines: $(CUSTOM_ENV_FILES) ## Deletes all que_jobs, pipeline_templates, pipelines and pipe_processes in development
	@echo "Cleaning Pipelines..."
	@cd $(MONOREPO_PATH) && ./bin/psql napoleon-dev -c "'DELETE FROM app.pipeline_templates;'"

worker: ## Runs napoleon worker
	@$(call docker_run_or_plain,napoleon,bundle exec que -w $(WORKERS) ./app.rb)

console: ## Runs console at dev env
	@$(call docker_run_or_plain,napoleon,bundle exec pry -r ./app.rb)

psql: ## Alias to psql-dev
	@make -s psql-dev

psql-%: ## Opens psql console for a given env
	@cd .. && make -s psql-napoleon-$*

test: $(CUSTOM_ENV_FILES) ## Runs all tests
	@$(call docker_run_or_plain,napoleon-test,make spec cucumber)

rspec: spec ## Alias to spec

spec: $(CUSTOM_ENV_FILES) ## Runs rspec tests
	@$(call docker_run_or_plain,napoleon-test,bundle exec rspec)

cucumber: $(CUSTOM_ENV_FILES) ## Runs cucumber tests
	@$(call docker_run_or_plain,napoleon-test,sh -c "bundle exec cucumber --tags @ignore-webmock && bundle exec cucumber --tags 'not @ignore-webmock'")

LESS_PRIORITY-%:
	@:

./db/seeds/%/setup.sql: ./providers/%.rb ./providers/%/*
	@mkdir -p `dirname $@`
	@$(call docker_run_or_plain,base,ruby $<)
	@echo "Seed file $@ created or updated!"

../envs/local/%:
	@cd $(MONOREPO_PATH) && make -s `echo $@ | sed 's/\.\.\//\.\//g'`

../envs/%/database-napoleon.env: LESS_PRIORITY-%
	@cd $(MONOREPO_PATH) && make -s $@

.PHONY: help build-seeds build-seeds-% setup-provider-% clean-pipelines worker console psql psql-% test rspec spec cucumber LESS_PRIORITY-%
