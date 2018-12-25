#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
IMPSOSM3_CACHE_DIR=$(pwd)/data/imposm3_cache
UPDATE_DIR=$(pwd)/data/update

# Create the imposm3 config file
(
  echo "{"
  echo "    \"cachedir\": \"$IMPSOSM3_CACHE_DIR\","
  echo "    \"connection\": \"postgis://$POSTGRES_USER:$POSTGRES_PASS@$POSTGRES_HOST/$POSTGRES_DB\","
  echo "    \"mapping\": \"$CONFIG_DIR/mapping.yml\""
  echo "}"

) > $EXPORT_DIR/config.json

#Set up and run osmisis
if [ -d "$UPDATE_DIR" ]; then rm -Rf $UPDATE_DIR; fi
mkdir -p $UPDATE_DIR
cp $IMPSOSM3_CACHE_DIR/last.state.txt $UPDATE_DIR/state.txt
cp $CONFIG_DIR/osmosis.config $UPDATE_DIR/configuration.txt
osmosis/bin/osmosis -q --read-replication-interval workingDirectory=$UPDATE_DIR --write-xml-change $UPDATE_DIR/changes.osc.gz

#Import changes with imposm
imposm3/bin/imposm diff -quiet -config $EXPORT_DIR/config.json $UPDATE_DIR/changes.osc.gz