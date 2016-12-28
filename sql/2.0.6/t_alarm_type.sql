-----------------------------------------------------------------------------------------
-- 加入一种报警类型： 门禁报警
-----------------------------------------------------------------------------------------
delete t_alarm_type where code = 8
go

insert into t_alarm_type (name_cn,name,code,has_channel) values ('门禁报警','门禁报警',8,1)
go

delete t_alarm_type where code = 9
go

insert into t_alarm_type (name_cn,name,code,has_channel) values ('门锁报警','门锁报警',9,1)
go