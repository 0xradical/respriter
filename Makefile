NAME   :=	classpert/rails
TAG    :=	3.0.2
IMG    :=	${NAME}\:${TAG}
LATEST :=	${NAME}\:latest
HEROKU_APP_NAME := classpert-web-app
ENV    ?= development

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	DETECTED_OS := mac
else
	# assume linux
	DETECTED_OS := linux
endif

PG_HOST      ?= postgres
PG_USER      ?= postgres
PG_PORT      ?= 5432
PG_ROLE_FILE ?= ./db/backups/roles.dump
PG_DUMP_FILE ?= ./db/backups/latest.dump

DOCKER_COMPOSE_PATH := $(shell which docker-compose)
ifeq ($(DOCKER_COMPOSE_PATH),)
  BUNDLE_EXEC        := bundle exec
  BUNDLE_EXEC_TEST   := ENV=test bundle exec
  DOCKER_COMPOSE_RUN := 
else
  BUNDLE_EXEC        := docker-compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 app_$(ENV) bundle exec
  BUNDLE_EXEC_TEST   := docker-compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 app_test bundle exec
  DOCKER_COMPOSE_RUN := docker-compose run app_$(ENV)
endif
RAKE := $(BUNDLE_EXEC) rake

DOCKER_COMPOSE_POSTGRES_RUN_FLAGS := --rm -v $(shell pwd)/db:/db -v $(shell pwd):/app
DOCKER_COMPOSE_POSTGRES_RUN       := docker-compose run $(DOCKER_COMPOSE_POSTGRES_RUN_FLAGS) postgres

.PHONY: help update-packages rebuild-and-update-packages bootstrap console que_worker tests rspec cucumber guard yarn yarn-link-% yarn-unlink-% rails_db_migrate db_reset db_reload postgrest_reset db_shell db_download db_migrate db_stg_migrate db_prd_migrate db_load db_restore index_courses sync_courses sync_crawling_events heroku_prd_% heroku_stg_% stg_db_restore tty down clean wipe docker-build docker-push docker-% watch logs prd-logs stg-logs

help:
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

update-packages: Gemfile Gemfile.lock package.json ## Updates packages from Gemfile.lock and yarn.lock
	yarn install --modules-folder=/home/developer/.config/yarn/global/node_modules
	bundle install

rebuild-and-update-packages: ## Install new packages and rebuild image
	make docker-update-packages
	make docker-build

bootstrap: Dockerfile docker-compose.yml .env .env.test
	@docker-compose run --service-ports -e DETECTED_OS=$(DETECTED_OS) app_$(ENV) bin/bootstrap

lazy: bootstrap db_restore ## Build your application from scratch and restores the latest dump
	@docker-compose run -p 3000:3000 app_$(ENV)

rails: ## Run rails server
	@docker-compose run -p 3000:3000 app_$(ENV)

postgrest:
	@docker-compose run --service-ports postgrest

console: ## Run rails console. Usage e.g: ENV="test" make console
	@$(BUNDLE_EXEC) rails console

que_worker:
	@$(BUNDLE_EXEC) que ./config/environment.rb

tests: ## Run the complete test suite
	@docker-compose run -e BROWSER_LANGUAGE=en --service-ports app_test bundle exec cucumber
	@docker-compose run -e BROWSER_LANGUAGE=pt-BR --service-ports app_test bundle exec cucumber
	@make rspec

rspec: ## Run rspec tests
	@$(BUNDLE_EXEC_TEST) rspec

cucumber: ## Run cucumber tests. Usage e.g: ARGS="--tags @user-signs-up" make cucumber
	@docker-compose run --service-ports app_test bundle exec cucumber $(ARGS)

guard: ## Run cucumber tests. Usage e.g: ARGS="" make guard
	@docker-compose run --service-ports app_test bundle exec guard $(ARGS)

yarn: ## Run yarn. Usage e.g: ARGS="add normalize" make yarn
	@$(DOCKER_COMPOSE_RUN) yarn $(ARGS)

yarn-link-%: ## Link yarn to your local package copy. Usage e.g: yarn-link-elements
	@$(DOCKER_COMPOSE_RUN) yarn link $*

yarn-unlink-%: ## Unlink yarn from your local package copy. Usage e.g: yarn-unlink-elements
	@$(DOCKER_COMPOSE_RUN) yarn unlink $*

rails_db_migrate: ## Run database migration
	@$(RAKE) db:migrate

db_reset: db/db.dev.env ## Reset your database
	$(DOCKER_COMPOSE_POSTGRES_RUN) /app/bin/db_reset /db/db.dev.env

db_reload: ## Reload your database
	docker-compose stop  postgres
	docker-compose rm -f postgres
	docker-compose stop  postgres_test
	docker-compose rm -f postgres_test
	docker-compose up -d postgres postgres_test

postgrest_reset:
	docker-compose stop  postgrest
	docker-compose rm -f postgrest
	docker-compose up -d postgrest

