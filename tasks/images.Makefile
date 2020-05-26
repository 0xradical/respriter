UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	SHA1SUM := gsha1sum
else
	# assume linux
	SHA1SUM := sha1sum
endif

DOCKER_BASE_NAME             := classpert/rails
DOCKER_BASE_TAG              := 4.0.0
DOCKER_BASE_FILE             := web-app/Dockerfile.base
DOCKER_BASE_IMAGE            := $(DOCKER_BASE_NAME):$(DOCKER_BASE_TAG)

DOCKER_WEB_APP_NAME          := classpert/web-app
DOCKER_WEB_APP_TAG           := $(shell cat $(MONOREPO_PATH)/web-app/Gemfile.lock $(MONOREPO_PATH)/web-app/package-lock.json | $(SHA1SUM) | sed -e 's/ .*//g')
DOCKER_WEB_APP_IMAGE         := $(DOCKER_WEB_APP_NAME):$(DOCKER_WEB_APP_TAG)

DATABASE_IMAGE_NAME          := classpert/database
DATABASE_IMAGE_TAG           := $(shell cat $(MONOREPO_PATH)/database/db/structure.sql.env | $(SHA1SUM) | sed -e 's/ .*//g')
DATABASE_IMAGE               := $(DATABASE_IMAGE_NAME):$(DATABASE_IMAGE_TAG)

USER_IMAGE_NAME              := classpert/user-dashboard
USER_IMAGE_TAG               := $(shell cat $(MONOREPO_PATH)/user-dashboard/package-lock.json | $(SHA1SUM) | sed -e 's/ .*//g')
USER_IMAGE                   := $(USER_IMAGE_NAME):$(USER_IMAGE_TAG)

DEVELOPER_IMAGE_NAME         := classpert/developers-dashboard
DEVELOPER_IMAGE_TAG          := $(shell cat $(MONOREPO_PATH)/developers-dashboard/package-lock.json | $(SHA1SUM) | sed -e 's/ .*//g')
DEVELOPER_IMAGE              := $(DEVELOPER_IMAGE_NAME):$(DEVELOPER_IMAGE_TAG)

NAPOLEON_APP_IMAGE_NAME      := classpert/napoleon
NAPOLEON_APP_IMAGE_TAG       := $(shell cat $(MONOREPO_PATH)/napoleon/Gemfile.lock | $(SHA1SUM) | sed -e 's/ .*//g')
NAPOLEON_APP_IMAGE           := $(NAPOLEON_APP_IMAGE_NAME):$(NAPOLEON_APP_IMAGE_TAG)

NAPOLEON_DATABASE_IMAGE_NAME := classpert/napoleon_database
NAPOLEON_DATABASE_IMAGE_TAG  := $(shell cat $(MONOREPO_PATH)/napoleon/database/db/structure.sql.env | $(SHA1SUM) | sed -e 's/ .*//g')
NAPOLEON_DATABASE_IMAGE      := $(NAPOLEON_DATABASE_IMAGE_NAME):$(NAPOLEON_DATABASE_IMAGE_TAG)

DOCKER_COMPOSE_IMAGES := NAPOLEON_APP_IMAGE=$(NAPOLEON_APP_IMAGE) NAPOLEON_DATABASE_IMAGE=$(NAPOLEON_DATABASE_IMAGE) WEB_APP_IMAGE=$(DOCKER_WEB_APP_IMAGE) DEVELOPER_IMAGE=$(DEVELOPER_IMAGE) USER_IMAGE=$(USER_IMAGE) DATABASE_IMAGE=$(DATABASE_IMAGE)
