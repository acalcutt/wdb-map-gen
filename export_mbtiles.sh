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

#Create TM2 SOURCE DIR
generate-tm2source $LAYER_FILE --host="$POSTGRES_HOST" --port=$POSTGRES_PORT --database="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS" > $DEST_PROJECT_DIR/data.yml
generate-sql $LAYER_FILE > $GENCONFIG_DIR/tileset.sql

PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f postgis-vt-util/postgis-vt-util.sql
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $CONFIG_DIR/language.sql
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $CONFIG_DIR/street_abbrv.sql
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $CONFIG_DIR/update_transportation_name.sql
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $GENCONFIG_DIR/tileset.sql

#Export to MBTILES tileset
nvm use v8.15.0
tilelive-copy --scheme="$RENDER_SCHEME" --bounds="$BBOX" --timeout="$TILE_TIMEOUT" --concurrency="$COPY_CONCURRENCY" --minzoom="$MIN_ZOOM" --maxzoom="$MAX_ZOOM" "tmsource:///$DEST_PROJECT_DIR" "mbtiles://$EXPORT_DIR/$MBTILES_NAME"
