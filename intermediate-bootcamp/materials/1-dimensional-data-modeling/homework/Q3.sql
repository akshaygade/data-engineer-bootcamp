
-- 3. DDL for actors_history_scd table: Create a DDL for an actors_history_scd table with the following features:

drop table actors_history_scd;

create table actors_history_scd ( 
	actorid text,
	actor text,
	quality_class quality_class,
	is_active boolean,
	start_year integer,
	end_year integer,
	current_year integer,
	primary key (actor, start_year)
);
