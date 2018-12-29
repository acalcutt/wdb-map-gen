#!/bin/bash
. config/env.config
echo "====> : Start importing  http://www.naturalearthdata.com  into PostgreSQL "

#Import Natuaral Earth
[ -f data/natural_earth_vector.sqlite ] && rm data/natural_earth_vector.sqlite 
[ ! -f data/natural_earth_vector.sqlite.zip ] && wget http://naciscdn.org/naturalearth/packages/natural_earth_vector.sqlite.zip -P data
[ -f data/natural_earth_vector.sqlite.zip ] && unzip -p data/natural_earth_vector.sqlite.zip packages/natural_earth_vector.sqlite > data/natural_earth_vector.sqlite 

if [ -f data/natural_earth_vector.sqlite ]; then
	PGCONN="dbname=$POSTGRES_DB user=$POSTGRES_USER host=$POSTGRES_HOST password=$POSTGRES_PASS port=$POSTGRES_PORT"
	PGCLIENTENCODING=LATIN1 ogr2ogr -progress -f Postgresql -s_srs EPSG:4326 -t_srs EPSG:3857 -clipsrc -180.1 -85.0511 180.1 85.0511 PG:"$PGCONN" -lco GEOMETRY_NAME=geometry -lco OVERWRITE=YES -lco DIM=2 -nlt GEOMETRY -overwrite data/natural_earth_vector.sqlite
fi

echo "====> : End importing  http://www.naturalearthdata.com  into PostgreSQL "