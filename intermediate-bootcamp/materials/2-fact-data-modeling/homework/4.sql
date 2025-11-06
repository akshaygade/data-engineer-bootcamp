
--A datelist_int generation query. Convert the device_activity_datelist column into a datelist_int column

with devices as (
	select * from user_devices_cumulated
	where date = date('2023-01-31')
),
series as (
	select 
		* 
	from generate_series(date('2023-01-01'), date('2023-01-31') , interval '1 day' )
	as series_date
),
device_activity as (
select 
	case when
		d.device_activity_datelist @> array[date(series_date)]
	then cast( pow(2, 32 - (date - date(series_date)) ) as  bigint)
	else 0 
	end as datelist_int,
	*
from devices d
cross join series s
)
select
	device_id,
	cast( cast(sum(datelist_int) as bigint) as bit(32)) as datelist_int,
	bit_count(cast( cast(sum(datelist_int) as bigint) as bit(32))) datelist_bit_count
from device_activity
group by 1;
