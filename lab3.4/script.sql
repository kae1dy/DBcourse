-- Индекс №1. Массивы.
EXPLAIN SELECT *
FROM archeology.archs
WHERE special @> '{"Field", "Marine", "Archaeozoologist"}';
-- "Seq Scan on archs  (cost=0.00..27884.00 rows=63951 width=90)"
-- "  Filter: (special @> '{Field,Marine,Archaeozoologist}'::spec[])"

EXPLAIN ANALYZE SELECT *
FROM archeology.archs
WHERE special @> '{"Field", "Marine", "Archaeozoologist"}';
-- "Seq Scan on archs  (cost=0.00..27884.00 rows=63951 width=90) (actual time=0.016..141.685 rows=33289 loops=1)"
-- "  Filter: (special @> '{Field,Marine,Archaeozoologist}'::spec[])"
-- "  Rows Removed by Filter: 966711"
-- "Planning Time: 0.076 ms"
-- "Execution Time: 142.550 ms"

DROP INDEX IF EXISTS archeology.special_array_idx;
CREATE INDEX special_array_idx ON archeology.archs USING GIN(special);

EXPLAIN SELECT *
FROM archeology.archs
WHERE special @> '{"Field", "Marine", "Archaeozoologist"}';
-- "Bitmap Heap Scan on archs  (cost=1029.55..17212.94 rows=63951 width=90)"
-- "  Recheck Cond: (special @> '{Field,Marine,Archaeozoologist}'::spec[])"
-- "  ->  Bitmap Index Scan on special_array_idx  (cost=0.00..1013.56 rows=63951 width=0)"
-- "        Index Cond: (special @> '{Field,Marine,Archaeozoologist}'::spec[])"

EXPLAIN ANALYZE SELECT *
FROM archeology.archs
WHERE special @> '{"Field", "Marine", "Archaeozoologist"}';
-- "Bitmap Heap Scan on archs  (cost=1029.55..17212.94 rows=63951 width=90) (actual time=43.962..54.627 rows=33289 loops=1)"
-- "  Recheck Cond: (special @> '{Field,Marine,Archaeozoologist}'::spec[])"
-- "  Heap Blocks: exact=13681"
-- "  ->  Bitmap Index Scan on special_array_idx  (cost=0.00..1013.56 rows=63951 width=0) (actual time=42.792..42.792 rows=33289 loops=1)"
-- "        Index Cond: (special @> '{Field,Marine,Archaeozoologist}'::spec[])"
-- "Planning Time: 0.095 ms"
-- "Execution Time: 55.426 ms"


-- Индекс 2. Полнотекстовый поиск.
SET enable_seqscan TO ON;

EXPLAIN SELECT *
FROM archeology.archs
WHERE fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd');
-- "Gather  (cost=1000.00..151768.77 rows=4 width=136)"
-- "  Workers Planned: 2"
-- "  ->  Parallel Seq Scan on archs  (cost=0.00..150768.38 rows=2 width=136)"
-- "        Filter: (fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd'::text))"
-- "JIT:"
-- "  Functions: 2"
-- "  Options: Inlining false, Optimization false, Expressions true, Deforming true"

EXPLAIN ANALYZE SELECT *
FROM archeology.archs
WHERE fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd');
-- "Gather  (cost=1000.00..151768.77 rows=4 width=136) (actual time=633.861..1129.568 rows=6 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Seq Scan on archs  (cost=0.00..150768.38 rows=2 width=136) (actual time=365.395..1014.449 rows=2 loops=3)"
-- "        Filter: (fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd'::text))"
-- "        Rows Removed by Filter: 333331"
-- "Planning Time: 0.230 ms"
-- "JIT:"
-- "  Functions: 6"
-- "  Options: Inlining false, Optimization false, Expressions true, Deforming true"
-- "  Timing: Generation 2.259 ms, Inlining 0.000 ms, Optimization 2.643 ms, Emission 22.303 ms, Total 27.205 ms"
-- "Execution Time: 1130.047 ms"

