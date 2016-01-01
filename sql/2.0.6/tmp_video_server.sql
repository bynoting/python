------------------------------------------------------------------------------------------------------
-- …æ≥˝¡Ÿ ±±Ì(20071107)
------------------------------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_video_server]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tmp_video_server]
GO