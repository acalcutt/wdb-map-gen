#!/bin/bash
. config/env.config

PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
WATER_TABLE_NAME="osm_ocean_polygon"
LAKE_CENTERLINE_TABLE="lake_centerline"
EXPORT_DIR=$(pwd)/data
CENTERLINES_GEOJSON=$EXPORT_DIR/lake_centerline.geojson

echo "====> : Start importing water data from https://osmdata.openstreetmap.de/data/water-polygons.html into PostgreSQL "

[ ! -f data/water-polygons-split-4326.zip ] && wget https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip -P data
unzip -o data/water-polygons-split-4326.zip -d data

if [ -f data/water-polygons-split-4326/water_polygons.shp ]; then
    ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$WATER_TABLE_NAME" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" data/water-polygons-split-4326/water_polygons.shp
fi

echo "====> : End importing water data from http://openstreetmapdata.com into PostgreSQL "
echo "====> : Start importing OpenStreetMap Lakelines data "


PG_CONNECT="postgis://$POSTGRES_USER:$POSTGRES_PASS@$POSTGRES_HOST/$POSTGRES_DB"
DB_SCHEMA="public"

tools/imposm3/bin/imposm import -connection "$PG_CONNECT" -mapping "$MAPPING_YAML" -overwritecache -cachedir "$IMPOSM_CACHE_DIR" -read "$pbf_file" -dbschema-import="$DB_SCHEMA" -write

#Load Lake CenterLines

[ ! -f $CENTERLINES_GEOJSON ] && wget https://github.com/acalcutt/osm-lakelines/releases/download/v9.1/lake_centerline.geojson -P data

if [ -f $CENTERLINES_GEOJSON ]; then
	PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -t_srs EPSG:3857 "PG:$PGCONN" -lco OVERWRITE=YES -overwrite -nln "$LAKE_CENTERLINE_TABLE" "data/lake_centerline.geojson"
fi

echo "====> : End importing OpenStreetMap Lakelines data "

