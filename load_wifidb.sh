#!/bin/bash

#Settings
. config/env.config
PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
EXPORT_DIR=$(pwd)/data
WDB_EXTRACT=$EXPORT_DIR/wdb_extract

#Set up direcotries
#if [ -d "$WDB_EXTRACT" ]; then rm -Rf $WDB_EXTRACT; fi
if [ ! -d "$EXPORT_DIR" ]; then mkdir -p $EXPORT_DIR; fi
mkdir -p $WDB_EXTRACT

#Download NE Files
echo "====> : Downloading WifiDB GeoGSON files"
if [ ! -f $WDB_EXTRACT/cell_networks.json ]; then wget http://wifidb.net/wifidb/out/geojson/cell_networks.json -O $WDB_EXTRACT/cell_networks.json; fi
if [ ! -f $WDB_EXTRACT/WifiDB_0to1year.json ]; then wget http://wifidb.net/wifidb/out/geojson/WifiDB_0to1year.json -O $WDB_EXTRACT/WifiDB_0to1year.json; fi
if [ ! -f $WDB_EXTRACT/WifiDB_1to2year.json ]; then wget http://wifidb.net/wifidb/out/geojson/WifiDB_1to2year.json -O $WDB_EXTRACT/WifiDB_1to2year.json; fi
if [ ! -f $WDB_EXTRACT/WifiDB_2to3year.json ]; then wget http://wifidb.net/wifidb/out/geojson/WifiDB_2to3year.json -O $WDB_EXTRACT/WifiDB_2to3year.json; fi
if [ ! -f $WDB_EXTRACT/WifiDB_Legacy.json ]; then wget http://wifidb.net/wifidb/out/geojson/WifiDB_Legacy.json -O $WDB_EXTRACT/WifiDB_Legacy.json; fi
if [ ! -f $WDB_EXTRACT/WifiDB_monthly.json ]; then wget http://wifidb.net/wifidb/out/geojson/WifiDB_monthly.json -O $WDB_EXTRACT/WifiDB_monthly.json; fi
if [ ! -f $WDB_EXTRACT/WifiDB_weekly.json ]; then wget http://wifidb.net/wifidb/out/geojson/WifiDB_weekly.json -O $WDB_EXTRACT/WifiDB_weekly.json; fi


PGCLIENTENCODING=UTF8 ogr2ogr -progress -f PostgreSQL -s_srs EPSG:3857 -t_srs EPSG:3857 PG:"$PGCONN" $WDB_EXTRACT/WifiDB_Legacy.json -nln "wifidb_points" -overwrite -lco GEOMETRY_NAME=geometry -nlt geometry --config PG_USE_COPY YES --config OGR_TRUNCATE YES
PGCLIENTENCODING=UTF8 ogr2ogr -progress -f PostgreSQL -s_srs EPSG:3857 -t_srs EPSG:3857 PG:"$PGCONN" $WDB_EXTRACT/WifiDB_2to3year.json -nln "wifidb_points" -append -lco GEOMETRY_NAME=geometry -nlt geometry --config PG_USE_COPY YES
PGCLIENTENCODING=UTF8 ogr2ogr -progress -f PostgreSQL -s_srs EPSG:3857 -t_srs EPSG:3857 PG:"$PGCONN" $WDB_EXTRACT/WifiDB_1to2year.json -nln "wifidb_points" -append -lco GEOMETRY_NAME=geometry -nlt geometry --config PG_USE_COPY YES
PGCLIENTENCODING=UTF8 ogr2ogr -progress -f PostgreSQL -s_srs EPSG:3857 -t_srs EPSG:3857 PG:"$PGCONN" $WDB_EXTRACT/WifiDB_0to1year.json -nln "wifidb_points" -append -lco GEOMETRY_NAME=geometry -nlt geometry --config PG_USE_COPY YES
PGCLIENTENCODING=UTF8 ogr2ogr -progress -f PostgreSQL -s_srs EPSG:3857 -t_srs EPSG:3857 PG:"$PGCONN" $WDB_EXTRACT/WifiDB_monthly.json -nln "wifidb_points" -append -lco GEOMETRY_NAME=geometry -nlt geometry --config PG_USE_COPY YES
PGCLIENTENCODING=UTF8 ogr2ogr -progress -f PostgreSQL -s_srs EPSG:3857 -t_srs EPSG:3857 PG:"$PGCONN" $WDB_EXTRACT/WifiDB_weekly.json -nln "wifidb_points" -append -lco GEOMETRY_NAME=geometry -nlt geometry --config PG_USE_COPY YES






#Import extracted share files into Postgresql
echo "====> : Importing shape files into Postgresql"
for i in `find $WDB_EXTRACT -name "*.json" -type f`; do
        table=$(basename -- ${i%.*})
		echo "Importing '$i' into '$table'"
        PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
		
		#ogr2ogr -progress -f "PostgreSQL" PG:"$PGCONN" "source_data.json" -nln destination_table -append
done

#Delete the extracted files
echo "====> : Deleting extracted files"
if [ -d "$WDB_EXTRACT" ]; then rm -Rf $WDB_EXTRACT; fi