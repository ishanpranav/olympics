-- explain_analyze.sql
-- Licensed under the MIT license.

-- 1. Drop an existing index:

drop index if exists athlete_event_name_idx;

-- 2. Write a simple query:

select * from athlete_event
where "name" ilike '%Michael Fred Phelps, II%'
;

-- 3. Use `EXPLAIN ANALYZE`:

explain analyze
select * from athlete_event
where "name" ilike '%Michael Fred Phelps, II%'
;

--  Gather  (cost=1000.00..8215.76 rows=27 width=137) (actual time=58.644..89.019 rows=30 loops=1)
--    Workers Planned: 2
--    Workers Launched: 2
--    ->  Parallel Seq Scan on athlete_event  (cost=0.00..7213.06 rows=11 width=137) (actual time=62.524..79.036 rows=10 loops=3)
--          Filter: (name ~~* '%Michael Fred Phelps, II%'::text)
--          Rows Removed by Filter: 90362
--  Planning Time: 0.226 ms
--  Execution Time: 89.180 ms
-- (8 rows)

-- 4. Add an index:

create index athlete_event_name_idx on athlete_event("name");
