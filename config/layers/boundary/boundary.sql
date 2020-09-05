-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen1 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen1
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen1 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen1 AS
(
SELECT ST_Simplify(geometry, 10) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 10
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen1_idx ON osm_border_linestring_gen1 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen2 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen2
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen2 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen2 AS
(
SELECT ST_Simplify(geometry, 20) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 10
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen2_idx ON osm_border_linestring_gen2 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen3 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen3
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen3 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen3 AS
(
SELECT ST_Simplify(geometry, 40) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 8
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen3_idx ON osm_border_linestring_gen3 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen4 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen4
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen4 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen4 AS
(
SELECT ST_Simplify(geometry, 80) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 6
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen4_idx ON osm_border_linestring_gen4 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen5 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen5
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen5 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen5 AS
(
SELECT ST_Simplify(geometry, 160) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 6
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen5_idx ON osm_border_linestring_gen5 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen6 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen6
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen6 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen6 AS
(
SELECT ST_Simplify(geometry, 300) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 4
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen6_idx ON osm_border_linestring_gen6 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen7 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen7
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen7 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen7 AS
(
SELECT ST_Simplify(geometry, 600) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 4
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen7_idx ON osm_border_linestring_gen7 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen8 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen8
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen8 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen8 AS
(
SELECT ST_Simplify(geometry, 1200) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 4
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen8_idx ON osm_border_linestring_gen8 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen9 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen9
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen9 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen9 AS
(
SELECT ST_Simplify(geometry, 2400) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 4
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen9_idx ON osm_border_linestring_gen9 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO
$$
    BEGIN
        DROP TABLE IF EXISTS osm_border_linestring_gen10 CASCADE;
    EXCEPTION
        WHEN wrong_object_type THEN
    END;
$$ LANGUAGE plpgsql;

-- etldoc: osm_border_linestring -> osm_border_linestring_gen10
DROP MATERIALIZED VIEW IF EXISTS osm_border_linestring_gen10 CASCADE;
CREATE MATERIALIZED VIEW osm_border_linestring_gen10 AS
(
SELECT ST_Simplify(geometry, 4800) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
FROM osm_border_linestring
WHERE admin_level <= 2
    ) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen10_idx ON osm_border_linestring_gen10 USING gist (geometry);


CREATE OR REPLACE FUNCTION edit_name(name varchar) RETURNS text AS
$$
SELECT CASE
           WHEN POSITION(' at ' IN name) > 0
               THEN replace(SUBSTRING(name, POSITION(' at ' IN name) + 4), ' ', '')
           ELSE replace(replace(name, ' ', ''), 'Extentof', '')
           END;
$$ LANGUAGE SQL IMMUTABLE
                -- STRICT
                PARALLEL SAFE
                ;


-- etldoc: ne_110m_admin_0_boundary_lines_land  -> boundary_z0
CREATE OR REPLACE VIEW boundary_z0 AS
(
SELECT geometry,
       2 AS admin_level,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN TRUE ELSE FALSE END) AS disputed,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN 'ne110m_' || ogc_fid ELSE NULL END) AS disputed_name,
       NULL::text AS claimed_by,
       FALSE AS maritime
FROM ne_110m_admin_0_boundary_lines_land
    );

-- etldoc: ne_50m_admin_0_boundary_lines_land  -> boundary_z1
-- etldoc: ne_50m_admin_1_states_provinces_lines -> boundary_z1
-- etldoc: osm_border_disp_linestring_gen11 -> boundary_z1
CREATE OR REPLACE VIEW boundary_z1 AS
(
SELECT geometry,
       2 AS admin_level,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN TRUE ELSE FALSE END) AS disputed,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN 'ne50m_' || ogc_fid ELSE NULL END) AS disputed_name,
       NULL AS claimed_by,
       FALSE AS maritime
FROM ne_50m_admin_0_boundary_lines_land
UNION ALL
SELECT geometry,
       4 AS admin_level,
       FALSE AS disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       FALSE AS maritime
FROM ne_50m_admin_1_states_provinces_lines
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen11
    );


-- etldoc: ne_50m_admin_0_boundary_lines_land -> boundary_z3
-- etldoc: ne_50m_admin_1_states_provinces_lines -> boundary_z3
-- etldoc: osm_border_disp_linestring_gen11 -> boundary_z3
CREATE OR REPLACE VIEW boundary_z3 AS
(
SELECT geometry,
       2 AS admin_level,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN TRUE ELSE FALSE END) AS disputed,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN 'ne50m_' || ogc_fid ELSE NULL END) AS disputed_name,
       NULL AS claimed_by,
       FALSE AS maritime
FROM ne_50m_admin_0_boundary_lines_land
UNION ALL
SELECT geometry,
       4 AS admin_level,
       FALSE AS disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       FALSE AS maritime
FROM ne_50m_admin_1_states_provinces_lines
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen11
    );


-- etldoc: ne_10m_admin_0_boundary_lines_land -> boundary_z4
-- etldoc: ne_10m_admin_1_states_provinces_lines -> boundary_z4
-- etldoc: osm_border_linestring_gen10 -> boundary_z4
-- etldoc: osm_border_disp_linestring_gen10 -> boundary_z4
CREATE OR REPLACE VIEW boundary_z4 AS
(
SELECT geometry,
       2 AS admin_level,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN TRUE ELSE FALSE END) AS disputed,
       (CASE WHEN featurecla LIKE 'Disputed%' THEN 'ne10m_' || ogc_fid ELSE NULL END) AS disputed_name,
       NULL AS claimed_by,
       FALSE AS maritime
FROM ne_10m_admin_0_boundary_lines_land
WHERE featurecla <> 'Lease limit'
UNION ALL
SELECT geometry,
       4 AS admin_level,
       FALSE AS disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       FALSE AS maritime
FROM ne_10m_admin_1_states_provinces_lines
WHERE min_zoom <= 5
UNION ALL
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen10
WHERE maritime = TRUE
  AND admin_level <= 2
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen10
    );

-- etldoc: osm_border_linestring_gen9 -> boundary_z5
-- etldoc: osm_border_disp_linestring_gen9 -> boundary_z5
CREATE OR REPLACE VIEW boundary_z5 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen9
WHERE admin_level <= 4
  AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen9)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen9
    );

