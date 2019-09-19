APP := migrator

NAME := classpert/database

DATABASE_IMAGE_TAG     := 1.2.1
DATABASE_IMAGE_NAME    := $(NAME)\:$(DATABASE_IMAGE_TAG)
DATABASE_IMAGE_VERSION := $(NAME)\:latest

WORKDIR := /code

MAKE := make -s

CURRENT_STRUCTURE          := db/structure.sql
CURRENT_STRUCTURE_TEMPLATE := $(CURRENT_STRUCTURE).env
DOCKER_STRUCTURE           := docker/structure.sql.env

DOCKER_COMPOSE           := docker-compose
DOCKER_COMPOSE_RUN_FLAGS := run --rm -v $(shell pwd):$(WORKDIR)
DOCKER_COMPOSE_RUN       := $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_RUN_FLAGS) $(APP)

DOCKER_COMPOSE_PATH := $(shell which docker-compose)
ifeq ($(DOCKER_COMPOSE_PATH),)
  BUNDLE_EXEC := bundle exec
else
  BUNDLE_EXEC := $(DOCKER_COMPOSE_RUN) bundle exec
endif

SOURCE_FILES := src/schemas.sql src/extensions.sql src/types/**/*.sql src/tables/**/*.sql src/procedures/**/*.sql src/triggers/**/*.sql src/indexes/**/*.sql src/views/**/*.sql src/auth/*.sql src/data/**/*.sql

default: run

reset-db: docker-down-postgres docker-compose-postgres

reload-api: docker-down-postgrest docker-compose-postgrest

structure: $(CURRENT_STRUCTURE)

migrate-data:
	@PGPASSWORD=$(POSTGRES_PASSWORD) psql -U $(POSTGRES_USER) -h $(POSTGRES_HOST) -p $(POSTGRES_PORT) -d $(POSTGRES_DB) < debug/data.sql

migrate: $(CURRENT_STRUCTURE)
	@PGPASSWORD=$(POSTGRES_PASSWORD) psql -U $(POSTGRES_USER) -h $(POSTGRES_HOST) -p $(POSTGRES_PORT) -d $(POSTGRES_DB) < $(CURRENT_STRUCTURE)

docker-build:
	$(DOCKER_COMPOSE) build

docker-down-%:
	$(DOCKER_COMPOSE) stop $*
	$(DOCKER_COMPOSE) rm -fv $*

docker-compose-%:
	$(DOCKER_COMPOSE) up $*

docker-%:
	$(DOCKER_COMPOSE_RUN) $(MAKE) $*

run: $(CURRENT_STRUCTURE)
	@$(DOCKER_COMPOSE) up postgrest

build: $(CURRENT_STRUCTURE_TEMPLATE)
	@docker build -f Dockerfile.database -t $(DATABASE_IMAGE_NAME) .
	@docker tag $(DATABASE_IMAGE_NAME) $(DATABASE_IMAGE_VERSION)

release:
	@docker push $(DATABASE_IMAGE_NAME)
	@docker push $(DATABASE_IMAGE_VERSION)

shell:
	/bin/bash

console:
	bundle exec pry

up:
	@$(DOCKER_COMPOSE) up -d

down:
	@$(DOCKER_COMPOSE) down --remove-orphans

logs:
	@$(DOCKER_COMPOSE) logs -f

watch:
	@watch -n 3 $(DOCKER_COMPOSE) ps

clean:
	$(DOCKER_COMPOSE) down -v --rmi local --remove-orphans
	docker system prune -f

wipe:
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
	docker system prune -f

.env: examples/env.development
	@cp examples/env.development .env
	@echo 'Copied $@'

$(DOCKER_STRUCTURE): $(CURRENT_STRUCTURE_TEMPLATE)
	@cp $(CURRENT_STRUCTURE_TEMPLATE) $(DOCKER_STRUCTURE)
	@echo 'Copied $@'

$(CURRENT_STRUCTURE): $(CURRENT_STRUCTURE_TEMPLATE) .env
	cat $(CURRENT_STRUCTURE_TEMPLATE) | envsubst > $(CURRENT_STRUCTURE)
	@echo 'Built $@'

$(CURRENT_STRUCTURE_TEMPLATE): $(SOURCE_FILES)
	@echo "BEGIN;" > $@
	@awk 'FNR==1{print ""}1' $(SOURCE_FILES) >> $@
	@echo "COMMIT;" >> $@
	@echo 'Updated $@'

.PHONY: reset-db reload-api structure migrate-data migrate docker-build docker-down-% docker-compose-% docker-run-% docker-% run build release shell console up down logs watch clean wipe
