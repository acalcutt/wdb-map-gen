#!/bin/bash
. config/env.config

EXPORT_DIR=$(pwd)/data
DEST_PROJECT_DIR=$EXPORT_DIR/openmaptiles.tm2source
mkdir -p $EXPORT_DIR
mkdir -p $DEST_PROJECT_DIR

#Create TM2 SOURCE DIR
openmaptiles-tools/bin/generate-tm2source config/openmaptiles.yaml --host="$POSTGRES_HOST" --port=$POSTGRES_PORT --database="$POSTGRES_DB" --user="$OSM_USER" --password="$OSM_PASS" > $DEST_PROJECT_DIR/data.yml

#Export to MBTILES tileset
tilelive/bin/tilelive-copy --scheme="$RENDER_SCHEME" --bounds="$BBOX" --timeout="$TILE_TIMEOUT" --concurrency="$COPY_CONCURRENCY" --minzoom="$MIN_ZOOM" --maxzoom="$MAX_ZOOM" "tmsource://$DEST_PROJECT_DIR" "mbtiles://$EXPORT_DIR/$MBTILES_NAME"