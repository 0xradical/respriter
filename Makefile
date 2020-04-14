HEROKU_WEB_APP_NAME   := classpert-web-app
HEROKU_POSTGREST_NAME := classpert-postgrest
HEROKU_USER_DASH_NAME := clspt-user-dashboard
HEROKU_DEV_DASH_NAME  := clspt-developers-dashboard
HEROKU_VIDEO_NAME     := classpert-video-service

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	SHA1SUM := gsha1sum
else
	# assume linux
	SHA1SUM := sha1sum
endif

DOCKER_BASE_NAME   := classpert/rails
DOCKER_BASE_TAG    := 4.0.0
DOCKER_BASE_FILE   := Dockerfile
DOCKER_BASE_IMAGE  := $(DOCKER_BASE_NAME):$(DOCKER_BASE_TAG)
DOCKER_BASE_LATEST := $(DOCKER_BASE_NAME):latest

GITHUB_ACCESS_TOKEN ?= $(shell heroku config:get GITHUB_ACCESS_TOKEN --app $(HEROKU_WEB_APP_NAME)-prd)

DOCKER_WEB_APP_NAME   := classpert/web-app
DOCKER_WEB_APP_TAG    := $(shell cat Gemfile.lock package-lock.json | $(SHA1SUM) | sed -e 's/ .*//g')
DOCKER_WEB_APP_FILE   := Dockerfile.webapp
DOCKER_WEB_APP_IMAGE  := $(DOCKER_WEB_APP_NAME):$(DOCKER_WEB_APP_TAG)
DOCKER_WEB_APP_LATEST := $(DOCKER_WEB_APP_NAME):latest
DOCKER_WEB_APP_ARGS   = GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN)

WORKDIR := $(shell pwd)

DOCKER              := docker
DOCKER_COMPOSE      := docker-compose
DOCKER_COMPOSE_PATH := $(shell which docker-compose)

PG_DUMP_FILE := db/backups/latest.dump

SERVICES := $(shell /bin/sh -c "cat docker-compose.yml | grep -e '\.clspt:$$' | sed -e 's/  //g' | sed -e 's/\://g' | sed '/volumes/d' | sed '/base/d'")

