#!/bin/bash

EXPORT_DIR=$(pwd)/data
TMP_DIR=$(pwd)/data/tmp
if [ -d $TMP_DIR ]; then rm -Rf $TMP_DIR; fi
if [ -f $EXPORT_DIR/output.mbtiles ]; then rm -Rf $EXPORT_DIR/output.mbtiles; fi

java -Xmx45g \
	-XX:OnOutOfMemoryError="kill -9 %p" \
	-jar tools/planetiler/planetiler-dist/target/planetiler-dist-0.8-SNAPSHOT-with-deps.jar \
	--area=planet \
	--mbtiles=$EXPORT_DIR/output.mbtiles \
	--nodemap-type=sparsearray --nodemap-storage=mmap --optimize_db=true
