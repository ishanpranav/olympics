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
left join noc_region on athlete_event.noc = noc_region.noc
where athlete_event.medal is not null
;

--    This view joins the two tables and supplies a friendly region name.

create or replace view friendly_region as
select
    athlete_event."event",
    athlete_event.team,
    athlete_event.noc,
    athlete_event.medal,
    coalesce(
        noc_region.region,
        case
            when athlete_event.noc = 'SGP' then 'Singapore'
            when athlete_event.noc = 'ROT' then 'Refugee'
            when athlete_event.noc = 'TUV' then 'Tuvalu'
            when athlete_event.noc = 'UNK' then 'Unknown'
            else athlete_event.team
        end
    ) as region,
    athlete_event.sport,
    athlete_event.year
from athlete_event
left join noc_region on athlete_event.noc = noc_region.noc
;

-- 2. Use the window function `rank()`
--     This query show the top 3 ranked regions
--     for each fencing 🤺 event based  on the number of total gold medals 🥇
--     that region had for that fencing event.

with
    counts as (
        select 
            "event",
            region,
            count(*) as golds
        from friendly_region
        where sport = 'Fencing' and medal = 'Gold'
        group by "event", region
    ),
    ranking as (
        select
            "event",
            region,
            golds,
            rank() over (partition by "event" order by golds desc) as rank
        from counts
    )
select region, "event", golds, rank
from ranking
where rank <= 3
order by "event", rank
;

-- 3. Using aggregate functions as window functions
--     Shows the rolling sum of medals per region, per year, and per medal type.

with counts as (
    select
        region,
        "year",
        medal,
        count(*) as c
    from friendly_region
    where medal is not null
    group by region, "year", medal
)
select 
    region,
    "year",
    medal,
    c,
    sum(c) over (partition by region, medal order by "year") as "sum"
from counts
order by region, "year", medal
;

-- 4. Use the window function, `lag()`
--     Shows the height of every gold medalist for pole valut events, along with
--     the height of the gold medalist for that same pole value event in the
--     previous year.

select
    "event",
    "year",
    height,
    lag(height) over (partition by "event" order by "year") as previous_height
from athlete_event
where "event" ilike '%Pole Vault%' and medal = 'Gold'
order by "event", "year"
;
