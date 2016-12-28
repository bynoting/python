if exists( select 1 from dbo.syscolumns s where name ='zone_id'
	and id = object_id(N't_alarm_linkage'))
begin
	alter table t_alarm_linkage drop column zone_id
end

alter table t_alarm_linkage add zone_id as ([dbo].[f_cacl_zone_id_linkage]([linkage_port], [linkage_type]))