-- Question 1
CREATE TYPE quality_class AS ENUM ('star', 'good', 'average', 'bad')

create type films as (
			film text,
			votes INTEGER,
			rating real, 
			filmid text
);

-- the DDL for the actors table
create table actors (
		actorid text,
		actor text,
		films films[],
		quality_class quality_class,
		is_active boolean,
		current_year integer,
		primary key (actorid, current_year)
);