#!/bin/bash
. config/env.config
echo "====> : Start importing  http://www.naturalearthdata.com  into natural_earth_vector.sqlite "

PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
NATURAL_EARTH_DB="data/natural_earth_vector.sqlite" 


#--- From https://www.naturalearthdata.com/downloads/10m-physical-vectors/ ---
if [ ! -f data/10m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/10m_physical.zip -O data/10m_physical.zip; fi
if [ ! -f data/10m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m_cultural.zip -O data/10m_cultural.zip; fi
if [ ! -f data/50m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/50m_physical.zip -O data/50m_physical.zip; fi
if [ ! -f data/50m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/50m_cultural.zip -O data/50m_cultural.zip; fi
if [ ! -f data/110m_physical.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/110m_physical.zip -O data/110m_physical.zip; fi
if [ ! -f data/110m_cultural.zip ]; then wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/110m_cultural.zip -O data/110m_cultural.zip; fi

unzip -o data/10m_physical.zip -d data/10m_physical
unzip -o data/10m_cultural.zip -d data/10m_cultural
unzip -o data/50m_physical.zip -d data/50m_physical
unzip -o data/50m_cultural.zip -d data/50m_cultural
unzip -o data/110m_physical.zip -d data/110m_physical
unzip -o data/110m_cultural.zip -d data/110m_cultural

rm -f $NATURAL_EARTH_DB
for shp in data/10m_cultural/*.shp data/10m_physical/*.shp data/50m_cultural/*.shp data/50m_physical/*.shp data/110m_cultural/*.shp data/110m_physical/*.shp; \
do \
	echo $shp;
	ogr2ogr -progress -f SQLite -append $NATURAL_EARTH_DB $shp; \
done

echo "====> : Start importing $NATURAL_EARTH_DB into Postgresql "
echo $NATURAL_EARTH_DB;
PGCLIENTENCODING=UTF8 ogr2ogr -progress -f Postgresql -s_srs EPSG:4326 -t_srs EPSG:3857 -clipsrc -180.1 -85.0511 180.1 85.0511 PG:"${PGCONN}" -lco GEOMETRY_NAME=geometry -lco OVERWRITE=YES -lco DIM=2 -nlt GEOMETRY -overwrite "$NATURAL_EARTH_DB"