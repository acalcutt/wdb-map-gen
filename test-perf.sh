#!/bin/bash
. config/env.config

CONFIG_DIR=$(pwd)/config
LAYER_FILE=$CONFIG_DIR/$EXPORT_LAYER_FILE

UV_THREADPOOL_SIZE=$UV_THREADPOOL_SIZE test-perf $LAYER_FILE --pghost="$POSTGRES_HOST" --pgport=$POSTGRES_PORT --dbname="$POSTGRES_DB" --user="$POSTGRES_USER" --password="$POSTGRES_PASS" --verbose
