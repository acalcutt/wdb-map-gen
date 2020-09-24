#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
LAYER_FILE=$CONFIG_DIR/$IMPORT_LAYER_FILE
EXPORT_DIR=$(pwd)/data
CACHE_DIR=$EXPORT_DIR/cache

mkdir -p $EXPORT_DIR
mkdir -p $CACHE_DIR

import-wikidata --pghost="$POSTGRES_HOST" --pgport=$POSTGRES_PORT --dbname="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS" --cache $CACHE_DIR/wikidata-cache.json $LAYER_FILE