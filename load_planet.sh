#!/bin/bash
. config/env.config

readonly DIFF_MODE=${DIFF_MODE:-true}
PBF=planet-latest.osm.pbf
PBF_BASE=http://planet.osm.org/pbf/
#PBF=massachusetts-latest.osm.pbf
#PBF_BASE=https://download.geofabrik.de/north-america/us/

echo "====> : Start importing Planet OpenStreetMap data: data/$PBF -> imposm3[./config/mapping.yaml] -> PostgreSQL"

CONFIG_DIR=$(pwd)/config
GENCONFIG_DIR=$CONFIG_DIR/generated
EXPORT_DIR=$(pwd)/data
LAYER_FILE=$CONFIG_DIR/$IMPORT_LAYER_FILE
IMPOSM3_MAPPING=$GENCONFIG_DIR/mapping.yaml
IMPOSM3_CONFIG=$GENCONFIG_DIR/imposm.json
IMPOSM3_CACHE_DIR=$EXPORT_DIR/imposm3_cache
IMPOSM3_DIFF_DIR=$EXPORT_DIR/imposm3_diff
mkdir -p $EXPORT_DIR
mkdir -p $GENCONFIG_DIR
mkdir -p $IMPOSM3_CACHE_DIR
mkdir -p $IMPOSM3_DIFF_DIR

#Create the mapping file
generate-imposm3 $LAYER_FILE > $IMPOSM3_MAPPING

# Create the imposm3 config file
(
  echo "{"
  echo "    \"cachedir\": \"$IMPOSM3_CACHE_DIR\","
  echo "    \"diffdir\": \"$IMPOSM3_DIFF_DIR\","
  echo "    \"connection\": \"postgis://$POSTGRES_USER:$POSTGRES_PASS@$POSTGRES_HOST/$POSTGRES_DB\","
  echo "    \"mapping\": \"$IMPOSM3_MAPPING\""
  echo "}"

) > $IMPOSM3_CONFIG

#Download the planet pdb
if [ ! -f data/$PBF ]; then
    wget $PBF_BASE$PBF -P data
fi

diff_flag=""
if [ "$DIFF_MODE" = true ]; then
	diff_flag="-diff"
	echo "Importing in diff mode"
else
	echo "Importing in normal mode"
fi

imposm3/bin/imposm import -config $IMPOSM3_CONFIG -overwritecache -read data/$PBF -deployproduction -write $diff_flag

echo "====> : End importing Planet OpenStreetMap data: data/$PBF -> imposm3[./config/mapping.yaml] -> PostgreSQL"
