#!/bin/bash
. config/env.config

set PGPASSWORD=$POSTGRES_PASS
psql -h $POSTGRES_HOST --username="$POSTGRES_USER" <<EOSQL
	DROP DATABASE IF EXISTS $POSTGRES_DB;
    CREATE DATABASE $POSTGRES_DB;
	\c $POSTGRES_DB;
	DROP USER IF EXISTS $OSM_USER;
	CREATE ROLE $OSM_USER LOGIN PASSWORD '$OSM_PASS' NOSUPERUSER NOCREATEROLE CREATEDB;
    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;
EOSQL

if [ ! -f data/planet-latest.osm.pbf ]; then
    wget http://planet.osm.org/pbf/planet-latest.osm.pbf -P data
fi

bin/imposm import -mapping config/mapping.yml -write -connection postgis://$POSTGRES_USER:$POSTGRES_PASS@$POSTGRES_HOST/$POSTGRES_DB
bin/imposm import -config config/config.json -read data/planet-latest.osm.pbf -write -optimize -overwritecache -diff
bin/imposm import -config config/config.json -deployproduction