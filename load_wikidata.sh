#!/bin/bash
. config/env.config

[ ! -f data/latest-all.json.gz ] && wget https://dumps.wikimedia.org/wikidatawiki/entities/latest-all.json.gz -P data
[ -f data/latest-all.json.gz ] && gzip -d < data/latest-all.json.gz > data/latest-all.json