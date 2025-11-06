
with last_year_scd as (
		select * 
		from actors_history_scd 
		where current_year = 1976
		and end_year = 1976
),
	historical_scd as (
		select actorid,
				actor,
				quality_class,
				is_active,
				start_year,
				end_year
		from actors_history_scd 
		where current_year = 1976
		and end_year < 1976
	),
	this_year_data as (
		select * 
		from actors
		where current_year = 1977
	),
	unchanged_records as (
		select ts.actorid,
				ts.actor,
				ts.quality_class,
				ts.is_active,
				ls.start_year,
				ts.current_year as end_year
		from this_year_data ts
		join last_year_scd ls
		on ls.actorid = ts.actorid
		where ts.quality_class = ls.quality_class
		and ts.is_active = ls.is_active
	),
	changed_records as (
		select ts.actorid,
				ts.actor,
			unnest(array [
					row (
						ls.quality_class,
						ls.is_active,
						ls.start_year,
						ls.end_year
					)::scd_type_actors, 
					row (
						ts.quality_class,
						ts.is_active,
						ts.current_year,
						ts.current_year
					)::scd_type_actors
				]) as records
		from this_year_data ts
		left join last_year_scd ls
		on ls.actorid = ts.actorid
		where (ts.quality_class <> ls.quality_class
		or ts.is_active <> ls.is_active)
		or ls.actorid is null
	),
	unnested_changed_records as (
			select actorid,
					actor,
					(records::scd_type_actors).quality_class,
					(records::scd_type_actors).is_active,
					(records::scd_type_actors).start_year,
					(records::scd_type_actors).end_year
			from changed_records
	),
	new_records as (
			select ts.actorid,
					ts.actor,
					ts.quality_class,
					ts.is_active,
					ts.current_year as start_year,
					ts.current_year as end_year
			from this_year_data ts
			join last_year_scd ls
			on ts.actorid = ls.actorid
			where ls.actorid is null
			
	)
	select * from historical_scd
	
	union all 
	
	select * from unchanged_records
	
	union all
	
	select * from unnested_changed_records
	
	union all
	
	select * from new_records;