UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	SHA1SUM := gsha1sum
else
	# assume linux
	SHA1SUM := sha1sum
endif

DATABASE_IMAGE_NAME := classpert/napoleon_database
DATABASE_IMAGE_TAG  := $(shell cat ./db/structure.sql.env | $(SHA1SUM) | sed -e 's/ .*//g')
DATABASE_IMAGE      := $(DATABASE_IMAGE_NAME):$(DATABASE_IMAGE_TAG)

RUBY_PATH := $(shell which ruby)

RUBY_IMAGE      := ruby:2.6.3-alpine
DOCKER_ENV_FILE := --env-file ../../envs/dev/database-napoleon.env
DOCKER_RUBY_RUN := docker run --rm -it -v $(shell pwd):/database -w /database $(DOCKER_ENV_FILE) $(RUBY_IMAGE)

DOCKER_DB_VOLUMES := -v $(shell pwd):/database
DOCKER_DB_RUN     := docker run --rm -it --network web-app_default $(DOCKER_DB_VOLUMES)

define docker_ruby_run_or_plain
	if [ -n "$(RUBY_PATH)" ]; then $(DOCKER_RUBY_RUN) $1; else $1; fi;
endef

define docker_run_by_env
	$(DOCKER_DB_RUN) --env-file ../../envs/$1/database-napoleon.env $(DATABASE_IMAGE) $2
endef

default: help

help: ## Get help
	@grep -hE '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

structure-update: ## Updates db/structure.lock
	@$(call docker_ruby_run_or_plain,/database/bin/structure_update)

structure-check: ## Checks if db/structure.lock is consistent
	@$(call docker_ruby_run_or_plain,/database/bin/structure_check)

structure-migrate-%: ## Creates a migration and updates db/structure.lock
	@$(call docker_ruby_run_or_plain,/database/bin/structure_update migrate $*)

download-%: ## Downloads data from a given env
	@$(call docker_run_by_env,$*,./bin/download $* ./db/dumps/$*)

download: download-prd ## Alias to download-prd

reset-%: ## Resets database from a given env
	@$(call docker_run_by_env,$*,./bin/reset $*)

reset: reset-dev ## Alias to reset-dev

load-%: ## Loads data from a given env from a dump of another env as load-TARGET-SOURCE
	@$(call docker_run_by_env,`echo $* | cut -d- -f1`,./bin/load `echo $* | cut -d- -f1` ./db/dumps/`echo $* | cut -d- -f2`)

load: load-dev-prd ## Alias for load-dev-prd

migrate-%: ## Applies migrations for a given env
	@$(call docker_run_by_env,$*,./bin/migrate ./db/migrations)

migrate: migrate-dev ## Alias to migrate-dev

bash-%: ## Runs bash at a given env
	@$(call docker_run_by_env,$*,/bin/bash)

bash: bash-dev ## Alias to bash-dev

build: ## Builds docker image
	@docker build -t $(DATABASE_IMAGE) .

release: ## Pushes docker image
	@docker push $(DATABASE_IMAGE)

.PHONY: help structure-update structure-check structure-migrate-% download-% download reset-% reset load-% load migrate-% migrate bash-% bash build release
