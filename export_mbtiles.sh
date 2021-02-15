#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
DEST_PROJECT_DIR=$EXPORT_DIR/openmaptiles.tm2source
LAYER_FILE=$CONFIG_DIR/$EXPORT_LAYER_FILE

if [ ! -d "$EXPORT_DIR" ]; then mkdir -p $EXPORT_DIR; fi
if [ -d "$DEST_PROJECT_DIR" ]; then rm -Rf $DEST_PROJECT_DIR; fi
if [ ! -d "$DEST_PROJECT_DIR" ]; then mkdir -p $DEST_PROJECT_DIR; fi

#Create TM2 SOURCE DIR
generate-tm2source $LAYER_FILE --host="$POSTGRES_HOST" --port=$POSTGRES_PORT --database="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS" > $DEST_PROJECT_DIR/data.yml

#Export to MBTILES tileset
nvm use v8.15.0
tilelive-copy --scheme="$RENDER_SCHEME" --bounds="$BBOX" --timeout="$TILE_TIMEOUT" --concurrency="$COPY_CONCURRENCY" --minzoom="$MIN_ZOOM" --maxzoom="$MAX_ZOOM" "tmsource:///$DEST_PROJECT_DIR" "mbtiles://$EXPORT_DIR/$MBTILES_NAME"
