
--A cumulative query to generate device_activity_datelist from events
insert into user_devices_cumulated
with yesterday as (
	select 
		* 
	from user_devices_cumulated
	where date = DATE('2023-01-30')
),
today as (
	select 
		cast(e.device_id as text) as device_id, 
		d.browser_type,
		date(cast(event_time as timestamp)) as device_active
	from events e
	left join devices d  
	on e.device_id = d.device_id
	where date(cast(event_time as timestamp)) = DATE('2023-01-31')
	and e.device_id is not null
	group by e.device_id, browser_type,date(cast(event_time as timestamp))
)
select 
	coalesce(t.device_id, y.device_id) as device_id,
	coalesce(t.browser_type, y.browser_type) as browser_type,
	case when y.device_activity_datelist is null 
		then array[t.device_active] 
		when t.device_active is null then y.device_activity_datelist
		else array[t.device_active] || y.device_activity_datelist 
		end
		as device_activity_datelist,
	coalesce(t.device_active , y.date + interval '1 day') as date
from today t
	full outer join yesterday y 
	on t.device_id= y.device_id
;

select * from user_devices_cumulated uc
order by date desc
;