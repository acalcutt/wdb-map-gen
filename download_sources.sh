#!/bin/bash

SOURCES_DIR=$(pwd)/data/sources
if [ -d $SOURCES_DIR ]; then rm -Rf $SOURCES_DIR; fi

#Download the planet pdb
java -jar tools/planetiler/planetiler-dist/target/planetiler-dist-0.5-SNAPSHOT-with-deps.jar --download --area=planet --only_download=true --fetch-wikidata
