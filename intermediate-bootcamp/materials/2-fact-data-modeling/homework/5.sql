
--A DDL for hosts_cumulated table
--a host_activity_datelist which logs to see which dates each host is experiencing any activity

create table hosts_cumulated  (
	host text,
	host_activity_datelist date[],
	date date,
	primary key (host, date)
)