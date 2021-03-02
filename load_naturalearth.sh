#!/bin/bash

#Settings
. config/env.config
PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
EXPORT_DIR=$(pwd)/data
NE_EXTRACT=$EXPORT_DIR/ne_extract

#Set up direcotries
if [ -d "$NE_EXTRACT" ]; then rm -Rf $NE_EXTRACT; fi
if [ ! -d "$EXPORT_DIR" ]; then mkdir -p $EXPORT_DIR; fi
mkdir -p $NE_EXTRACT

#Download NE Files
echo "====> : Downloading Natural Earth 10m, 50m, and 110m zip files"
if [ ! -f $EXPORT_DIR/10m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/10m_physical.zip -O $EXPORT_DIR/10m_physical.zip; fi
if [ ! -f $EXPORT_DIR/10m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m_cultural.zip -O $EXPORT_DIR/10m_cultural.zip; fi
if [ ! -f $EXPORT_DIR/50m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/50m_physical.zip -O $EXPORT_DIR/50m_physical.zip; fi
if [ ! -f $EXPORT_DIR/50m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/50m_cultural.zip -O $EXPORT_DIR/50m_cultural.zip; fi
if [ ! -f $EXPORT_DIR/110m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/110m_physical.zip -O $EXPORT_DIR/110m_physical.zip; fi
if [ ! -f $EXPORT_DIR/110m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/110m_cultural.zip -O $EXPORT_DIR/110m_cultural.zip; fi

#Extract NE Files
echo "====> : Extracting Natural Earth 10m, 50m, and 110m zip files to '$NE_EXTRACT'"
unzip -o $EXPORT_DIR/10m_physical.zip -d $NE_EXTRACT/10m_physical
unzip -o $EXPORT_DIR/10m_cultural.zip -d $NE_EXTRACT/10m_cultural
unzip -o $EXPORT_DIR/50m_physical.zip -d $NE_EXTRACT/50m_physical
unzip -o $EXPORT_DIR/50m_cultural.zip -d $NE_EXTRACT/50m_cultural
unzip -o $EXPORT_DIR/110m_physical.zip -d $NE_EXTRACT/110m_physical
unzip -o $EXPORT_DIR/110m_cultural.zip -d $NE_EXTRACT/110m_cultural

#Import extracted share files into Postgresql
echo "====> : Importing shape files into Postgresql"
for i in `find $NE_EXTRACT -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
		echo "Importing '$i' into '$table'"
        PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
done

#Delete the extracted files
echo "====> : Deleting extracted files"
if [ -d "$NE_EXTRACT" ]; then rm -Rf $NE_EXTRACT; fi