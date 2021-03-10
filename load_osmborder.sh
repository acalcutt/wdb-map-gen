#!/bin/bash
. config/env.config

EXPORT_DIR=$(pwd)/data
OSMB_CSV=$EXPORT_DIR/osmborder_lines.csv


if [! -f $OSMB_CSV ]; then
	# Download pre-compiled osmborder_lines.csv from 02/2021 planet pbf (see create_centerlines.sh to make a new one)
	echo "# Download pre-compiled osmborder_lines.csv from 02/2021 planet pbf (see create_centerlines.sh to make a new one)"
	[ ! -f $EXPORT_DIR/osmborder_lines.csv.gz ] && wget https://github.com/acalcutt/osmborder/releases/download/v0.1.0.1/osmborder_lines.csv.gz -P $EXPORT_DIR
	[ -f $EXPORT_DIR/osmborder_lines.csv.gz ] && gzip -d < $EXPORT_DIR/osmborder_lines.csv.gz > $OSMB_CSV
fi

if [ -f $OSMB_CSV ]; then
	echo "====> : Start importing border data from http://openstreetmap.org into PostgreSQL "
	ob_table_name="osm_border_linestring"

	#Drop existing osm_border_linestring
	PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" <<EOSQL
	DROP TABLE IF EXISTS $ob_table_name CASCADE;
	CREATE TABLE $ob_table_name (osm_id bigint, admin_level int, dividing_line bool, disputed bool, maritime bool, geometry Geometry(LineString, 3857));
	CREATE INDEX ON $ob_table_name USING gist (geometry);
EOSQL

	tools/pgfutter/pgfutter --schema "public" --host "$POSTGRES_HOST" --port "$POSTGRES_PORT" --dbname "$POSTGRES_DB" --username "$POSTGRES_USER" --pass "$POSTGRES_PASS" --table "$ob_table_name" csv --fields "osm_id,admin_level,dividing_line,disputed,maritime,geometry" --delimiter $'\t' $OSMB_CSV

	echo "====> : End importing border data from http://openstreetmap.org into PostgreSQL "
else
	echo "====> : No CSV File to import "
fi

