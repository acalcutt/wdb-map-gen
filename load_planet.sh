#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
IMPSOSM3_CACHE_DIR=$EXPORT_DIR/imposm3_cache
mkdir -p $EXPORT_DIR
mkdir -p $IMPSOSM3_CACHE_DIR


# Create the imposm3 config file
(
  echo "{"
  echo "    \"cachedir\": \"$IMPSOSM3_CACHE_DIR\","
  echo "    \"connection\": \"postgis://$POSTGRES_USER:$POSTGRES_PASS@$POSTGRES_HOST/$POSTGRES_DB\","
  echo "    \"mapping\": \"$CONFIG_DIR/mapping.yml\""
  echo "}"

) > $EXPORT_DIR/config.json

#Create the postgres database to dump data into
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST --username="$POSTGRES_USER" <<EOSQL
	DROP DATABASE IF EXISTS $POSTGRES_DB;
    CREATE DATABASE $POSTGRES_DB;
	\c $POSTGRES_DB;
	DROP USER IF EXISTS $OSM_USER;
	CREATE ROLE $OSM_USER LOGIN PASSWORD '$OSM_PASS' NOSUPERUSER NOCREATEROLE CREATEDB;
    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;
EOSQL

#Download the planet pdb
if [ ! -f data/planet-latest.osm.pbf ]; then
    wget http://planet.osm.org/pbf/planet-latest.osm.pbf -P data
fi

#Import the pdf to postgress using imposm3
imposm3/bin/imposm import -config $EXPORT_DIR/config.json -write
imposm3/bin/imposm import -config $EXPORT_DIR/config.json -read data/planet-latest.osm.pbf -write -optimize -overwritecache -diff