-- etldoc: osm_border_linestring_gen8 -> boundary_z6
-- etldoc: osm_border_disp_linestring_gen8 -> boundary_z6
CREATE OR REPLACE VIEW boundary_z6 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen8
WHERE admin_level <= 4
  AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen8)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen8
    );

-- etldoc: osm_border_linestring_gen7 -> boundary_z7
-- etldoc: osm_border_disp_linestring_gen7 -> boundary_z7
CREATE OR REPLACE VIEW boundary_z7 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen7
WHERE admin_level <= 6
  AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen7)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen7
    );

-- etldoc: osm_border_linestring_gen6 -> boundary_z8
-- etldoc: osm_border_disp_linestring_gen6 -> boundary_z8
CREATE OR REPLACE VIEW boundary_z8 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen6
WHERE admin_level <= 6
  AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen6)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen6
    );

-- etldoc: osm_border_linestring_gen5 -> boundary_z9
-- etldoc: osm_border_disp_linestring_gen5 -> boundary_z9
CREATE OR REPLACE VIEW boundary_z9 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen5
WHERE admin_level <= 6
  AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen5)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen5
    );

-- etldoc: osm_border_linestring_gen4 -> boundary_z10
-- etldoc: osm_border_disp_linestring_gen4 -> boundary_z10
CREATE OR REPLACE VIEW boundary_z10 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen4
WHERE admin_level <= 6
  AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen4)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen4
    );

-- etldoc: osm_border_linestring_gen3 -> boundary_z11
-- etldoc: osm_border_disp_linestring_gen3 -> boundary_z11
CREATE OR REPLACE VIEW boundary_z11 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen3
WHERE admin_level <= 8
  AND osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen3)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen3
    );