DROP INDEX IF EXISTS archeology.fullname_idx;
ALTER TABLE archeology.archs ADD COLUMN fullname_index_col tsvector;
UPDATE archeology.archs SET fullname_index_col = to_tsvector('english', last_name || ' ' || first_name || ' ' || coalesce(father_name,''));
CREATE INDEX fullname_idx ON archeology.archs USING GIN (fullname_index_col);

EXPLAIN SELECT *
FROM archeology.archs
WHERE fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd');
-- "QUERY PLAN"
-- "Bitmap Heap Scan on archs  (cost=38.69..55.63 rows=4 width=136)"
-- "  Recheck Cond: (fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd'::text))"
-- "  ->  Bitmap Index Scan on fullname_idx  (cost=0.00..38.69 rows=4 width=0)"
-- "        Index Cond: (fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd'::text))"

EXPLAIN ANALYZE SELECT *
FROM archeology.archs
WHERE fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd');
-- "Bitmap Heap Scan on archs  (cost=38.69..55.63 rows=4 width=136) (actual time=0.476..0.535 rows=6 loops=1)"
-- "  Recheck Cond: (fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd'::text))"
-- "  Rows Removed by Index Recheck: 2"
-- "  Heap Blocks: exact=8"
-- "  ->  Bitmap Index Scan on fullname_idx  (cost=0.00..38.69 rows=4 width=0) (actual time=0.448..0.449 rows=8 loops=1)"
-- "        Index Cond: (fullname_index_col @@ to_tsquery('(Norris | Mills) <-> Todd'::text))"
-- "Planning Time: 0.230 ms"
-- "Execution Time: 0.566 ms"

-- Индекс 3. Поиск по таблицам-объединеням;
EXPLAIN SELECT last_name, first_name, father_name, find_date, find_info
FROM archeology.archs
LEFT JOIN archeology.arch_report USING (arch_id)
LEFT JOIN archeology.finds USING (report_id)
WHERE arch_id = 5 and find_date BETWEEN '2012-01-01' and '2020-01-01'
ORDER BY find_date DESC
LIMIT 10; 
-- "Nested Loop  (cost=54082.12..3383532.62 rows=263 width=146)"
-- "  ->  Index Scan using archs_pkey on archs  (cost=0.42..8.44 rows=1 width=27)"
-- "        Index Cond: (arch_id = 5)"
-- "  ->  Gather  (cost=54081.69..3383521.55 rows=263 width=135)"
-- "        Workers Planned: 2"
-- "        ->  Parallel Hash Join  (cost=53081.69..3382495.25 rows=110 width=135)"
-- "              Hash Cond: (finds.report_id = arch_report.report_id)"
-- "              ->  Parallel Seq Scan on finds  (cost=0.00..3283202.67 rows=17604072 width=135)"
-- "                    Filter: (find_date >= '2012-01-01'::date)"
-- "              ->  Parallel Hash  (cost=53081.67..53081.67 rows=2 width=16)"
-- "                    ->  Parallel Seq Scan on arch_report  (cost=0.00..53081.67 rows=2 width=16)"
-- "                          Filter: (arch_id = 5)"
-- "JIT:"
-- "  Functions: 19"
-- "  Options: Inlining true, Optimization true, Expressions true, Deforming true"
EXPLAIN ANALYZE SELECT last_name, first_name, father_name, find_date, find_info
FROM archeology.archs
LEFT JOIN archeology.arch_report USING (arch_id)
LEFT JOIN archeology.finds USING (report_id)
WHERE arch_id = 5 and find_date BETWEEN '2012-01-01' and '2020-01-01'
ORDER BY find_date DESC
LIMIT 10; 
-- "Nested Loop  (cost=54082.12..3383532.62 rows=263 width=146) (actual time=1340.956..22927.527 rows=243 loops=1)"
-- "  ->  Index Scan using archs_pkey on archs  (cost=0.42..8.44 rows=1 width=27) (actual time=0.869..1.090 rows=1 loops=1)"
-- "        Index Cond: (arch_id = 5)"
-- "  ->  Gather  (cost=54081.69..3383521.55 rows=263 width=135) (actual time=1340.071..22926.227 rows=243 loops=1)"
-- "        Workers Planned: 2"
-- "        Workers Launched: 2"
-- "        ->  Parallel Hash Join  (cost=53081.69..3382495.25 rows=110 width=135) (actual time=1432.477..22826.983 rows=81 loops=3)"
-- "              Hash Cond: (finds.report_id = arch_report.report_id)"
-- "              ->  Parallel Seq Scan on finds  (cost=0.00..3283202.67 rows=17604072 width=135) (actual time=0.439..20589.508 rows=14289448 loops=3)"
-- "                    Filter: (find_date >= '2012-01-01'::date)"
-- "                    Rows Removed by Filter: 19043885"
-- "              ->  Parallel Hash  (cost=53081.67..53081.67 rows=2 width=16) (actual time=1080.697..1080.705 rows=2 loops=3)"
-- "                    Buckets: 1024  Batches: 1  Memory Usage: 104kB"
-- "                    ->  Parallel Seq Scan on arch_report  (cost=0.00..53081.67 rows=2 width=16) (actual time=663.590..1080.463 rows=2 loops=3)"
-- "                          Filter: (arch_id = 5)"
-- "                          Rows Removed by Filter: 1666665"
-- "Planning Time: 0.269 ms"
-- "JIT:"
-- "  Functions: 49"
-- "  Options: Inlining true, Optimization true, Expressions true, Deforming true"
-- "  Timing: Generation 6.058 ms, Inlining 332.017 ms, Optimization 204.700 ms, Emission 150.351 ms, Total 693.127 ms"
-- "Execution Time: 22929.320 ms"

