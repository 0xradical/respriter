MONOREPO_PATH := .
MAKE_BIN      := ./bin
SERVICES      := $(shell /bin/sh -c "cat $(MONOREPO_PATH)/docker-compose.yml | grep -e '\.clspt:$$' | sed -e 's/  //g' | sed -e 's/\://g' | sed '/volumes/d' | sed '/base/d'")

include tasks/envs.Makefile
include tasks/images.Makefile
include tasks/docker.Makefile
include tasks/launcher.Makefile

VOLUME_PREFIX       := classpert_dev
GITHUB_ACCESS_TOKEN ?= $(shell heroku config:get GITHUB_ACCESS_TOKEN --app $(HEROKU_WEB_APP_NAME)-prd)
LOCAL_NODE_MODULES  ?= $(shell [ -f "$(MONOREPO_PATH)/.local_node_modules" ] && echo "./node_modules:" || echo "")

RUBY_PATH := $(shell which ruby)

RUBY_IMAGE      := ruby:2.6.3-alpine
DOCKER_RUBY_RUN := docker run --rm -it -v $(shell pwd):/repo -w /repo $(RUBY_IMAGE)

define docker_ruby_run_or_plain
	if [ -n "$(RUBY_PATH)" ]; then $(DOCKER_RUBY_RUN) $1; else $1; fi;
endef

DOCKER              := docker
DOCKER_COMPOSE_VARS := LOCAL_NODE_MODULES=$(LOCAL_NODE_MODULES) GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN) $(DOCKER_COMPOSE_IMAGES)
DOCKER_COMPOSE      := $(DOCKER_COMPOSE_VARS) docker-compose

.DEFAULT_GOAL := help

help: ## Get help
	@grep -hE '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

configure: $(LOCAL_ENV_FILES) $(DATABASE_ENVS) ## Generates gitignored env files

etc_hosts: $(LOCAL_ENV_FILES) ## Show domains that should be on /etc/hosts
	@$(call docker_ruby_run_or_plain,./bin/etc_hosts)

setup: setup-database setup-napoleon ## Sets all apps

setup-database: ./database/db/seeds/prd_seed.sql up-persistence app-course-reindex  ## Sets up Persistence Containers and indexes Search

setup-napoleon: up-database up-api-napoleon ## Sets up Napoleon (its dependencies are already installed!)
	@$(call docker_run_or_plain,base,bundle exec rails runner bin/setup_napoleon.rb)
	@echo -e "Napoleon is ready to crawl some providers! To do so, follow this:\n - Run make up-{persistence,provider,napoleon} or make sure those services are up\n - Wait for a while looking at logs to know when it finishes (checks running make logs)\n - Run make app-sync"

db-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Run database make tasks
	@cd database && make -s $*

napoleon_db-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Run napoleon database make tasks
	@cd napoleon-database && make -s $*

app-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Alias to web-app-%
	@make -s web-app-$*

web-app-%: $(LOCAL_ENV_FILES) LESS_PRIORITY-% ## Runs web-app make tasks
	@cd web-app && make -s $*

reload-app: wipe-db up-persistence app-course-reindex ## Cleans database, reload it and indexes search

wipe-db: $(LOCAL_ENV_FILES) ## Kill database container and volumes
	$(DOCKER_COMPOSE) stop database.clspt
	$(DOCKER_COMPOSE) rm -f database.clspt
	$(DOCKER) volume rm $(VOLUME_PREFIX)_database_data; exit 0

wipe-unnamed-volumes: ## (Very destructive) Removes all dangling volumes, except web-app's
	@$(DOCKER) volume rm `docker volume ls -q -f dangling=true | sed '/classpert/d'`

wipe-data: ## Deletes volumes with data like database, s3, elasticsearch (don't erase npm and bundler volumes)
	@cd .. && make -s 
	@$(DOCKER) volume rm $(VOLUME_PREFIX)_database_data;          exit 0;
	@$(DOCKER) volume rm $(VOLUME_PREFIX)_database_napoleon_data; exit 0;
	@$(DOCKER) volume rm $(VOLUME_PREFIX)_s3_data;                exit 0;
	@$(DOCKER) volume rm $(VOLUME_PREFIX)_search_data;            exit 0;

volumes-show: ./images/volumes/ssh_host_ed25519_key ./images/volumes/ssh_host_rsa_key ## Share mounted volumes
	@mkdir -p volumes
	@make -s up-volumes
	@sleep 2
	@sshfs squerol@127.0.0.1:volumes -p 2222 `pwd`/volumes -ovolname=volumes

volumes-hide: ## Close sharing of mounted volumes
	@make -s down-volumes
	@umount `pwd`/volumes

./database/db/seeds/prd_seed.sql:
	@make -s db-build-seeds

./images/volumes/ssh_host_ed25519_key:
	ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null
	rm ssh_host_ed25519_key.pub
	mv ssh_host_ed25519_key $@

./images/volumes/ssh_host_rsa_key:
	ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null
	rm ssh_host_rsa_key.pub
	mv ssh_host_rsa_key $@

./services.svg: services.gv ## Use graphviz to build services architecture graph
	@dot -Tsvg $< -o $@

LESS_PRIORITY-%:
	@:

.PHONY: help configure etc_hosts setup setup-database setup-napoleon db-% napoleon_db-% app-% web-app-% reload-app wipe-db wipe-unnamed-volumes wipe-data volumes-show volumes-hide
