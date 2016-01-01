if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_video_encoder]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_video_encoder]

go