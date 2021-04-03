#!/bin/bash
. config/env.config
echo "====> : Start Creating DB $POSTGRES_DB"

CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
SQL_TOOLS_DIR=$CONFIG_DIR/sql
IMPSOSM3_CACHE_DIR=$EXPORT_DIR/imposm3_cache

#Create the postgres database to dump data into
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST --username="$POSTGRES_USER" <<EOSQL
	SELECT pg_terminate_backend(pg_stat_activity.pid)
	FROM pg_stat_activity
	WHERE pg_stat_activity.datname = '$POSTGRES_DB'
	  AND pid <> pg_backend_pid();
	  
	DROP DATABASE IF EXISTS $POSTGRES_DB;
    CREATE DATABASE $POSTGRES_DB;
	\c $POSTGRES_DB;

    CREATE EXTENSION IF NOT EXISTS postgis;
    CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
    -- Extensions needed for OpenMapTiles
    CREATE EXTENSION IF NOT EXISTS hstore;
    CREATE EXTENSION IF NOT EXISTS unaccent;
    CREATE EXTENSION IF NOT EXISTS osml10n;
    CREATE EXTENSION IF NOT EXISTS gzip;

EOSQL

#Load Needed SQL Functions
for i in `find $SQL_TOOLS_DIR -name "*.sql" -type f|sort -d`; do
	echo "-- Importing: $i --"
	PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $i
done	

echo "====> : End Creating DB $POSTGRES_DB"

