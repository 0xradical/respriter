#!/usr/bin/env bash

cat /docker-entrypoint-initdb.d/structure.sql.env | envsubst | ( PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -d $POSTGRES_DB )
