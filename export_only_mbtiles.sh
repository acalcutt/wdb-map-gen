#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
GENCONFIG_DIR=$CONFIG_DIR/generated
EXPORT_DIR=$(pwd)/data
LAYER_FILE=$CONFIG_DIR/$EXPORT_LAYER_FILE
DEST_PROJECT_DIR=$EXPORT_DIR/openmaptiles.tm2source
mkdir -p $EXPORT_DIR
mkdir -p $GENCONFIG_DIR
mkdir -p $DEST_PROJECT_DIR



#Export to MBTILES tileset
nvm use v8.15.0
tilelive-copy --scheme="$RENDER_SCHEME" --bounds="$BBOX" --timeout="$TILE_TIMEOUT" --concurrency="$COPY_CONCURRENCY" --minzoom="$MIN_ZOOM" --maxzoom="$MAX_ZOOM" "tmsource:///$DEST_PROJECT_DIR" "mbtiles://$EXPORT_DIR/$MBTILES_NAME"
