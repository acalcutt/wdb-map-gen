#!/bin/bash
. config/env.config

EXPORT_DIR=$(pwd)/data
FULL_PBF=$EXPORT_DIR/planet-latest.osm.pbf
OSMB_PBF=$EXPORT_DIR/osmborder_lines.pbf
OSMB_CSV=$EXPORT_DIR/osmborder_lines.csv

echo "====> : Creating border data from planet PBF"
#Download the planet pdb if it does not exist
if [ ! -f $FULL_PBF ]; then
	echo "====> : Downloading PBF $FULL_PBF"
	download-osm planet -o $FULL_PBF
fi

if [ -f $FULL_PBF ]; then
	#Filter the full PBF down using osmborder_filter
	echo "====> : Filtering border from PBF $FULL_PBF to $OSMB_PBF"
	if [ -f $OSMB_PBF ]; then rm -f $OSMB_PBF; fi
	osmborder_filter -o $OSMB_PBF $FULL_PBF
	
	if [ -f $OSMB_PBF ]; then
		#Create osmborder_lines.csv from filtered PBF
		echo "====> : Creating CSV $OSMB_CSV from $OSMB_PBF"
		if [ -f $OSMB_CSV ]; then rm -f $OSMB_CSV; fi
		osmborder -o $OSMB_CSV $OSMB_PBF
		rm -f $OSMB_PBF
	fi
fi