CUSTOM_ENV_FILES := $(shell ls envs/dev/* | sed 's/\/dev\//\/local\//g' | xargs)

define only_outside_docker
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $1; fi;
endef

define docker_run_or_plain
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $(DOCKER_COMPOSE) run --rm $3 -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 $1 $2; else $2; fi;
endef

define docker_run_with_ports_or_plain
	if [ -n "$(DOCKER_COMPOSE_PATH)" ]; then $(DOCKER_COMPOSE) run --rm --service-ports -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 $1 $2; else $2; fi;
endef

help:
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

configure: $(CUSTOM_ENV_FILES)

setup: setup-app setup-database setup-user setup-developer setup-napoleon ## Sets all apps

setup-app: setup-git bundle-install npm-ci ## Sets up Web App installing all its dependencies

setup-git: ## Set up git submodules
	@git submodule init
	@git submodule update

setup-database: ./images/database/production_seed.sql up-persistence course-reindex  ## Sets up Persistence Containers and indexes Search

setup-user: ../user-dashboard ## Sets up User Dashboard installing all its dependencies
	$(DOCKER_COMPOSE) run --rm user.app.clspt install

setup-developer: ../developers-dashboard ## Sets up Developer Dashboard installing all its dependencies
	$(DOCKER_COMPOSE) run --rm developer.app.clspt install

setup-napoleon: ../napoleon up-database up-api.napoleon ## Sets up Napoleon (its dependencies are already installed!)
	@$(call docker_run_or_plain,base.clspt,bundle exec rails runner bin/setup_napoleon.rb)
	@echo -e "Napoleon is ready to crawl some providers! To do so, follow this:\n - Run make up-{persistence,provider,napoleon} or make sure those services are up\n - Wait for a while looking at logs to know when it finishes (checks running make logs)\n - Run make sync"

etc_hosts: $(CUSTOM_ENV_FILES) ## Show domains that should be on /etc/hosts
	@$(call docker_run_or_plain,base.clspt,./bin/etc_hosts)

worker: ## Alias to make run-que

napoleon-worker: ## Alias to make run-napoleon

tty: bash-base ## Alias for bash-base

bash: bash-base ## Alias for bash-base

bash-ports: bash-ports-app ## Alias for bash-ports-app

bash-ports-user: ## Alias for bash-ports-user.app

bash-user: ## Alias for bash-user.app

bash-ports-developer: ## Alias for bash-ports-developer.app

bash-developer: ## Alias for bash-developer.app

sh-ports-user: ## Alias for sh-ports-user.app

sh-user: ## Alias for sh-user.app

sh-ports-developer: ## Alias for sh-ports-developer.app

sh-developer: ## Alias for sh-developer.app

bash-ports-%: $(CUSTOM_ENV_FILES) ## Runs bash for a given container
	@$(call docker_run_with_ports_or_plain,$*.clspt,/bin/bash)

bash-%: $(CUSTOM_ENV_FILES) ## Runs bash for a given container with service ports
	@$(call docker_run_or_plain,$*.clspt,/bin/bash)

sh-ports-%: $(CUSTOM_ENV_FILES) ## Runs sh for a given container
	@$(call docker_run_with_ports_or_plain,$*.clspt,/bin/sh)

sh-%: $(CUSTOM_ENV_FILES) ## Runs sh for a given container with service ports
	@$(call docker_run_or_plain,$*.clspt,/bin/sh)

hypernova: ./ssr/hypernova.js
	node ssr/hypernova.js

console: console-dev ## Alias for console-dev

console-dev: $(CUSTOM_ENV_FILES) ## Run rails console for development
	@$(call docker_run_or_plain,app.clspt,bundle exec rails console)

console-%: ## Run console for a given env
	heroku run console --app=$(HEROKU_WEB_APP_NAME)-$*

build-ssr: ## Creates hypernova bundle
	@$(call docker_run_or_plain,base.clspt,npm run ssr)

npm-install: $(CUSTOM_ENV_FILES) ## Run npm install
	@$(call docker_run_or_plain,base.clspt,npm install)

npm-ci: $(CUSTOM_ENV_FILES) ## Run npm ci
	@$(call docker_run_or_plain,base.clspt,npm ci)

bundle-install: $(CUSTOM_ENV_FILES) ## Run bundle install
	@$(call docker_run_or_plain,base.clspt,bundle install)

rails-migrate: $(CUSTOM_ENV_FILES) ## Run rake db:migrate (probably not necessary and not advised)
	@$(call docker_run_or_plain,base.clspt,bundle exec rake db:migrate)

course-reindex: $(CUSTOM_ENV_FILES) wait-for-elastic-search ## Reindexes Courses on Elasticsearch
	@$(call docker_run_or_plain,base.clspt,bundle exec rails runner "Course.reindex!")

sync: sync-crawling_events wait-for-elastic-search sync-courses ## Sync web-app with napoleon

sync-%: $(CUSTOM_ENV_FILES) ## Sync web-app with napoleon given resources (courses or crawling_events)
	@$(call docker_run_or_plain,base.clspt,bundle exec rake system:scheduler:$*_service,-T)

db-prepare: wipe-db up-persistence course-reindex ## Configures database with seed data and index everything

db-build-seeds: db-build-seeds-stg ## Should be an alias for db-build-seeds-prd, but for now is for db-build-seeds-stg

db-build-seeds-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) ## Build Seeds from Production or Staging
	@$(call docker_run_or_plain,base.clspt,bin/db_build_seeds envs/$*/database.env)

db-migrate: db-migrate-dev ## Alias for db-migrate-dev

db-migrate-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) ## Migrates database for a given env
	@$(call docker_run_or_plain,base.clspt,bin/db_migrate envs/$*/database.env database/db/migrations)

db-load: db-load-dev ## Alias for db-load-dev

db-load-dev: $(CUSTOM_ENV_FILES) ## Loads database from latest dump for development
	@$(call only_outside_docker,make up-database)
	@$(call docker_run_or_plain,base.clspt,bin/db_load envs/dev/database.env $(PG_DUMP_FILE))

db-load-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) ## Loads database from latest dump for a given env
	@$(call docker_run_or_plain,base.clspt,bin/db_load envs/$*/database.env $(PG_DUMP_FILE))

db-reset: db-reset-dev ## Alias for db-reset-dev

db-reset-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) ## Resets database for a given env
	@$(call docker_run_or_plain,base.clspt,bin/db_reset envs/$*/database.env)

db-wipe: wipe-db ## Alias to wipe-db

wipe-db: $(CUSTOM_ENV_FILES) ## Kill database container and volumes
	$(DOCKER_COMPOSE) stop database.clspt
	$(DOCKER_COMPOSE) rm -f database.clspt
	$(DOCKER) volume rm $(shell basename `pwd`)_database_data; exit 0

db-restart: $(CUSTOM_ENV_FILES) ## Restart Database (kill containers and recreate with fresh new volume)
	@make -s wipe-db
	@make -s up-database

db-download: db-download-prd

db-download-%: ./envs/%/database.env $(CUSTOM_ENV_FILES) ## Generates and downloads latest postgres dump
	@$(call docker_run_or_plain,base.clspt,bin/db_download envs/$*/database.env $(PG_DUMP_FILE))

