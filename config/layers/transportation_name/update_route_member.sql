DROP TRIGGER IF EXISTS trigger_flag_transportation_name ON osm_route_member;


-- create GBR relations (so we can use it in the same way as other relations)
CREATE OR REPLACE FUNCTION update_gbr_route_members() RETURNS void AS
$$
DECLARE
    gbr_geom geometry;
BEGIN
    SELECT st_buffer(geometry, 10000) INTO gbr_geom FROM ne_10m_admin_0_countries WHERE iso_a2 = 'GB';
    DELETE FROM osm_route_member WHERE network IN ('omt-gb-motorway', 'omt-gb-trunk');

    INSERT INTO osm_route_member (osm_id, member, ref, network)
    SELECT 0,
           osm_id,
           substring(ref FROM E'^[AM][0-9AM()]+'),
           CASE WHEN highway = 'motorway' THEN 'omt-gb-motorway' ELSE 'omt-gb-trunk' END
    FROM osm_highway_linestring
    WHERE length(ref) > 0
      AND ST_Intersects(geometry, gbr_geom)
      AND highway IN ('motorway', 'trunk');
END;
$$ LANGUAGE plpgsql;


-- etldoc:  osm_route_member ->  osm_route_member
CREATE OR REPLACE FUNCTION update_osm_route_member() RETURNS void AS
$$
BEGIN
    PERFORM update_gbr_route_members();

    -- see http://wiki.openstreetmap.org/wiki/Relation:route#Road_routes
    UPDATE osm_route_member
    SET network_type =
            CASE
                WHEN network = 'US:I' THEN 'us-interstate'::route_network_type
                WHEN network = 'US:US' THEN 'us-highway'::route_network_type
                WHEN network LIKE 'US:__' THEN 'us-state'::route_network_type
                -- https://en.wikipedia.org/wiki/Trans-Canada_Highway
                -- TODO: improve hierarchical queries using
                --    http://www.openstreetmap.org/relation/1307243
                --    however the relation does not cover the whole Trans-Canada_Highway
                WHEN
                        (network = 'CA:transcanada') OR
                        (network = 'CA:BC:primary' AND ref IN ('16')) OR
                        (name = 'Yellowhead Highway (AB)' AND ref IN ('16')) OR
                        (network = 'CA:SK:primary' AND ref IN ('16')) OR
                        (network = 'CA:ON:primary' AND ref IN ('17', '417')) OR
                        (name = 'Route Transcanadienne') OR
                        (network = 'CA:NB:primary' AND ref IN ('2', '16')) OR
                        (network = 'CA:PE' AND ref IN ('1')) OR
                        (network = 'CA:NS' AND ref IN ('104', '105')) OR
                        (network = 'CA:NL:R' AND ref IN ('1')) OR
                        (name = 'Trans-Canada Highway')
                    THEN 'ca-transcanada'::route_network_type
                WHEN network = 'omt-gb-motorway' THEN 'gb-motorway'::route_network_type
                WHEN network = 'omt-gb-trunk' THEN 'gb-trunk'::route_network_type
                END;

END;
$$ LANGUAGE plpgsql;

CREATE INDEX IF NOT EXISTS osm_route_member_network_idx ON osm_route_member ("network");
CREATE INDEX IF NOT EXISTS osm_route_member_member_idx ON osm_route_member ("member");
CREATE INDEX IF NOT EXISTS osm_route_member_name_idx ON osm_route_member ("name");
CREATE INDEX IF NOT EXISTS osm_route_member_ref_idx ON osm_route_member ("ref");

SELECT update_osm_route_member();

CREATE INDEX IF NOT EXISTS osm_route_member_network_type_idx ON osm_route_member ("network_type");