DROP INDEX IF EXISTS archeology.find_date_idx;
DROP INDEX IF EXISTS archeology.find_info_json_idx;
CREATE INDEX find_date_idx ON archeology.finds(find_date DESC);
CREATE INDEX find_info_json_idx ON archeology.finds USING GIN(find_info);

EXPLAIN SELECT find_date, find_info, last_name, first_name, father_name
FROM archeology.finds
JOIN archeology.arch_report USING (report_id)
JOIN archeology.archs USING (arch_id)
WHERE arch_id = 5
ORDER BY find_date DESC
LIMIT 5;
-- "Limit  (cost=1000.99..2727318.15 rows=5 width=146)"
-- "  ->  Nested Loop  (cost=1000.99..339154855.19 rows=622 width=146)"
-- "        Join Filter: (arch_report.report_id = finds.report_id)"
-- "        ->  Index Scan using find_date_idx on finds  (cost=0.57..330100764.41 rows=100000000 width=135)"
-- "        ->  Materialize  (cost=1000.42..54090.80 rows=6 width=27)"
-- "              ->  Nested Loop  (cost=1000.42..54090.77 rows=6 width=27)"
-- "                    ->  Index Scan using archs_pkey on archs  (cost=0.42..8.44 rows=1 width=27)"
-- "                          Index Cond: (arch_id = 5)"
-- "                    ->  Gather  (cost=1000.00..54082.27 rows=6 width=16)"
-- "                          Workers Planned: 2"
-- "                          ->  Parallel Seq Scan on arch_report  (cost=0.00..53081.67 rows=2 width=16)"
-- "                                Filter: (arch_id = 5)"
-- "JIT:"
-- "  Functions: 13"
-- "  Options: Inlining true, Optimization true, Expressions true, Deforming true"

EXPLAIN SELECT find_date, find_info, last_name, first_name, father_name
FROM archeology.finds
JOIN archeology.arch_report USING (report_id)
JOIN archeology.archs USING (arch_id)
WHERE find_info->>'type' = 'Other' and arch_id = 5
ORDER BY find_date DESC
LIMIT 1;
