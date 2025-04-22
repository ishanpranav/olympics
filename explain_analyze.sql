-- explain_analyze.sql
-- Licensed under the MIT license.

-- 1. Drop an existing index:

drop index if exists athlete_event_name_idx;

-- 2. Write a simple query:

select * from athlete_event
where "name" = 'Michael Fred Phelps, II'
;

-- 3. Use `EXPLAIN ANALYZE`:

explain analyze
select * from athlete_event
where "name" = 'Michael Fred Phelps, II'
;

--   Gather  (cost=1000.00..8213.36 rows=3 width=137) (actual time=10.807..20.110 rows=30 loops=1)
--    Workers Planned: 2
--    Workers Launched: 2
--    ->  Parallel Seq Scan on athlete_event  (cost=0.00..7213.06 rows=1 width=137) (actual time=6.904..8.628 rows=10 loops=3)
--          Filter: (name = 'Michael Fred Phelps, II'::text)
--          Rows Removed by Filter: 90362
--  Planning Time: 0.321 ms
--  Execution Time: 20.138 ms
-- (8 rows)

-- 4. Add an index:

create index athlete_event_name_idx on athlete_event("name");

-- 5. Verifying improved performance:

explain analyze
select * from athlete_event
where "name" = 'Michael Fred Phelps, II'
;

--  Index Scan using athlete_event_name_idx on athlete_event  (cost=0.42..16.42 rows=3 width=137) (actual time=0.227..0.232 rows=30 loops=1)
--    Index Cond: (name = 'Michael Fred Phelps, II'::text)
--  Planning Time: 1.375 ms
--  Execution Time: 0.330 ms
-- (4 rows)
