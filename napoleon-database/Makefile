ifeq ("$(shell pwd)","/database")
  REQUIRES_NETWORK := LESS_PRIORITY-noop
else
  REQUIRES_NETWORK := check-network

  MONOREPO_PATH := ..
  include ../tasks/images.Makefile
endif

RUBY_PATH := $(shell which ruby)

RUBY_IMAGE      := ruby:2.6.3-alpine
DOCKER_ENV_FILE := --env-file ../envs/dev/database-napoleon.env
DOCKER_RUBY_RUN := docker run --rm -it -v $(shell pwd):/database -w /database $(DOCKER_ENV_FILE) $(RUBY_IMAGE)

define docker_ruby_run_or_plain
	if [ -n "$(RUBY_PATH)" ]; then $(DOCKER_RUBY_RUN) $1; else $1; fi;
endef

DOCKER_DB_VOLUMES := -v $(shell pwd):/database
DOCKER_DB_RUN     := docker run --rm -it --network classpert $(DOCKER_DB_VOLUMES)

define docker_run_by_env
	$(DOCKER_DB_RUN) --env-file ../envs/$1/database-napoleon.env $(NAPOLEON_DATABASE_IMAGE) $2
endef

.DEFAULT_GOAL := help

help: ## Get help
	@grep -hE '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

structure-update: ## Updates db/structure.lock
	@$(call docker_ruby_run_or_plain,/database/bin/structure_update)

structure-check: ## Checks if db/structure.lock is consistent
	@$(call docker_ruby_run_or_plain,/database/bin/structure_check)

structure-migrate-%: ## Creates a migration and updates db/structure.lock
	@$(call docker_ruby_run_or_plain,/database/bin/structure_update migrate $*)

download-%: $(REQUIRES_NETWORK) ../envs/%/database-napoleon.env ## Downloads data from a given env
	@$(call docker_run_by_env,$*,./bin/download $* ./db/dumps/$*)

download: download-prd ## Alias to download-prd

reset-%: $(REQUIRES_NETWORK) ../envs/%/database-napoleon.env ## Resets database from a given env
	@$(call docker_run_by_env,$*,./bin/reset $*)

reset: reset-dev ## Alias to reset-dev

load-%: $(REQUIRES_NETWORK) ## Loads data from a given env from a dump of another env as load-TARGET-SOURCE
	@make -s ../envs/`echo $* | cut -d- -f1`/database-napoleon.env
	@$(call docker_run_by_env,`echo $* | cut -d- -f1`,./bin/load `echo $* | cut -d- -f1` ./db/dumps/`echo $* | cut -d- -f2`)

load: load-dev-prd ## Alias for load-dev-prd

migrate-%: $(REQUIRES_NETWORK) ../envs/%/database-napoleon.env ## Applies migrations for a given env
	@$(call docker_run_by_env,$*,./bin/migrate ./db/migrations)

migrate: migrate-dev ## Alias to migrate-dev

bash-%: $(REQUIRES_NETWORK) ../envs/%/database-napoleon.env ## Runs bash at a given env
	@$(call docker_run_by_env,$*,/bin/bash)

bash: bash-dev ## Alias to bash-dev

build: ## Builds docker image
	@docker build -t $(NAPOLEON_DATABASE_IMAGE) .

release: ## Pushes docker image
	@docker push $(NAPOLEON_DATABASE_IMAGE)

check-network:
	@cd .. && make -s check-network

LESS_PRIORITY-%:
	@:

../envs/%/database-napoleon.env:
	@cd .. && make -s ./envs/$*/database-napoleon.env

.PHONY: help structure-update structure-check structure-migrate-% download-% download reset-% reset load-% load migrate-% migrate bash-% bash build release check-network LESS_PRIORITY-%
