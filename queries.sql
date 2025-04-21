-- queries.sql
-- Licensed under the MIT license.

-- 1. Write a view
--    This view automatically joins the two tables based on `noc`, only shows
--    rows where a medal exists, and groups to count medals.

create or replace view medal_summary as
select
    athlete_event.athlete_event_id as athlete_event_id,
    athlete_event."name",
    athlete_event.sex,
    athlete_event.age,
    athlete_event.height,
    athlete_event."weight",
    athlete_event.team,
    athlete_event.noc,
    noc_region.region,
    noc_region.note,
    athlete_event.games,
    athlete_event."year",
    athlete_event.season,
    athlete_event.city,
    athlete_event.sport,
    athlete_event."event",
    athlete_event.medal
from athlete_event
join noc_region on athlete_event.noc = noc_region.noc
where athlete_event.medal is not null
;
