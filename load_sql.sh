#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
LAYER_FILE=$CONFIG_DIR/$IMPORT_LAYER_FILE
EXPORT_DIR=$(pwd)/data
SQL_DIR=$EXPORT_DIR/sql

rm -R $SQL_DIR
mkdir -p $EXPORT_DIR
mkdir -p $SQL_DIR

generate-sql $LAYER_FILE  --dir $SQL_DIR

export PGHOST=$POSTGRES_HOST
export PGPORT=$POSTGRES_PORT
export PGDATABASE=$POSTGRES_DB
export PGUSER=$POSTGRES_USER
export PGPASSWORD=$POSTGRES_PASS
export SQL_TOOLS_DIR=$CONFIG_DIR
export SQL_DIR=$SQL_DIR

import-sql
