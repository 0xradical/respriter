DATABASE_IMAGE_NAME    := classpert/database
DATABASE_IMAGE_VERSION := 1.4.0

DATABASE_IMAGE_TAG     := $(DATABASE_IMAGE_NAME)\:$(DATABASE_IMAGE_VERSION)
DATABASE_IMAGE_LATEST  := $(DATABASE_IMAGE_NAME)\:latest

RUBY_PATH := $(shell which docker-compose)

DOCKER_ENV_FILE := --env-file ../envs/dev/database.env

RUBY_IMAGE      := ruby:2.6.3-alpine
DOCKER_RUBY_RUN := docker run --rm -it -v $(shell pwd):/database -w /database $(DOCKER_ENV_FILE) $(RUBY_IMAGE)

DOCKER_DB_VOLUMES := -v $(shell pwd)/bin/docker-setup.sh:/docker-entrypoint-initdb.d/setup.sh -v $(shell pwd)/db/structure.sql.env:/docker-entrypoint-initdb.d/structure.sql.env
DOCKER_DB_RUN     := docker run --rm -it -p 5432:5432 $(DOCKER_ENV_FILE) $(DOCKER_DB_VOLUMES) $(DATABASE_IMAGE_LATEST)

define docker_ruby_run_or_plain
	if [ -n "$(RUBY_PATH)" ]; then $(DOCKER_RUBY_RUN) $1; else $1; fi;
endef

default: structure-update

structure-update:
	@$(call docker_ruby_run_or_plain,/database/bin/structure_update)

structure-check:
	@$(call docker_ruby_run_or_plain,/database/bin/structure_check)

structure-migrate-%:
	@$(call docker_ruby_run_or_plain,/database/bin/structure_update migrate $*)

run:
	$(DOCKER_DB_RUN)

build:
	@docker build -t $(DATABASE_IMAGE_TAG) .
	@docker tag $(DATABASE_IMAGE_TAG) $(DATABASE_IMAGE_LATEST)

release:
	@docker push $(DATABASE_IMAGE_TAG)
	@docker push $(DATABASE_IMAGE_LATEST)

.PHONY: structure-update structure-check structure-migrate-% run build release
