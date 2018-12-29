#!/bin/bash
. config/env.config
echo "====> : Start importing OpenStreetMap Lakelines data "

lcl_table_name="lake_centerline"

[ ! -f data/lake_centerline.geojson ] && wget https://github.com/lukasmartinelli/osm-lakelines/releases/download/v0.9/lake_centerline.geojson -P data

if [ -f data/lake_centerline.geojson ]; then
	PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
	PGCLIENTENCODING=UTF8 ogr2ogr -f Postgresql -s_srs EPSG:4326 -t_srs EPSG:3857 PG:"$PGCONN"  data/lake_centerline.geojson -nln "$lcl_table_name"
fi

echo "====> : End importing OpenStreetMap Lakelines data "


