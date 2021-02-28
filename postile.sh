#!/bin/bash
. /work/wdb-map-gen/config/env.config

CONFIG_DIR=/work/wdb-map-gen/config
EXPORT_DIR=/work/wdb-map-gen/data
DEST_PROJECT_DIR=/opt/postile/openmaptiles.tm2source
LAYER_FILE=$CONFIG_DIR/$EXPORT_LAYER_FILE


if [ ! -d "$EXPORT_DIR" ]; then mkdir -p $EXPORT_DIR; fi
if [ -d "$DEST_PROJECT_DIR" ]; then rm -Rf $DEST_PROJECT_DIR; fi
if [ ! -d "$DEST_PROJECT_DIR" ]; then mkdir -p $DEST_PROJECT_DIR; fi
echo $LAYER_FILE
#Create TM2 SOURCE DIR
generate-tm2source $LAYER_FILE --host="$POSTGRES_HOST" --port=$POSTGRES_PORT --database="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS" > $DEST_PROJECT_DIR/data.yaml
#run postile with the TM2 style
postile --cors  --tm2 openmaptiles.tm2source/data.yaml --pghost $POSTGRES_HOST --pguser $POSTGRES_USER --pgpassword $POSTGRES_PASS --listen 127.0.0.1 --pgdatabase $POSTGRES_DB --style style/style.json --fonts fonts/