LOCAL_ENV_FILES = $(shell ls ./envs/dev/* | sed 's/\/dev\//\/local\//g' | xargs)
DATABASE_ENVS   = ./envs/stg/database.env ./envs/prd/database.env ./envs/stg/database-napoleon.env ./envs/prd/database-napoleon.env

configure: $(LOCAL_ENV_FILES) ## Builds envs files

./envs/local/%:
	@mkdir -p ./envs/local
	@$(MAKE_BIN)/create_default_local_env $* $@

./envs/%/database-napoleon.env: $(MAKE_BIN)/create_remote_napoleon_database_env LESS_PRIORITY-%
	@mkdir -p ./envs/$*
	@$(MAKE_BIN)/create_remote_napoleon_database_env $* $@

./envs/%/database.env: $(MAKE_BIN)/create_remote_database_env LESS_PRIORITY-%
	@mkdir -p ./envs/$*
	@$(MAKE_BIN)/create_remote_database_env $* $@

.PHONY: configure
