#!/bin/bash
. config/env.config
CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
FULL_PBF=$EXPORT_DIR/sources/planet.osm.pbf
LAKE_SHP=$EXPORT_DIR/osm_lake_polygon.shp
CENTERLINES_SHP=$EXPORT_DIR/lake_centerline.shp
CENTERLINES_GEOJSON=$EXPORT_DIR/lake_centerline.geojson
CENTERLINES_GPKG=$EXPORT_DIR/lake_centerline.gpkg
MAPPING_YAML=$CONFIG_DIR/lake_centerlines.yaml
IMPOSM3_CACHE_DIR=$EXPORT_DIR/lake_centerlines_cache
SIMPLIFY_TABLE="osm_lake_polygon_simplify"

if [ ! -d "$EXPORT_DIR" ]; then mkdir -p $EXPORT_DIR; fi
if [ ! -d "$IMPOSM3_CACHE_DIR" ]; then mkdir -p $IMPOSM3_CACHE_DIR; fi
if [ -f $LAKE_SHP ]; then rm $LAKE_SHP; fi
if [ -f $CENTERLINES_SHP ]; then rm $CENTERLINES_SHP; fi
if [ -f $CENTERLINES_GEOJSON ]; then rm $CENTERLINES_GEOJSON; fi
if [ -f $CENTERLINES_GPKG ]; then rm $CENTERLINES_GPKG; fi

if [ -f $FULL_PBF ]; then
	echo "====> : Drop lake polygon database if it exists. Create a blank db."
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST --username="$POSTGRES_USER" <<EOSQL
	SELECT pg_terminate_backend(pg_stat_activity.pid)
	FROM pg_stat_activity
	WHERE pg_stat_activity.datname = '$POSTGRES_LAKE_POLYGON_DB'
	  AND pid <> pg_backend_pid();
	  
	DROP DATABASE IF EXISTS $POSTGRES_LAKE_POLYGON_DB;
    CREATE DATABASE $POSTGRES_LAKE_POLYGON_DB;
	\c $POSTGRES_LAKE_POLYGON_DB;

    CREATE EXTENSION IF NOT EXISTS postgis;
    CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

EOSQL
	echo "====> : Importing plantet PBF into postgresql using imposm"
	PG_CONNECT="postgis://$POSTGRES_USER:$POSTGRES_PASS@$POSTGRES_HOST/$POSTGRES_LAKE_POLYGON_DB"
	DB_SCHEMA="public"
	
	tools/imposm3/bin/imposm import -connection "$PG_CONNECT" -mapping "$MAPPING_YAML" -overwritecache -cachedir "$IMPOSM3_CACHE_DIR" -read "$FULL_PBF" -dbschema-import="$DB_SCHEMA" -write
	echo "====> : Simplifying polygons with a lot of points"
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST --username="$POSTGRES_USER" <<EOSQL
	DROP TABLE IF EXISTS $SIMPLIFY_TABLE;
	SELECT
		osm_id, ST_SimplifyVW(geometry,50) As geometry, ST_Npoints(ST_SimplifyVW(geometry,50)) As points 
	INTO $SIMPLIFY_TABLE
	FROM
		osm_lake_polygon
	WHERE area > 2 * 1000 * 1000 AND ST_GeometryType(geometry)IN ('ST_Polygon','ST_MultiPolygon') AND name <> '' ORDER BY area DESC;
		
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry,100), points = ST_Npoints(ST_SimplifyVW(geometry, 100))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry,200), points = ST_Npoints(ST_SimplifyVW(geometry, 200))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry,400), points = ST_Npoints(ST_SimplifyVW(geometry, 400))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 800), points = ST_Npoints(ST_SimplifyVW(geometry, 800))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 3200), points = ST_Npoints(ST_SimplifyVW(geometry, 3200))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 6400), points = ST_Npoints(ST_SimplifyVW(geometry, 6400))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 12800), points = ST_Npoints(ST_SimplifyVW(geometry, 12800))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 25600), points = ST_Npoints(ST_SimplifyVW(geometry, 25600))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 51200), points = ST_Npoints(ST_SimplifyVW(geometry, 51200))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 102400), points = ST_Npoints(ST_SimplifyVW(geometry, 102400))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 204800), points = ST_Npoints(ST_SimplifyVW(geometry, 204800))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 409600), points = ST_Npoints(ST_SimplifyVW(geometry, 409600))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 819200), points = ST_Npoints(ST_SimplifyVW(geometry, 819200))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 1638400), points = ST_Npoints(ST_SimplifyVW(geometry, 1638400))
	WHERE points > 20000;
	UPDATE $SIMPLIFY_TABLE
	SET geometry = ST_SimplifyVW(geometry, 3276800), points = ST_Npoints(ST_SimplifyVW(geometry, 3276800))
	WHERE points > 20000;
EOSQL

		echo "====> : Exporting lake shapes into a shapefile"
		query="SELECT osm_id, ST_makeValid(geometry) AS geometry FROM $SIMPLIFY_TABLE ORDER BY osm_id ASC"
		tools/postgis-3.2.1/loader/pgsql2shp -f "$LAKE_SHP" -h "$POSTGRES_HOST" -u "$POSTGRES_USER" -P "$POSTGRES_PASS" "$POSTGRES_LAKE_POLYGON_DB" "$query"
		echo "====> : Creating a lake_centerline.geojson file from the exported shapefile"
		label_centerlines --verbose --max_points=20000 --simplification=0.02 --smooth=2 --max_paths=1 --output_driver GeoJSON "$LAKE_SHP" "$CENTERLINES_GEOJSON"
		#label_centerlines --verbose --max_points=20000 --simplification=0.02 --smooth=2 --max_paths=1 --output_driver GPKG "$LAKE_SHP" "$CENTERLINES_GPKG"
		echo "====> : Creating a lake_centerline.shp file from the exported shapefile"
		ogr2ogr -f "ESRI Shapefile" "$CENTERLINES_SHP" "$CENTERLINES_GEOJSON"
	fi
else
	echo "====> : $FULL_PBF Does not exist. Please download it first."
fi
