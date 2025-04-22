-- explain_analyze.sql
-- Licensed under the MIT license.

-- 1. Drop an existing index:

drop index if exists athlete_event_name_idx;

-- 2. Write a simple query:

select * from athlete_event
where "name" ilike '%Michael Fred Phelps, II%'
;