detached-prd-%: ## Executes `make SOMETHING` detached at production
	heroku run:detached make $* --app=$(HEROKU_WEB_APP_NAME)-prd

detached-stg-%: ## Executes `make SOMETHING` detached at staging
	heroku run:detached make $* --app=$(HEROKU_WEB_APP_NAME)-stg

attached-prd-%: ## Executes `make SOMETHING` attached at production
	heroku run make $* --app=$(HEROKU_WEB_APP_NAME)-prd

attached-stg-%: ## Executes `make SOMETHING` attached at staging
	heroku run make $* --app=$(HEROKU_WEB_APP_NAME)-stg

run-all: $(CUSTOM_ENV_FILES) ## Runs all services attached
	$(DOCKER_COMPOSE) up $(SERVICES)

run-user: run-user.app ## Alias for run-user.app

run-developer: run-developer.app ## Alias for run-developer.app

run-%: $(CUSTOM_ENV_FILES) ## Runs an attached service
	$(DOCKER_COMPOSE) up $*.clspt

up-all: $(CUSTOM_ENV_FILES) ## Runs all services detached
	$(DOCKER_COMPOSE) up -d $(SERVICES)

up-user: up-user.app ## Alias for up-user.app

up-developer: up-developer.app ## Alias for up-developer.app

up-persistence: up-search up-database up-s3 ## Runs all persistence related services detached

up-%: $(CUSTOM_ENV_FILES) ## Runs a detached service
	$(DOCKER_COMPOSE) up -d $*.clspt

restart-user: restart-user.app ## Alias for restart-user.app

restart-developer: restart-developer.app ## Alias for restart-developer.app

restart-persistence: restart-search restart-database restart-s3 ## Runs all persistence related services detached

restart-%: $(CUSTOM_ENV_FILES) ## Restarts a service
	$(DOCKER_COMPOSE) restart $*.clspt

down: clean ## Alias for clean

down-all: clean ## Alias for clean

down-user: down-user.app ## Alias for down-user.app

down-developer: down-developer.app ## Alias for down-developer.app

down-persistence: down-search down-database down-s3 ## Runs all persistence related services detached

down-%: $(CUSTOM_ENV_FILES) ## Stops and Removes a service
	$(DOCKER_COMPOSE) stop $*.clspt
	$(DOCKER_COMPOSE) rm -f $*.clspt

docker-build-base: ## Builds the base docker image
	@$(DOCKER) build -f $(DOCKER_BASE_FILE) -t $(DOCKER_BASE_NAME) .
	@$(DOCKER) tag $(DOCKER_BASE_NAME) $(DOCKER_BASE_LATEST)

docker-push-base: ## Pushes the docker base image to Dockerhub
	@$(DOCKER) push $(DOCKER_BASE_NAME)

docker-build: ## Builds the docker image
	@$(DOCKER) build -f $(DOCKER_WEB_APP_FILE) --build-arg $(DOCKER_WEB_APP_ARGS) -t $(DOCKER_WEB_APP_NAME) -t $(DOCKER_WEB_APP_LATEST) -t $(DOCKER_WEB_APP_IMAGE) .

docker-push: ## Pushes the docker image to Dockerhub
	@$(DOCKER) push $(DOCKER_WEB_APP_NAME)

clean: $(CUSTOM_ENV_FILES) ## Stop containers, remove old images and prune docker unused resources
	@$(DOCKER_COMPOSE) down --rmi local --remove-orphans
	@$(DOCKER) system prune -f

wipe-unnamed-volumes: ## Deletes all volumes on machine, except
	@$(DOCKER) volume rm `docker volume ls -q -f dangling=true | sed '/web-app/d'`

wipe-data: ## Deletes volumes with data like database, s3, elasticsearch (don't erase npm and bundler volumes)
	@$(DOCKER) volume rm web-app_database_data;          exit 0;
	@$(DOCKER) volume rm web-app_database_napoleon_data; exit 0;
	@$(DOCKER) volume rm web-app_s3_data;                exit 0;
	@$(DOCKER) volume rm web-app_search_data;            exit 0;

wipe: $(CUSTOM_ENV_FILES) ## Stop containers, clean volumes, remove old images and prune docker unused resources
	@$(DOCKER_COMPOSE) down -v --rmi local --remove-orphans
	@$(DOCKER) system prune -f

docker-%: $(CUSTOM_ENV_FILES) ## Executes `make SOMETHING` inside base service
	@$(call docker_run_or_plain,base.clspt,make -s $*)

