\set VERBOSITY terse

SET search_path = 'public';
CREATE EXTENSION pg_pathman;
CREATE SCHEMA param_upd_del;


CREATE TABLE param_upd_del.test(key INT4 NOT NULL, val INT4);
SELECT create_hash_partitions('param_upd_del.test', 'key', 10);
INSERT INTO param_upd_del.test SELECT i, i FROM generate_series(1, 1000) i;

ANALYZE;


PREPARE upd(INT4) AS UPDATE param_upd_del.test SET val = val + 1 WHERE key = $1;
EXPLAIN (COSTS OFF) EXECUTE upd(10);
EXPLAIN (COSTS OFF) EXECUTE upd(10);
EXPLAIN (COSTS OFF) EXECUTE upd(10);
EXPLAIN (COSTS OFF) EXECUTE upd(10);
EXPLAIN (COSTS OFF) EXECUTE upd(10);
EXPLAIN (COSTS OFF) EXECUTE upd(10);
EXPLAIN (COSTS OFF) EXECUTE upd(11);
DEALLOCATE upd;


PREPARE upd(INT4) AS UPDATE param_upd_del.test SET val = val + 1 WHERE key = ($1 + 3) * 2;
EXPLAIN (COSTS OFF) EXECUTE upd(5);
EXPLAIN (COSTS OFF) EXECUTE upd(5);
EXPLAIN (COSTS OFF) EXECUTE upd(5);
EXPLAIN (COSTS OFF) EXECUTE upd(5);
EXPLAIN (COSTS OFF) EXECUTE upd(5);
EXPLAIN (COSTS OFF) EXECUTE upd(5);
EXPLAIN (COSTS OFF) EXECUTE upd(6);
DEALLOCATE upd;


PREPARE del(INT4) AS DELETE FROM param_upd_del.test WHERE key = $1;
EXPLAIN (COSTS OFF) EXECUTE del(10);
EXPLAIN (COSTS OFF) EXECUTE del(10);
EXPLAIN (COSTS OFF) EXECUTE del(10);
EXPLAIN (COSTS OFF) EXECUTE del(10);
EXPLAIN (COSTS OFF) EXECUTE del(10);
EXPLAIN (COSTS OFF) EXECUTE del(10);
EXPLAIN (COSTS OFF) EXECUTE del(11);
DEALLOCATE del;


DROP SCHEMA param_upd_del CASCADE;
DROP EXTENSION pg_pathman;
