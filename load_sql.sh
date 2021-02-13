#!/bin/bash
. config/env.config

RUN_MULTITHREADED=false
EXECUTE_IMPORT=true
CONFIG_DIR=$(pwd)/config
EXPORT_DIR=$(pwd)/data
SQL_TOOLS_DIR=$CONFIG_DIR/sql #contains all SQL files to be imported before the ones generated by OpenMapTiles project
SQL_DIR=$EXPORT_DIR/sql
LAYER_FILE=$CONFIG_DIR/$EXPORT_LAYER_FILE

if [ ! -d "$EXPORT_DIR" ]; then mkdir -p $EXPORT_DIR; fi
if [ -d "$SQL_DIR" ]; then rm -Rf $SQL_DIR; fi
if [ ! -d "$SQL_DIR" ]; then mkdir -p $SQL_DIR; fi

if [ "$RUN_MULTITHREADED" == true ]; then
	echo "MULTI-THREADED"
	#Create Parallel SQL
	generate-sql $LAYER_FILE --dir $SQL_DIR

	#Load Parallel SQL
	export PGHOST=$POSTGRES_HOST
	export PGPORT=$POSTGRES_PORT
	export PGDATABASE=$POSTGRES_DB
	export PGUSER=$POSTGRES_USER
	export PGPASSWORD=$POSTGRES_PASS
	export SQL_TOOLS_DIR=$SQL_TOOLS_DIR
	export SQL_DIR=$SQL_DIR
	if [ "$EXECUTE_IMPORT" == true ]; then
		import-sql
	fi
else
	echo "Single-THREADED"
	#Create Tileset SQL
	generate-sql $LAYER_FILE > $SQL_DIR/tileset.sql
	
	if [ "$EXECUTE_IMPORT" == true ]; then
		#Load Needed SQL Functions
		for i in `find $SQL_TOOLS_DIR -name "*.sql" -type f|sort -d`; do
			echo "-- Importing: $i --"
			PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $i
		done	
		
		#Load Tileset SQL
		echo "-- Importing: $SQL_DIR/tileset.sql --"
		PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST -d $POSTGRES_DB -U "$POSTGRES_USER" -f $SQL_DIR/tileset.sql
	fi
fi

#Analyze PostgreSQL tables
PGPASSWORD=$POSTGRES_PASS psql -h $POSTGRES_HOST --username="$POSTGRES_USER" <<EOSQL
	\c $POSTGRES_DB;
	ANALYZE VERBOSE;
EOSQL