volumes-show: ./images/volumes/ssh_host_ed25519_key ./images/volumes/ssh_host_rsa_key
	@make -s up-volumes
	@sleep 2
	sshfs squerol@127.0.0.1:volumes -p 2222 `pwd`/volumes -ovolname=volumes

volumes-hide:
	@make -s down-volumes
	umount `pwd`/volumes

watch: watch-dev ## Alias for watch-dev

watch-dev: $(CUSTOM_ENV_FILES) ## Shows continually status of dev containers
	@watch -n 5 $(DOCKER_COMPOSE) ps

watch-%: ## Shows continually status of containers or dynos for a given env
	@watch -n 5 heroku ps --app $(HEROKU_WEB_APP_NAME)-$*

logs: logs-dev ## Alias for logs-dev

logs-dev: $(CUSTOM_ENV_FILES) ## Show live logs of dev containers
	@$(DOCKER_COMPOSE) logs -f

logs-prd: ## Show live logs of production dynos
	@heroku logs -t --app $(HEROKU_WEB_APP_NAME)-prd

logs-stg: ## Show live logs of staging dynos
	@heroku logs -t --app $(HEROKU_WEB_APP_NAME)-stg

logs-%: $(CUSTOM_ENV_FILES) ## Show live logs of a given dev containers
	@$(DOCKER_COMPOSE) logs -f $*.clspt

wait-for-elastic-search:
	@$(call docker_run_or_plain,base.clspt,./bin/wait_for_elastic_search)

$(PG_DUMP_FILE):
	@make -s db-download-prd

./services.svg: services.gv ## Use graphviz to build services architecture graph
	@dot -Tsvg $< -o $@

./envs/local/napoleon.env:
	@mkdir -p envs/local
	./bin/fetch_local_napoleon_env $@

./envs/local/base.env:
	@mkdir -p envs/local
	./bin/fetch_local_base_env $(HEROKU_WEB_APP_NAME)-prd $@

./envs/local/user.env:
	@mkdir -p envs/local
	./bin/fetch_local_user_env $(HEROKU_USER_DASH_NAME)-prd $@

./envs/local/developer.env:
	@mkdir -p envs/local
	./bin/fetch_local_developer_env $(HEROKU_DEV_DASH_NAME)-prd $@

./envs/local/video.env:
	@mkdir -p envs/local
	./bin/fetch_local_video_env $(HEROKU_VIDEO_NAME)-prd $@

./envs/local/%:
	@mkdir -p envs/local
	@touch envs/local/$*
	@echo "Created empty local env file: $*"

./envs/%/database.env: LESS_PRIORITY-%
	@mkdir -p envs/$*
	./bin/fetch_database_env $(HEROKU_WEB_APP_NAME)-$* $(HEROKU_POSTGREST_NAME)-$* $@

./ssr/hypernova.js: package-lock.json ./app/assets ./config/locales
	@make -s build-ssr

./db/seeds:
	@make -s db-build-seeds

./images/database/production_seed.sql: ./db/seeds

./images/volumes/ssh_host_ed25519_key:
	ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null
	rm ssh_host_ed25519_key.pub
	mv ssh_host_ed25519_key $@

./images/volumes/ssh_host_rsa_key:
	ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null
	rm ssh_host_rsa_key.pub
	mv ssh_host_rsa_key $@

../user-dashboard:
	cd .. && git clone git@github.com:classpert/user-dashboard.git && cd user-dashboard && git submodule init && git submodule update

../developers-dashboard:
	cd .. && git clone git@github.com:classpert/developers-dashboard.git && cd developers-dashboard && git submodule init && git submodule update

../napoleon:
	cd .. && git clone git@github.com:classpert/napoleon.git

%: | examples/%.example
	cp $| $@

LESS_PRIORITY-%:
	@:

.PHONY: help configure setup setup-user setup-developer etc_hosts worker napoleon-worker tty bash bash-ports bash-ports-% bash-% sh-ports-% sh-% rails app que hypernova webpacker console console-dev build-ssr console-% npm-install npm-ci bundle-install rails-migrate course-reindex sync sync-% db-prepare db-build-seeds db-build-seeds-% db-migrate db-migrate-% db-load db-load-dev db-load-% db-reset db-reset-% db-wipe wipe-db db-restart db-download db-download-% detached-prd-% detached-stg-% attached-prd-% attached-stg-% run-all run-user run-developer run-% up-all up-user up-developer up-persistence up-% restart-% down-% docker-build-base docker-push-base docker-build docker-push clean wipe-unnamed-volumes wipe-data wipe docker-% volumes-show volumes-hide watch watch-dev watch-% logs logs-dev logs-prd logs-stg logs-% wait-for-elastic-search LESS_PRIORITY-%
