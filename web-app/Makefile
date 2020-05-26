ifeq ("$(shell pwd)","/app")
  include ./tasks/docker_mocked.Makefile
else
  MONOREPO_PATH := ..
  MAKE_BIN      := ../bin

  include ../tasks/images.Makefile
  include ../tasks/docker.Makefile
  include ../tasks/launcher.Makefile

  GITHUB_ACCESS_TOKEN ?= $(shell heroku config:get GITHUB_ACCESS_TOKEN --app $(HEROKU_WEB_APP_NAME)-prd)
  LOCAL_NODE_MODULES  ?= $(shell [ -f "$(MONOREPO_PATH)/.local_node_modules" ] && echo "./node_modules:" || echo "")

  DOCKER         := docker
  DOCKER_COMPOSE := LOCAL_NODE_MODULES=$(LOCAL_NODE_MODULES) GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN) $(DOCKER_COMPOSE_IMAGES) docker-compose -f ../docker-compose.yml
endif

help: ## Get help
	@grep -hE '^[%a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

rails-server: ## Runs Rails server
	@$(call docker_run_with_ports_or_plain,app,bundle exec rails s -b 0.0.0.0)

console: console-dev ## Alias for console-dev

console-dev: ## Run rails console for development
	@$(call docker_run_or_plain,app,bundle exec rails console)

npm-install: ## Run npm install
	@$(call docker_run_or_plain,base,npm install)

npm-ci: ## Run npm ci
	@$(call docker_run_or_plain,base,npm ci)

bundle-install: ## Run bundle install
	@$(call docker_run_or_plain,base,bundle install)

rails-migrate: ## Run rake db:migrate (probably not necessary and not advised)
	@$(call docker_run_or_plain,base,bundle exec rake db:migrate)

course-reindex: wait-for-elastic-search ## Reindexes Courses on Elasticsearch
	@$(call docker_run_or_plain,base,bundle exec rails runner "Course.reindex!")

course-reindex-dev: ## Reindex courses for dev
	@make -s course-reindex

course-reindex-%: LESS_PRIORITY-% ## Reindex courses for a given env
	@make -s detached-$*-course-reindex

sync: sync-crawling_events wait-for-elastic-search sync-courses ## Sync web-app with napoleon

sync-%: ## Sync web-app with napoleon given resources (courses or crawling_events)
	@$(call docker_run_or_plain,base,bundle exec rake system:scheduler:$*_service,-T)

hypernova: ./ssr/hypernova.js ## Compiles (if needed) and runs hypernova server side rendering server
	node ssr/hypernova.js

wait-for-elastic-search:
	@$(call docker_run_or_plain,base,./bin/wait_for_elastic_search)

./ssr/hypernova.js: package-lock.json ./app/assets ./config/locales
	npm run ssr

LESS_PRIORITY-%:
	@:

.PHONY: help rails-server console console-dev hypernova LESS_PRIORITY-%
