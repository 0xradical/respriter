#!/usr/bin/env bash

cat /database/db/structure.sql.env | envsubst | ( PGPASSWORD=`./bin/parse_uri $POSTGRES_URL password` psql -U `./bin/parse_uri $POSTGRES_URL user` -d `./bin/parse_uri $POSTGRES_URL path` )

if [[ -f "/database/db/${DB_ENV}_seed.sql" ]]; then
  echo "Running seeds at /database/db/${DB_ENV}_seed.sql"
  PGPASSWORD=`./bin/parse_uri $POSTGRES_URL password` psql -U `./bin/parse_uri $POSTGRES_URL user` -d `./bin/parse_uri $POSTGRES_URL path` -f /database/db/${DB_ENV}_seed.sql
fi
