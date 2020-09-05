CREATE OR REPLACE FUNCTION island_rank(area real) RETURNS int AS
$$
SELECT CASE
           WHEN area < 10000000 THEN 6
           WHEN area BETWEEN 1000000 AND 15000000 THEN 5
           WHEN area BETWEEN 15000000 AND 40000000 THEN 4
           WHEN area > 40000000 THEN 3
           ELSE 7
           END;
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;
