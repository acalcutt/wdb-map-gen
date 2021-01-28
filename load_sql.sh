#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
LAYER_FILE=$CONFIG_DIR/$IMPORT_LAYER_FILE
EXPORT_DIR=$(pwd)/data
#SQL_DIR=$EXPORT_DIR/sql
GENCONFIG_DIR=$CONFIG_DIR/generated

rm -R $SQL_DIR
mkdir -p $EXPORT_DIR
#mkdir -p $SQL_DIR
mkdir -p $GENCONFIG_DIR

#generate-sql $LAYER_FILE  --dir $SQL_DIR
generate-sql $LAYER_FILE > $GENCONFIG_DIR/tileset.sql

for i in `find config/sql -name "*.sql" -type f`; do
	echo "-- $i --"
	PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $i
done

PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $GENCONFIG_DIR/tileset.sql

#export PGHOST=$POSTGRES_HOST
#export PGPORT=$POSTGRES_PORT
#export PGDATABASE=$POSTGRES_DB
#export PGUSER=$POSTGRES_USER
#export PGPASSWORD=$POSTGRES_PASS
#export SQL_TOOLS_DIR=$CONFIG_DIR
#export SQL_DIR=$SQL_DIR
#import-sql
