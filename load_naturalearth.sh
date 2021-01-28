#!/bin/bash
. config/env.config
echo "====> : Start importing  http://www.naturalearthdata.com  into PostgreSQL "

#--- From https://www.naturalearthdata.com/downloads/10m-physical-vectors/ ---
if [ ! -f data/10m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/10m_physical.zip -O data/10m_physical.zip; fi
unzip data/10m_physical.zip -d data/10m_physical
for i in `find data/10m_physical -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
		PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
done
rm -rf 10m_physical

#--- From https://www.naturalearthdata.com/downloads/10m-cultural-vectors/ ---
if [ ! -f data/10m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m_cultural.zip -O data/10m_cultural.zip; fi
unzip data/10m_cultural.zip -d data/10m_cultural
for i in `find data/10m_cultural -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
        PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
done

#--- From https://www.naturalearthdata.com/downloads/50m-physical-vectors/ ---
if [ ! -f data/50m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/50m_physical.zip -O data/50m_physical.zip; fi
unzip data/50m_physical.zip -d data/50m_physical
for i in `find data/50m_physical -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
        PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
done
rm -rf 10m_physical

#--- From https://www.naturalearthdata.com/downloads/50m-cultural-vectors/ ---
if [ ! -f data/50m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/50m_cultural.zip -O data/50m_cultural.zip; fi
unzip data/50m_cultural.zip -d data/50m_cultural
for i in `find data/50m_cultural -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
        PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
done

#--- From https://www.naturalearthdata.com/downloads/110m-physical-vectors/ ---
if [ ! -f data/110m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/110m_physical.zip -O data/110m_physical.zip; fi
unzip data/110m_physical.zip -d data/110m_physical
for i in `find data/110m_physical -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
        PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
done
rm -rf 10m_physical

#--- From https://www.naturalearthdata.com/downloads/110m-cultural-vectors/ ---
if [ ! -f data/110m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/110m_cultural.zip -O data/110m_cultural.zip; fi
unzip data/110m_cultural.zip -d data/110m_cultural
for i in `find data/110m_cultural -name "*.shp" -type f`; do
        table=$(basename -- ${i%.*})
        PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
        PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:3857 -t_srs EPSG:3857 -lco OVERWRITE=YES -lco GEOMETRY_NAME=geometry -overwrite -nln "$table" -nlt geometry --config PG_USE_COPY YES PG:"$PGCONN" $i
done
