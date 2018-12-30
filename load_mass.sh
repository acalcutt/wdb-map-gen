#!/bin/bash
. config/env.config

readonly DIFF_MODE=${DIFF_MODE:-true}

echo "====> : Start importing Planet OpenStreetMap data: ./data/massachusetts-latest.osm.pbf -> imposm3[./config/mapping.yaml] -> PostgreSQL"

CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
IMPSOSM3_CACHE_DIR=$EXPORT_DIR/imposm3_cache
IMPSOSM3_DIFF_DIR=$EXPORT_DIR/imposm3_diff
mkdir -p $EXPORT_DIR
mkdir -p $IMPSOSM3_CACHE_DIR


# Create the imposm3 config file
(
  echo "{"
  echo "    \"cachedir\": \"$IMPSOSM3_CACHE_DIR\","
  echo "    \"diffdir\": \"$IMPSOSM3_DIFF_DIR\","
  echo "    \"connection\": \"postgis://$POSTGRES_USER:$POSTGRES_PASS@$POSTGRES_HOST/$POSTGRES_DB\","
  echo "    \"mapping\": \"$CONFIG_DIR/mapping.yml\""
  echo "}"

) > $EXPORT_DIR/config.json

#Download the planet pdb
if [ ! -f data/massachusetts-latest.osm.pbf ]; then
    #wget http://planet.osm.org/pbf/planet-latest.osm.pbf -P data
	wget https://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf -P data
fi

#Import the pdf to postgress using imposm3
#imposm3/bin/imposm import -config $EXPORT_DIR/config.json -read data/planet-latest.osm.pbf -write -optimize -overwritecache -diff
#imposm3/bin/imposm import -config $EXPORT_DIR/config.json -read data/massachusetts-latest.osm.pbf -write -optimize -overwritecache -diff
#imposm3/bin/imposm import -config $EXPORT_DIR/config.json -deployproduction


diff_flag=""
if [ "$DIFF_MODE" = true ]; then
	diff_flag="-diff"
	echo "Importing in diff mode"
else
	echo "Importing in normal mode"
fi

imposm3/bin/imposm import -config $EXPORT_DIR/config.json -overwritecache -read data/massachusetts-latest.osm.pbf -deployproduction -write $diff_flag



echo "====> : End importing Planet OpenStreetMap data: ./data/massachusetts-latest.osm.pbf -> imposm3[./config/mapping.yaml] -> PostgreSQL"
