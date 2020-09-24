#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
LAYER_FILE=$CONFIG_DIR/$IMPORT_LAYER_FILE
EXPORT_DIR=$(pwd)/data
CACHE_DIR=$EXPORT_DIR/cache

mkdir -p $EXPORT_DIR
mkdir -p $CACHE_DIR



import-wikidata --pghost="$POSTGRES_HOST" --pgport=$POSTGRES_PORT --dbname="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS" --cache $CACHE_DIR/wikidata-cache.json $LAYER_FILE
#[ ! -f data/latest-all.json.gz ] && wget https://dumps.wikimedia.org/wikidatawiki/entities/latest-all.json.gz -P data

#if [ -f data/latest-all.json.gz ]; then
#import-wikidata/import_wikidata --file="data/latest-all.json.gz" --host="$POSTGRES_HOST" --port=$POSTGRES_PORT --dbname="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS"


#fi
