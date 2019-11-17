#!/bin/bash
. config/env.config

EXPORT_DIR=$(pwd)/data

[ ! -f data/latest-all.json.gz ] && wget https://dumps.wikimedia.org/wikidatawiki/entities/latest-all.json.gz -P data

if [ -f data/latest-all.json.gz ]; then
import-wikidata/import_wikidata --file="data/latest-all.json.gz" --host="$POSTGRES_HOST" --port=$POSTGRES_PORT --dbname="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS"
fi
