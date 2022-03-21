#!/bin/bash

EXPORT_DIR=$(pwd)/data

java -Xmx45g \
	-XX:OnOutOfMemoryError="kill -9 %p" \
	-jar /planetiler/planetiler-dist/target/planetiler-dist-0.3-SNAPSHOT-with-deps.jar \
	--extra_layers=atv \
	--mbtiles=$EXPORT_DIR/output.mbtiles \
	--nodemap-type=array --nodemap-storage=mmap --nodemap-madvise --optimize_db=true
#	--nodemap-type=sparsearray --nodemap-storage=mmap --optimize_db=true