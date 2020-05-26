#!/usr/bin/env bash

cat /database/db/structure.sql.env | envsubst | ( PGPASSWORD=`./bin/parse_uri $POSTGRES_URL password` psql -U `./bin/parse_uri $POSTGRES_URL user` -d `./bin/parse_uri $POSTGRES_URL path` )

if [[ "$DB_ENV" = "dev" && -f "/database/db/seeds/prd_seed.sql" ]]; then
  echo "Running seeds at /database/db/seeds/prd_seed.sql"
  PGPASSWORD=`./bin/parse_uri $POSTGRES_URL password` psql -U `./bin/parse_uri $POSTGRES_URL user` -d `./bin/parse_uri $POSTGRES_URL path` -f /database/db/seeds/prd_seed.sql
fi

if [[ -f "/database/db/${DB_ENV}_seed.sql" ]]; then
  echo "Running seeds at /database/db/${DB_ENV}_seed.sql"
  PGPASSWORD=`./bin/parse_uri $POSTGRES_URL password` psql -U `./bin/parse_uri $POSTGRES_URL user` -d `./bin/parse_uri $POSTGRES_URL path` -f /database/db/${DB_ENV}_seed.sql
fi