db_shell:
	@$(DOCKER_COMPOSE_POSTGRES_RUN) /bin/bash

db_download: db/db.prd.env ## Generates and downloads latest production dump from RDS
	$(DOCKER_COMPOSE_POSTGRES_RUN) /bin/sh -c '. /db/db.prd.env && PGPASSWORD=$$DATABASE_PASSWORD pg_dump -U $$DATABASE_USER -h $$DATABASE_HOST -p $$DATABASE_PORT -Fc $$DATABASE_DB > $(PG_DUMP_FILE)'

db_migrate: db/db.dev.env
	$(DOCKER_COMPOSE_POSTGRES_RUN) /app/bin/db_migrate /db/db.dev.env /app/database/db/migrations

db_stg_migrate: db/db.stg.env
	$(DOCKER_COMPOSE_POSTGRES_RUN) /app/bin/db_migrate /db/db.stg.env /app/database/db/migrations

db_prd_migrate: db/db.prd.env
	$(DOCKER_COMPOSE_POSTGRES_RUN) /app/bin/db_migrate /db/db.prd.env /app/database/db/migrations

db_load: $(PG_DUMP_FILE) ## Loads lastest dump creating database
	make db_reset
	@$(DOCKER_COMPOSE_POSTGRES_RUN) /bin/sh -c "( until pg_isready -h $(PG_HOST) -U $(PG_USER) -d classpert_$(ENV); do sleep 0.5; done; ) && ( pg_restore --verbose --no-owner -h $(PG_HOST) -U $(PG_USER) -d classpert_$(ENV) < $(PG_DUMP_FILE); exit 0; )"
	@$(DOCKER_COMPOSE_POSTGRES_RUN) /app/bin/db_fix_secrets /db/db.dev.env

db_restore: ## Restores lastest dump creating database (if needed), migrates after restore and load elastic_search
	@make db_load index_courses

index_courses:
	$(BUNDLE_EXEC) rails runner "Course.reindex!"

sync_courses:
	$(BUNDLE_EXEC) rake system:scheduler:courses_service

sync_crawling_events:
	$(BUNDLE_EXEC) rake system:scheduler:crawling_events_service

heroku_prd_%:
	heroku run:detached make $* --app=classpert-web-app-prd

heroku_stg_%:
	heroku run:detached make $* --app=classpert-web-app-stg

dev_db_restore: db/db.dev.env $(PG_DUMP_FILE)
	@$(DOCKER_COMPOSE_POSTGRES_RUN) /bin/sh -c '. /db/db.dev.env && PGPASSWORD=$$DATABASE_PASSWORD pg_restore --verbose --clean --no-acl --no-owner -U $$DATABASE_USER -h $$DATABASE_HOST -d $$DATABASE_DB < $(PG_DUMP_FILE); exit 0;'
	@$(DOCKER_COMPOSE_POSTGRES_RUN) /app/bin/db_fix_secrets /db/db.dev.env

stg_db_restore: db/db.stg.env $(PG_DUMP_FILE) ## Dumps latest production dump from production and restores in staging
	@$(DOCKER_COMPOSE_POSTGRES_RUN) /bin/sh -c '. /db/db.stg.env && PGPASSWORD=$$DATABASE_PASSWORD pg_restore --verbose --clean --no-acl --no-owner -U $$DATABASE_USER -h $$DATABASE_HOST -d $$DATABASE_DB < $(PG_DUMP_FILE); exit 0;'
	@$(DOCKER_COMPOSE_POSTGRES_RUN) /app/bin/db_fix_secrets /db/db.stg.env

tty: ## Attach a tty to the app container. Usage e.g: ENV=test make tty
	@docker-compose run --entrypoint /bin/bash app_$(ENV)

down: ## Run docker-compose down
	@docker-compose down

clean: ## Stop containers, remove old images and prune docker unused resources
	@docker-compose down --rmi local --remove-orphans
	@docker system prune -f

wipe: ## Stop containers, remove old images and prune docker unused resources
	@docker-compose down -v --rmi local --remove-orphans
	@docker system prune -f

docker-build: Dockerfile ## Builds the docker image
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

docker-push: ## Pushes the docker image to Dockerhub
	@docker push ${NAME}

docker-compose.yml: ### Copies docker-compose.yml from examples
	cp examples/docker-compose.yml.example docker-compose.yml

Dockerfile: examples/Dockerfile.$(DETECTED_OS).example
	cp $< $@

docker-%: ## When running `make docker-SOMETHING` it executes `make SOMETHING` inside docker context
	@docker-compose run --service-ports app_$(ENV) make -s $*

system.svg: system.gv ## Use graphviz to build system architecture graph
	@dot -Tsvg $< -o $@

watch:
	watch -n 3 docker-compose ps

logs: prd-logs

prd-logs:
	@heroku logs -t --app classpert-web-app-prd

stg-logs:
	@heroku logs -t --app classpert-web-app-stg

$(PG_DUMP_FILE):
	make db_download

%: | examples/%.example
	cp $| $@
