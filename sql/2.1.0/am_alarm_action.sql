if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_alarm_action]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_alarm_action]
GO

CREATE TABLE [dbo].[am_alarm_action] (
	[guid] [guid] NOT NULL ,
	[name] [nvarchar] (32) COLLATE Chinese_PRC_CI_AS NULL ,
	[name_cn] [chinese_name] NULL ,
	[assembly_type] [nvarchar] (192) COLLATE Chinese_PRC_CI_AS NULL ,
	[remark] [remark] NULL ,
	[data_create_user] [user_account] NULL ,
	[data_create_time] [data_create_time] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[am_alarm_action] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_alarm_action] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 
GO
go

setuser
GO

EXEC sp_bindefault N'[dbo].[now]', N'[am_alarm_action].[data_create_time]'
GO

EXEC sp_bindefault N'[dbo].[system_account]', N'[am_alarm_action].[data_create_user]'
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_alarm_action].[guid]'
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[am_alarm_action].[name]'
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[am_alarm_action].[name_cn]'
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[am_alarm_action].[remark]'
GO

setuser
GO

truncate table am_alarm_action
go

