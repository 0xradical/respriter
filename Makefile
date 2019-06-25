NAME   :=	classpert/rails
TAG    :=	2.2.0
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

.PHONY: help update-packages rebuild-and-update-packages bootstrap console tests rspec cucumber guard yarn yarn-link-% yarn-unlink-% db_migrate db_up db_reset db_capture db_download db_load db_restore index_courses hrk_stg_db_restore tty down docker-build docker-push docker-% watch

help:
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

update-packages: Gemfile Gemfile.lock package.json yarn.lock ## Updates packages from Gemfile.lock and yarn.lock
	yarn install --modules-folder=/home/developer/.config/yarn/global/node_modules
	bundle install

rebuild-and-update-packages: ## Install new packages and rebuild image
	make docker-update-packages
	make docker-build

bootstrap: Dockerfile docker-compose.yml .env .env.test
	@docker-compose run --service-ports -e DETECTED_OS=$(DETECTED_OS) app_$(ENV) bin/bootstrap

lazy: bootstrap db_restore ## Build your application from scratch and restores the latest dump
	@$(RAKE) db:migrate system:elasticsearch:import_courses
	@docker-compose run -p 3000:3000 app_$(ENV)

rails: ## Run rails server
	@docker-compose run -p 3000:3000 app_$(ENV)

console: ## Run rails console. Usage e.g: ENV="test" make console
	@$(BUNDLE_EXEC) rails console

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

db_up: ## Run the database server
	@docker-compose run --service-ports postgres

db_drop: ## Drops local databases
	@$(RAKE) db:drop

db_create: ## Creates local databases
	@$(RAKE) db:create

db_migrate: ## Run database migration
	@$(RAKE) db:migrate

db_reset: ## Reset your database
	@$(RAKE) db:{drop,create,migrate}

db_capture: ## Capture a new production dump from Heroku
	@heroku pg:backups:capture --app $(HEROKU_APP_NAME)-prd

db_download: ## Dowloads latest production dump from Heroku
	@heroku pg:backups:download --app $(HEROKU_APP_NAME)-prd --output $(PG_DUMP_FILE)

db_load: ## Loads lastest dump creating database
	@$(DOCKER_COMPOSE_RUN) pg_restore --verbose --clean --no-acl --no-owner -h $(PG_HOST) -U $(PG_USER) -d quero_$(ENV) < $(PG_DUMP_FILE); exit 0;

db_restore: ## Restores lastest dump creating database (if needed), migrates after restore and load elastic_search
	@make db_create db_load db_migrate index_courses

index_courses:
	@$(BUNDLE_EXEC) rails runner "Course.reindex!"

hrk_stg_db_restore: ## Dumps latest production dump from production and restores in staging
	@heroku pg:backups:restore `heroku pg:backups:url --app=$(HEROKU_APP_NAME)-prd` DATABASE_URL --app=$(HEROKU_APP_NAME)-stg

tty: ## Attach a tty to the app container. Usage e.g: ENV=test make tty
	@docker-compose run --entrypoint /bin/bash app_$(ENV)

down: ## Run docker-compose down
	@docker-compose down

clean: ## Stop containers, remove old images and prune docker unused resources
	@docker-compose down -v --rmi local --remove-orphans
	@docker system prune -f

docker-build: Dockerfile ## Builds the docker image
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

docker-push: ## Pushes the docker image to Dockerhub
	@docker push ${NAME}

docker-compose.yml: ### Copies docker-compose.yml from examples
	cp examples/docker-compose.yml.example docker-compose.yml

Dockerfile: Dockerfile.$(DETECTED_OS)
	mv $< $@

docker-%: ## When running `make docker-SOMETHING` it executes `make SOMETHING` inside docker context
	@docker-compose run --service-ports app_$(ENV) make -s $*

system.svg: system.gv ## Use graphviz to build system architecture graph
	@dot -Tsvg $< -o $@

watch:
	watch -n 3 docker-compose ps

%: | examples/%.example
	cp $| $@
