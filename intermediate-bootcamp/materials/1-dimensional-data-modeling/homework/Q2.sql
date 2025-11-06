-- Question 2
--drop table actors;
insert into actors
with yesterday as (
			select * from actors 
			where current_year = 1969
),
	today as (
			select * from actor_films
			where year = 1970
	),
	average_rating as (
		select actorid,
			avg(rating) as avg_rating
		from actor_films
		group by actorid
	),
	final_data as (
select 
	coalesce (t.actorid, y.actorid) as actorid, 
	coalesce (t.actor, y.actor) as actor,
	case when y.films is null
		then array [row(
			t.film,
			t.votes,
			t.rating,
			t.filmid
		)::films]
		when t.year is not null then y.films || array [ROW(
			t.film, 
			t.votes,
			t.rating,
			t.filmid
		)::films]
		else y.films
	end as films,
	case 
		when t.year is not null then 
			case when avg_rating > 8 then 'star'
				when avg_rating > 7 then 'good'
				when avg_rating > 6 then 'average'
				else 'bad'
			end::quality_class
		else y.quality_class
	end as quality_class,
	case 
		when t.year is not null then true 
		else false 
	end as is_active,
	coalesce (t.year, y.current_year +1) as current_year,
	ROW_NUMBER() OVER (PARTITION BY COALESCE(t.actorid, y.actorid)) AS row_num
from today t 
full outer join yesterday y 
on t.actorid = y.actorid
left join average_rating avr
on avr.actorid = COALESCE(t.actorid, y.actorid)
)
SELECT 
    actorid,
    actor,
    films,
    quality_class,
    is_active,
    current_year
FROM final_data
WHERE row_num = 1; 