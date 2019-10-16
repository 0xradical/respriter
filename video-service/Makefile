include .env
export

MAKE := make -s

WATCH_TIME := 3 # seconds

APP_NAME := app

IMAGE_NAME    := classpert/video-service
IMAGE_VERSION := 1.0

DEP_FILES     := Gopkg.lock Gopkg.toml
SRC_FILES     := $(shell find . -type f -name '*.go')
PROJECT_FILES := $(SRC_FILES) $(DEP_FILES)

WORKDIR := /go/src/app

DOCKER_COMPOSE                := docker-compose
DOCKER_COMPOSE_RUN_FLAGS      := --rm -v $(shell pwd):$(WORKDIR)
DOCKER_COMPOSE_RUN            := $(DOCKER_COMPOSE) run $(DOCKER_COMPOSE_RUN_FLAGS) $(APP_NAME)
DOCKER_COMPOSE_RUN_WITH_PORTS := $(DOCKER_COMPOSE) run $(DOCKER_COMPOSE_RUN_FLAGS) -p $(APP_PORT):$(APP_PORT) $(APP_NAME)

GO_COMPILE_ENV := CGO_ENABLED=0 GOOS=linux
# CGO_ENABLED=1
#   Enables compile support for linking C code.
#   Disabling it makes everything more compact.

define run_sql_file
	PGPASSWORD=$(POSTGRES_PASSWORD) psql -h $(POSTGRES_HOST) -p $(POSTGRES_PORT) -U $(POSTGRES_USER) -d $(POSTGRES_DB) -f $1
endef

define run_sql
	PGPASSWORD=$(POSTGRES_PASSWORD) psql -h $(POSTGRES_HOST) -p $(POSTGRES_PORT) -U $(POSTGRES_USER) -d $(POSTGRES_DB) -c $1
endef

default: run

config: db/structure.sql
	make docker-ensure

docker-build:
	@docker build -f Dockerfile         -t $(IMAGE_NAME):latest  .
	@docker build -f Dockerfile.minimal -t $(IMAGE_NAME):minimal .
	@docker tag $(IMAGE_NAME):latest  $(IMAGE_NAME):$(IMAGE_VERSION)
	@docker tag $(IMAGE_NAME):minimal $(IMAGE_NAME):$(IMAGE_VERSION)-minimal

docker-rebuild:
	$(DOCKER_COMPOSE) build --no-cache

docker-debug:
	$(DOCKER_COMPOSE) up -d nginx
	$(MAKE) docker-binded-shell

docker-binded-%:
	$(DOCKER_COMPOSE_RUN_WITH_PORTS) $(MAKE) $*

docker-%:
	$(DOCKER_COMPOSE_RUN) $(MAKE) $*

compile:
	@echo "Compiling app..."
	$(GO_COMPILE_ENV) go build -a .
	@echo "Compiled app!"

install:
	$(GO_COMPILE_ENV) go install

update:
	dep ensure -update

ensure:
	dep ensure

run:
	go run main.go

up:
	@$(DOCKER_COMPOSE) up app

up-%:
	@$(DOCKER_COMPOSE) up -d $*

down:
	@$(DOCKER_COMPOSE) down --remove-orphans

down-%:
	@$(DOCKER_COMPOSE) stop $*
	@$(DOCKER_COMPOSE) rm -fv $*

reset-%:
	$(MAKE) down-$*
	$(MAKE) up-$*

release:
	@docker push $(IMAGE_NAME):latest
	@docker push $(IMAGE_NAME):$(IMAGE_VERSION)
	@docker push $(IMAGE_NAME):minimal
	@docker push $(IMAGE_NAME):$(IMAGE_VERSION)-minimal

execute: app
	./app

shell:
	@/bin/bash

logs:
	@$(DOCKER_COMPOSE) logs -f

watch:
	@watch -n 3 $(DOCKER_COMPOSE) ps

clean:
	rm -f app
	$(DOCKER_COMPOSE) down -v --rmi local --remove-orphans
	@docker system prune -f

clean-all:
	rm -f app
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
	@docker system prune -f

db/structure.sql: ../database/db/structure.sql
	cp ../database/db/structure.sql db/structure.sql

app: $(PROJECT_FILES)
	$(MAKE) compile

.PHONY: config docker-build docker-rebuild docker-debug docker-binded-% docker-% compile install update ensure run up up-% down down-% reset-% release execute shell logs watch clean clean-all
