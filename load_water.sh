#!/bin/bash
. config/env.config

PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
WATER_TABLE_NAME="osm_ocean_polygon"
LAKE_CENTERLINE_TABLE="lake_centerline"

echo "====> : Start importing water data from https://osmdata.openstreetmap.de/data/water-polygons.html into PostgreSQL "

[ -f data/water_polygons.shp ] && rm data/water_polygons.shp
[ -f data/water_polygons.shx ] && rm data/water_polygons.shx
[ -f data/water_polygons.dbf ] && rm data/water_polygons.dbf
[ ! -f data/water-polygons-split-4326.zip ] && wget https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip -P data
[ -f data/water-polygons-split-4326.zip ] && unzip -p data/water-polygons-split-4326.zip water-polygons-split-4326/water_polygons.shp > data/water_polygons.shp
[ -f data/water-polygons-split-4326.zip ] && unzip -p data/water-polygons-split-4326.zip water-polygons-split-4326/water_polygons.shx > data/water_polygons.shx
[ -f data/water-polygons-split-4326.zip ] && unzip -p data/water-polygons-split-4326.zip water-polygons-split-4326/water_polygons.dbf > data/water_polygons.dbf

if [ -f data/water_polygons.shp ]; then
    PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$WATER_TABLE_NAME" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" data/water_polygons.shp
fi

echo "====> : End importing water data from http://openstreetmapdata.com into PostgreSQL "
echo "====> : Start importing OpenStreetMap Lakelines data "

[ ! -f data/lake_centerline.geojson ] && wget https://github.com/lukasmartinelli/osm-lakelines/releases/download/v0.9/lake_centerline.geojson -P data

if [ -f data/lake_centerline.geojson ]; then
	PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:4326 -t_srs EPSG:3857 "PG:$PGCONN" -lco OVERWRITE=YES -overwrite -nln "$LAKE_CENTERLINE_TABLE" data/lake_centerline.geojson
fi

echo "====> : End importing OpenStreetMap Lakelines data "

