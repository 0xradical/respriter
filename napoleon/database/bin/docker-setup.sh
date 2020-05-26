#!/usr/bin/env bash

query_paramsless_url=$(echo $POSTGRES_URL | cut -d\? -f1)
cat /database/db/structure.sql.env | envsubst | psql $query_paramsless_url

if [[ -f "/database/db/${DB_ENV}_seed.sql" ]]; then
  echo "Running seeds at /database/db/${DB_ENV}_seed.sql"
  PGPASSWORD=`./bin/parse_uri $POSTGRES_URL password` psql -U `./bin/parse_uri $POSTGRES_URL user` -d `./bin/parse_uri $POSTGRES_URL path` -f /database/db/${DB_ENV}_seed.sql
fi
