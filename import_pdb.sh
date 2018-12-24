#!/bin/bash
POSTGRES_DB=osm
POSTGRES_USER=postgres
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
set PGPASSWORD=password

psql -h localhost --username="$POSTGRES_USER" <<EOSQL
	DROP DATABASE IF EXISTS $POSTGRES_DB;
    create database $POSTGRES_DB;
	\c $POSTGRES_DB;
    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;
EOSQL

if [ ! -f data/planet-latest.osm.pbf ]; then
    wget http://planet.osm.org/pbf/planet-latest.osm.pbf -P data
fi

bin/imposm import -config config/config.json -mapping config/mapping.yml -write
bin/imposm import -config config/config.json -read data/planet-latest.osm.pbf -write -optimize -overwritecache -diff
bin/imposm import -config config/config.json -deployproduction