#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
LAYERS_CONFIG=$CONFIG_DIR/wdbmap.yaml
DEST_PROJECT_DIR=$EXPORT_DIR/openmaptiles.tm2source
mkdir -p $EXPORT_DIR
mkdir -p $DEST_PROJECT_DIR

#Create TM2 SOURCE DIR
openmaptiles-tools/bin/generate-tm2source $LAYERS_CONFIG --host="$POSTGRES_HOST" --port=$POSTGRES_PORT --database="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS" > $DEST_PROJECT_DIR/data.yml
openmaptiles-tools/bin/generate-sql $LAYERS_CONFIG > $EXPORT_DIR/tileset.sql

PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f postgis-vt-util/postgis-vt-util.sql
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $CONFIG_DIR/language.sql
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $EXPORT_DIR/tileset.sql

#Export to MBTILES tileset
tilelive-copy --scheme="$RENDER_SCHEME" --bounds="$BBOX" --timeout="$TILE_TIMEOUT" --concurrency="$COPY_CONCURRENCY" --minzoom="$MIN_ZOOM" --maxzoom="$MAX_ZOOM" "tmsource:///$DEST_PROJECT_DIR" "mbtiles://$EXPORT_DIR/$MBTILES_NAME"
