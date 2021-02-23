#!/bin/bash
. config/env.config

EXPORT_DIR=$(pwd)/data
FULL_PBF=$EXPORT_DIR/planet-latest.osm.pbf
OSMB_PBF=$EXPORT_DIR/osmborder_lines.pbf
OSMB_CSV=$EXPORT_DIR/osmborder_lines.csv

#Download the planet pdb if it does not exist
if [ ! -f $FULL_PBF ]; then
	echo "====> : Downloading PBF $FULL_PBF"
	download-osm planet -o $FULL_PBF
fi

#Download pgfutter
if [ ! -f $EXPORT_DIR/pgfutter ]; then
	wget -O $EXPORT_DIR/pgfutter https://github.com/lukasmartinelli/pgfutter/releases/download/v1.1/pgfutter_linux_amd64
	chmod +x $EXPORT_DIR/pgfutter
fi

#Filter the full PBF down using osmborder_filter
echo "====> : Filtering border from PBF $FULL_PBF to $OSMB_PBF"
if [ -f $OSMB_PBF ]; then rm -f $OSMB_PBF; fi
osmborder_filter -o $OSMB_PBF $FULL_PBF

#Create osmborder_lines.csv from filtered PBF
echo "====> : Creating CSV $OSMB_CSV from $OSMB_PBF"
if [ -f $OSMB_CSV ]; then rm -f $OSMB_CSV; fi
osmborder -o $OSMB_CSV $OSMB_PBF
rm -f $OSMB_PBF

echo "====> : Start importing border data from http://openstreetmap.org into PostgreSQL "

if [ -f $OSMB_CSV ]; then

ob_table_name="osm_border_linestring"
gen1_table_name="osm_border_linestring_gen1"
gen2_table_name="osm_border_linestring_gen2"
gen3_table_name="osm_border_linestring_gen3"
gen4_table_name="osm_border_linestring_gen4"
gen5_table_name="osm_border_linestring_gen5"
gen6_table_name="osm_border_linestring_gen6"
gen7_table_name="osm_border_linestring_gen7"
gen8_table_name="osm_border_linestring_gen8"
gen9_table_name="osm_border_linestring_gen9"
gen10_table_name="osm_border_linestring_gen10"

#Drop existing osm_border_linestring
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" <<EOSQL
	DROP TABLE IF EXISTS $ob_table_name;
    CREATE TABLE $ob_table_name (osm_id bigint, admin_level int, dividing_line bool, disputed bool, maritime bool, geometry Geometry(LineString, 3857));
    CREATE INDEX ON $ob_table_name USING gist (geometry);
EOSQL

$EXPORT_DIR/pgfutter --schema "public" --host "$POSTGRES_HOST" --port "$POSTGRES_PORT" --dbname "$POSTGRES_DB" --username "$POSTGRES_USER" --pass "$POSTGRES_PASS" --table "$ob_table_name" csv --fields "osm_id,admin_level,dividing_line,disputed,maritime,geometry" --delimiter $'\t' $OSMB_CSV

#Create Generalized tables
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" <<EOSQL
	DROP TABLE IF EXISTS $gen1_table_name;
	DROP TABLE IF EXISTS $gen2_table_name;
	DROP TABLE IF EXISTS $gen3_table_name;
	DROP TABLE IF EXISTS $gen4_table_name;
	DROP TABLE IF EXISTS $gen5_table_name;
	DROP TABLE IF EXISTS $gen6_table_name;
	DROP TABLE IF EXISTS $gen7_table_name;
	DROP TABLE IF EXISTS $gen8_table_name;
	DROP TABLE IF EXISTS $gen9_table_name;
	DROP TABLE IF EXISTS $gen10_table_name;
    CREATE TABLE $gen1_table_name AS SELECT ST_Simplify(geometry, 10) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 10;
    CREATE INDEX ON $gen1_table_name USING gist (geometry);
    ANALYZE $gen1_table_name;
    CREATE TABLE $gen2_table_name AS SELECT ST_Simplify(geometry, 20) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 10;
    CREATE INDEX ON $gen2_table_name USING gist (geometry);
    ANALYZE $gen2_table_name;
    CREATE TABLE $gen3_table_name AS SELECT ST_Simplify(geometry, 40) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 8;
    CREATE INDEX ON $gen3_table_name USING gist (geometry);
    ANALYZE $gen3_table_name;
    CREATE TABLE $gen4_table_name AS SELECT ST_Simplify(geometry, 80) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 6;
    CREATE INDEX ON $gen4_table_name USING gist (geometry);
    ANALYZE $gen4_table_name;
    CREATE TABLE $gen5_table_name AS SELECT ST_Simplify(geometry, 160) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 6;
    CREATE INDEX ON $gen5_table_name USING gist (geometry);
    ANALYZE $gen5_table_name;
    CREATE TABLE $gen6_table_name AS SELECT ST_Simplify(geometry, 300) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 4;
    CREATE INDEX ON $gen6_table_name USING gist (geometry);
    ANALYZE $gen6_table_name;
    CREATE TABLE $gen7_table_name AS SELECT ST_Simplify(geometry, 600) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 4;
    CREATE INDEX ON $gen7_table_name USING gist (geometry);
    ANALYZE $gen7_table_name;
    CREATE TABLE $gen8_table_name AS SELECT ST_Simplify(geometry, 1200) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 4;
    CREATE INDEX ON $gen8_table_name USING gist (geometry);
    ANALYZE $gen8_table_name;
    CREATE TABLE $gen9_table_name AS SELECT ST_Simplify(geometry, 2400) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 4;
    CREATE INDEX ON $gen9_table_name USING gist (geometry);
    ANALYZE $gen9_table_name;
    CREATE TABLE $gen10_table_name AS SELECT ST_Simplify(geometry, 4800) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime FROM $ob_table_name WHERE admin_level <= 2;
    CREATE INDEX ON $gen10_table_name USING gist (geometry);
    ANALYZE $gen10_table_name;
EOSQL
fi

echo "====> : End importing border data from http://openstreetmap.org into PostgreSQL "