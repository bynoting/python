if not exists( select * from dbo.syscolumns where name ='is_mobile' and id = object_id(N'[dbo].[t_video_server]'))
begin
	ALTER TABLE [dbo].[t_video_server] ADD [is_mobile] [bool] NULL
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[t_video_server].[is_mobile]' 
end
go