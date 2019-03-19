NAME   :=	codextremist/rails
TAG    :=	2.0.0
IMG    :=	${NAME}\:${TAG}
LATEST :=	${NAME}\:latest

bootstrap:
	@cp docker-compose.yml.example docker-compose.yml
	@cp .env.example .env
	@cp .env.test.example .env.test
	@docker-compose run --service-ports app bin/bootstrap

rails:
	@docker-compose run --service-ports app

guard-%:
	@docker-compose run --service-ports app bundle exec guard $*

docker-build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

docker-push:
	@docker push ${NAME}

docker-login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}

.PHONY= bootstrap docker-login docker-push docker-build
