NAME   :=	classpert/rails
TAG    :=	2.0.1
IMG    :=	${NAME}\:${TAG}
LATEST :=	${NAME}\:latest
HEROKU_APP_NAME := classpert-web-app

ENV ?= development

.PHONY: help bootstrap console tests cucumber guard yarn yarn-link-% yarn-unlink-% db_up db_reset db_restore hrk_stg_db_restore tty down docker-build docker-push cucumber

help:
	@grep -E '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bootstrap: docker-compose.yml .env .env.test
	@docker-compose run --service-ports app_$(ENV) bin/bootstrap

lazy: bootstrap db_restore ## Build your application from scratch and restores the latest dump
	@docker-compose run app_$(ENV) bundle exec rake db:migrate
	@docker-compose run app_$(ENV) bundle exec rake system:elasticsearch:import_courses
	@docker-compose run -p 3000:3000 app_$(ENV)

rails: ## Run rails server
	@docker-compose run -p 3000:3000 app_$(ENV)

console: ## Run rails console. Usage e.g: ENV="test" make console
	@docker-compose run --service-ports app_$(ENV) bundle exec rails c

tests: ## Run the complete test suite
	@docker-compose run -e BROWSER_LANGUAGE=en --service-ports app_test bundle exec cucumber
	@docker-compose run -e BROWSER_LANGUAGE=pt-BR --service-ports app_test bundle exec cucumber

cucumber: ## Run cucumber tests. Usage e.g: ARGS="--tags @user-signs-up" make cucumber
	@docker-compose run --service-ports app_test bundle exec cucumber $(ARGS)

guard: ## Run cucumber tests. Usage e.g: ARGS="" make guard
	@docker-compose run --service-ports app_test bundle exec guard $(ARGS)

yarn: ## Run yarn. Usage e.g: ARGS="add normalize" make yarn
	@docker-compose run app_development yarn $(ARGS)

yarn-link-%: ## Link yarn to your local package copy. Usage e.g: yarn-link-elements
	@docker-compose run app_development yarn link $*

yarn-unlink-%: ## Unlink yarn from your local package copy. Usage e.g: yarn-unlink-elements
	@docker-compose run app_development yarn unlink $*

db_up: ## Run the database server
	@docker-compose run --service-ports postgres

db_reset: ## Reset your database
	@docker-compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 app_$(ENV) bundle exec rake db:drop db:create db:migrate

db_restore: ## Downloads latest production dump from Heroku and restores locally
	@heroku pg:backups:download --app=$(HEROKU_APP_NAME)-prd --output=./db/backups/latest.dump
	@pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d quero_development ./db/backups/latest.dump
	@docker-compose run --service-ports app_$(ENV) bundle exec rake db:migrate
	@rm ./db/backups/latest.dump

hrk_stg_db_restore: ## Dumps latest production dump from production and restores in staging
	@heroku pg:backups:restore `heroku pg:backups:url --app=$(HEROKU_APP_NAME)-prd` DATABASE_URL --app=$(HEROKU_APP_NAME)-stg

tty: ## Attach a tty to the app container. Usage e.g: ENV=test make tty
	@docker-compose run --entrypoint /bin/bash app_$(ENV)

down: ## Run docker-compose down
	@docker-compose down

docker-build: Dockerfile ## Builds the docker image
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

docker-push: ## Pushes the docker image to Dockerhub
	@docker push ${NAME}

system.svg: system.gv ## Use graphviz to build system architecture graph
	@dot -Tsvg $< -o $@

%: | examples/%.example
	cp $| $@