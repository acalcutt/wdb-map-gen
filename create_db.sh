#!/bin/bash
. config/env.config
echo "====> : Start Creating DB $POSTGRES_DB"

CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
IMPSOSM3_CACHE_DIR=$EXPORT_DIR/imposm3_cache

#Create the postgres database to dump data into
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST --username="$POSTGRES_USER" <<EOSQL
	DROP DATABASE IF EXISTS $POSTGRES_DB;
    CREATE DATABASE $POSTGRES_DB;
	\c $POSTGRES_DB;
    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;
	CREATE EXTENSION plpython3u;
	CREATE EXTENSION hstore_plpython3u;
	CREATE EXTENSION osml10n;
	CREATE EXTENSION unaccent;
EOSQL

echo "====> : End Creating DB $POSTGRES_DB"

