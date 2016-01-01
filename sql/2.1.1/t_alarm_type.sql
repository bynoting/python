if not exists (select id from dbo.sysobjects where id = object_id(N'[dbo].[t_alarm_type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	return

if not exists( select id from dbo.syscolumns s where name ='virtual_zone_id'
	and id = object_id(N't_alarm_type'))
begin
	ALTER TABLE [dbo].[t_alarm_type] ADD [virtual_zone_id] [int] NULL 
end

if not exists( select id from dbo.syscolumns s where name ='is_show_alarm'
	and id = object_id(N't_alarm_type'))
begin
	ALTER TABLE [dbo].[t_alarm_type] ADD [is_show_alarm] [bit] NULL;
end

go 


