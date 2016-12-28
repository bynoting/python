if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_notice_read_user]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_notice_read_user]