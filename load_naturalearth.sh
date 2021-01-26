#!/bin/bash
. config/env.config
echo "====> : Start importing  http://www.naturalearthdata.com  into PostgreSQL "

#--- From https://www.naturalearthdata.com/downloads/10m-physical-vectors/ ---
if [ ! -f data/10m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/10m_physical.zi$
unzip data/10m_physical.zip -d data/10m_physical
for i in `find data/10m_physical -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
        PGCLIENTENCODING=UTF8 ogr2ogr -f Postgresql -s_srs EPSG:4326 -t_srs EPSG:3857 PG:"$PGCONN" -nlt PROMOTE_TO_MULTI -nln "$table" -skipfailur$
done
rm -rf 10m_physical

#--- From https://www.naturalearthdata.com/downloads/10m-cultural-vectors/ ---
if [ ! -f data/10m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m_cultural.zi$
unzip data/10m_cultural.zip -d data/10m_cultural
for i in `find data/10m_cultural -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
        PGCLIENTENCODING=UTF8 ogr2ogr -f Postgresql -s_srs EPSG:4326 -t_srs EPSG:3857 PG:"$PGCONN" -nlt PROMOTE_TO_MULTI -nln "$table" -skipfailur$
done