NAME   :=	codextremist/rails
TAG    :=	2.0.0
IMG    :=	${NAME}\:${TAG}
LATEST :=	${NAME}\:latest

ENV = development

.PHONY: help bootstrap console tests cucumber guard db tty down docker-build docker-push cucumber

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bootstrap: docker-compose.yml .env .env.test ## Build your application from scratch
	@docker-compose run --service-ports app_$(ENV) bin/bootstrap

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

db: ## Run the database server
	@docker-compose run --service-ports postgres

tty: ## Attach a tty to the app container. Usage e.g: ENV=test make tty
	@docker-compose run --service-ports --entrypoint /bin/bash app_$(ENV)

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
