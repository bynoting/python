if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_alarm_action_config]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_alarm_action_config]
GO

CREATE TABLE [dbo].[am_alarm_action_config] (
	[guid] [guid] NOT NULL ,
	[alarm_type] [int] NOT NULL ,
	[process_order] [int] NULL ,
	[action_guid] [guid] NOT NULL ,
	[data_create_user] [user_account] NULL ,
	[data_create_time] [data_create_time] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[am_alarm_action_config] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_alarm_action_config] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 
GO

setuser
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_alarm_action_config].[action_guid]'
GO

EXEC sp_bindefault N'[dbo].[now]', N'[am_alarm_action_config].[data_create_time]'
GO

EXEC sp_bindefault N'[dbo].[system_account]', N'[am_alarm_action_config].[data_create_user]'
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_alarm_action_config].[guid]'
GO

setuser
GO

truncate table dbo.am_alarm_action_config
go


