if not exists( select 1 from dbo.syscolumns s where name ='transmit_guid' and id = object_id(N't_online_user'))
begin
	alter table t_online_user add transmit_guid guid  null
	execute sp_bindefault N'[dbo].[now]', N't_online_user.login_time'
end
go

