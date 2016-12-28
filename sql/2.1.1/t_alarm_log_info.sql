if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_alarm_log_info]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_alarm_log_info]
GO

CREATE TABLE [dbo].[t_alarm_log_info] (
	[guid] [guid] NULL ,
	[alarm_id] [int] NULL ,
	[info_key] [nvarchar] (40) COLLATE Chinese_PRC_CI_AS NULL ,
	[info_value] [nvarchar] (255) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

setuser
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[t_alarm_log_info].[guid]'
GO

setuser
GO
