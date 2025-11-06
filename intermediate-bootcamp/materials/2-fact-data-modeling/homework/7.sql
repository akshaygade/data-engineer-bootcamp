
--A monthly, reduced fact table DDL host_activity_reduced
--
--month
--host
--hit_array - think COUNT(1)
--unique_visitors array - think COUNT(DISTINCT user_id)
drop table host_activity_reduced;

CREATE TABLE host_activity_reduced (
	host TEXT,
	month_start DATE,
	hit_array INTEGER[],
	unique_visitors_array INTEGER[],
	PRIMARY KEY (host, month_start)
)
	