-- etldoc: osm_border_linestring_gen2 -> boundary_z12
-- etldoc: osm_border_disp_linestring_gen2 -> boundary_z12
CREATE OR REPLACE VIEW boundary_z12 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen2
WHERE osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen2)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen2
    );

-- etldoc: osm_border_linestring_gen1 -> boundary_z13
-- etldoc: osm_border_disp_linestring_gen1 -> boundary_z13
CREATE OR REPLACE VIEW boundary_z13 AS
(
SELECT geometry,
       admin_level,
       disputed,
       NULL AS disputed_name,
       NULL AS claimed_by,
       maritime
FROM osm_border_linestring_gen1
WHERE osm_id NOT IN (SELECT DISTINCT osm_id FROM osm_border_disp_linestring_gen1)
UNION ALL
SELECT geometry,
       admin_level,
       TRUE AS disputed,
       edit_name(name) AS disputed_name,
       claimed_by,
       maritime
FROM osm_border_disp_linestring_gen1
    );

-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1_2> z1_2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]
CREATE OR REPLACE FUNCTION layer_boundary(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                geometry      geometry,
                admin_level   int,
                disputed      int,
                disputed_name text,
                claimed_by    text,
                maritime      int
            )
AS
$$
SELECT geometry, admin_level, disputed::int, disputed_name, claimed_by, maritime::int
FROM (
         -- etldoc: boundary_z0 ->  layer_boundary:z0
         SELECT *
         FROM boundary_z0
         WHERE geometry && bbox
           AND zoom_level = 0
         UNION ALL
         -- etldoc: boundary_z1 ->  layer_boundary:z1_2
         SELECT *
         FROM boundary_z1
         WHERE geometry && bbox
           AND zoom_level BETWEEN 1 AND 2
         UNION ALL
         -- etldoc: boundary_z3 ->  layer_boundary:z3
         SELECT *
         FROM boundary_z3
         WHERE geometry && bbox
           AND zoom_level = 3
         UNION ALL
         -- etldoc: boundary_z4 ->  layer_boundary:z4
         SELECT *
         FROM boundary_z4
         WHERE geometry && bbox
           AND zoom_level = 4
         UNION ALL
         -- etldoc: boundary_z5 ->  layer_boundary:z5
         SELECT *
         FROM boundary_z5
         WHERE geometry && bbox
           AND zoom_level = 5
         UNION ALL
         -- etldoc: boundary_z6 ->  layer_boundary:z6
         SELECT *
         FROM boundary_z6
         WHERE geometry && bbox
           AND zoom_level = 6
         UNION ALL
         -- etldoc: boundary_z7 ->  layer_boundary:z7
         SELECT *
         FROM boundary_z7
         WHERE geometry && bbox
           AND zoom_level = 7
         UNION ALL
         -- etldoc: boundary_z8 ->  layer_boundary:z8
         SELECT *
         FROM boundary_z8
         WHERE geometry && bbox
           AND zoom_level = 8
         UNION ALL
         -- etldoc: boundary_z9 ->  layer_boundary:z9
         SELECT *
         FROM boundary_z9
         WHERE geometry && bbox
           AND zoom_level = 9
         UNION ALL
         -- etldoc: boundary_z10 ->  layer_boundary:z10
         SELECT *
         FROM boundary_z10
         WHERE geometry && bbox
           AND zoom_level = 10
         UNION ALL
         -- etldoc: boundary_z11 ->  layer_boundary:z11
         SELECT *
         FROM boundary_z11
         WHERE geometry && bbox
           AND zoom_level = 11
         UNION ALL
         -- etldoc: boundary_z12 ->  layer_boundary:z12
         SELECT *
         FROM boundary_z12
         WHERE geometry && bbox
           AND zoom_level = 12
         UNION ALL
         -- etldoc: boundary_z13 -> layer_boundary:z13
         SELECT *
         FROM boundary_z13
         WHERE geometry && bbox
           AND zoom_level >= 13
     ) AS zoom_levels;
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
