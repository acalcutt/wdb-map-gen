'''Max number of lines to read from dump'''
LIMIT = 100000000
# LIMIT = 100000

'''OSM tables to fetch Wikidata for'''
OSM_TABLES = [
    'osm_aerodrome_label_point',
    'osm_peak_point',
    'osm_city_point',
    'osm_continent_point',
    'osm_country_point',
    'osm_island_point',
    'osm_island_polygon',
    'osm_state_point',
    'osm_poi_point',
    'osm_poi_polygon',
    'osm_marine_point',
    'osm_water_polygon',
    'osm_waterway_linestring'
]

'''Table with imported wikidata'''
TABLE_NAME = 'wd_names'

