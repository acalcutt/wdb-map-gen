#!/bin/bash
. config/env.config

PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
WATER_TABLE_NAME="osm_ocean_polygon"
LAKE_CENTERLINE_TABLE="lake_centerline"

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

#lake_shapefile="/data/osm_lake_polygon.shp"
#query="SELECT osm_id, ST_SimplifyPreserveTopology(geometry, 100) AS geometry FROM osm_lake_polygon WHERE area > 2 * 1000 * 1000 AND ST_GeometryType(geometry)='ST_Polygon' AND name <> '' ORDER BY area DESC"
#pgsql2shp -f "$lake_shapefile" -h "$POSTGRES_PORT_5432_TCP_ADDR" -u "$POSTGRES_ENV_POSTGRES_USER" -P "$POSTGRES_ENV_POSTGRES_PASSWORD" "$POSTGRES_DB" "$query"

#create_centerlines --output_driver "GeoJSON" "/data/osm_lake_polygon.shp" "/data/osm_lake_centerline.geojson"



[ ! -f data/lake_centerline.geojson ] && wget https://github.com/acalcutt/osm-lakelines/releases/download/v9.1/osm_lake_centerline.geojson -P data

if [ -f data/lake_centerline.geojson ]; then
	PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:4326 -t_srs EPSG:3857 "PG:$PGCONN" -lco OVERWRITE=YES -overwrite -nln "$LAKE_CENTERLINE_TABLE" data/lake_centerline.geojson
fi

echo "====> : End importing OpenStreetMap Lakelines data "

