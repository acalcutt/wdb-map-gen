#!/bin/bash
. config/env.config

echo "====> : Start importing water data from https://osmdata.openstreetmap.de/data/water-polygons.html into PostgreSQL "

op_table_name="osm_ocean_polygon"
gen1_table_name="osm_ocean_polygon_gen1"
gen2_table_name="osm_ocean_polygon_gen2"
gen3_table_name="osm_ocean_polygon_gen3"
gen4_table_name="osm_ocean_polygon_gen4"


[ -f data/water_polygons.shp ] && rm data/water_polygons.shp
[ -f data/water_polygons.shx ] && rm data/water_polygons.shx
[ -f data/water_polygons.dbf ] && rm data/water_polygons.dbf
[ ! -f data/water-polygons-split-4326.zip ] && wget https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip -P data
[ -f data/water-polygons-split-4326.zip ] && unzip -p data/water-polygons-split-4326.zip water-polygons-split-4326/water_polygons.shp > data/water_polygons.shp
[ -f data/water-polygons-split-4326.zip ] && unzip -p data/water-polygons-split-4326.zip water-polygons-split-4326/water_polygons.shx > data/water_polygons.shx
[ -f data/water-polygons-split-4326.zip ] && unzip -p data/water-polygons-split-4326.zip water-polygons-split-4326/water_polygons.dbf > data/water_polygons.dbf

if [ -f data/water_polygons.shp ]; then
#Drop existing osm_ocean_polygon
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" <<EOSQL
	DROP TABLE IF EXISTS $op_table_name;
EOSQL

#Create water_polygons sql from shp and import it
[ -f data/water_polygons.sql ] && rm data/water_polygons.sql
shp2pgsql -s 4326 -I -g geometry data/water_polygons.shp $op_table_name > data/water_polygons.sql
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f data/water_polygons.sql | grep -v "INSERT 0 1"

#Create Generalized tables
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" <<EOSQL
	DROP TABLE IF EXISTS $gen1_table_name;
	DROP TABLE IF EXISTS $gen2_table_name;
	DROP TABLE IF EXISTS $gen3_table_name;
	DROP TABLE IF EXISTS $gen4_table_name;
    CREATE TABLE $gen1_table_name AS SELECT ST_Simplify(geometry, 20) AS geometry FROM $op_table_name;
    CREATE INDEX ON $gen1_table_name USING gist (geometry);
    ANALYZE $gen1_table_name;
    CREATE TABLE $gen2_table_name AS SELECT ST_Simplify(geometry, 40) AS geometry FROM $op_table_name;
    CREATE INDEX ON $gen2_table_name USING gist (geometry);
    ANALYZE $gen2_table_name;
    CREATE TABLE $gen3_table_name AS SELECT ST_Simplify(geometry, 80) AS geometry FROM $op_table_name;
    CREATE INDEX ON $gen3_table_name USING gist (geometry);
    ANALYZE $gen3_table_name;
    CREATE TABLE $gen4_table_name AS SELECT ST_Simplify(geometry, 160) AS geometry FROM $op_table_name;
    CREATE INDEX ON $gen4_table_name USING gist (geometry);
    ANALYZE $gen4_table_name;
EOSQL
fi

echo "====> : End importing water data from http://openstreetmapdata.com into PostgreSQL "