if not exists( select * from dbo.syscolumns where name ='is_alarm' and id = object_id(N'[dbo].[t_input_port]'))
begin
	ALTER TABLE [dbo].[t_input_port] ADD [is_alarm] [bool] NULL
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[t_input_port].[is_alarm]'
end
go