-- create.sql
-- Licensed under the MIT license.

drop table if exists athlete_event CASCADE;
drop table if exists noc_region;

create table noc_region (
	noc varchar(10) primary key, 
	region text,
	note text
);

create table athlete_event (
    athlete_event_id serial primary key,
	id integer, 
	"name" text,
	sex varchar(1),  
	age integer,
	height numeric,
	"weight" numeric,
	team text, 
	noc varchar(10),
	games text, 
	"year" integer, 
	season varchar(10),
	city text,
	sport text,
	"event" text,
	medal text
);

copy noc_region
from "data/noc_regions.csv"
with csv null as 'NA' header
;

copy athlete_event (id, "name", sex, age, height, "weight", team, noc, games, "year", season, city, sport, "event", medal)
from "data/athlete_events.csv"
with csv null as 'NA' header
;
