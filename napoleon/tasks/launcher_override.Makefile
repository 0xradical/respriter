run-database:
	@make -s run-napoleon-database

up-database:
	@make -s up-napoleon-database

down-database:
	@make -s down-napoleon-database

restart-database:
	@make -s restart-napoleon-database

console-database:
	@make -s psql-napoleon-database

psql-database:
	@make -s psql-napoleon-database

bash-database:
	@make -s bash-napoleon-database

bash-ports-database:
	@make -s bash-ports-napoleon-database

sh-database:
	@make -s sh-napoleon-database

sh-ports-database:
	@make -s sh-ports-napoleon-database

logs-database:
	@make -s logs-napoleon-database

run-api:
	@make -s run-napoleon-api

up-api:
	@make -s up-napoleon-api

down-api:
	@make -s down-napoleon-api

restart-api:
	@make -s restart-napoleon-api

psql-api:
	@make -s psql-napoleon-api

bash-api:
	@make -s bash-napoleon-api

bash-ports-api:
	@make -s bash-ports-napoleon-api

sh-api:
	@make -s sh-napoleon-api

sh-ports-api:
	@make -s sh-ports-napoleon-api

logs-api:
	@make -s logs-napoleon-api

.PHONY: run-database up-database down-database restart-database console-database psql-database bash-database bash-ports-database sh-database sh-ports-database logs-database run-api up-api down-api restart-api psql-api bash-api bash-ports-api sh-api sh-ports-api logs-api
