if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_plan_log]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_plan_log] (
		[guid] [guid] NOT NULL ,
		[plan_guid] [guid] NOT NULL ,
		[plan_x_guid] [guid] NOT NULL ,
		[plan_type] [plan_type] NOT NULL ,
		[state] [task_state] NOT NULL ,
		[service_guid] [guid] NULL ,
		[begin_time] [datetime] NOT NULL ,
		[end_time] [datetime] NULL ,
		[message] [nvarchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
		[data_create_user] [user_account] NULL ,
		[data_create_time] [data_create_time] NOT NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_plan_log] WITH NOCHECK ADD 
		CONSTRAINT [PK_am_plan_log] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	CREATE  INDEX [idx_am_plan_log_plan_x_guid] ON [dbo].[am_plan_log]([plan_x_guid]) ON [PRIMARY]
	CREATE  INDEX [idx_am_plan_log_plan_guid] ON [dbo].[am_plan_log]([plan_guid]) ON [PRIMARY]

	EXEC sp_bindefault N'[dbo].[now]', N'[am_plan_log].[data_create_time]'
	EXEC sp_bindefault N'[dbo].[now]', N'[am_plan_log].[begin_time]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_plan_log].[data_create_user]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_log].[guid]'
	EXEC sp_bindrule N'[dbo].[R_plan_type]', N'[am_plan_log].[plan_type]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_plan_log].[plan_type]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_log].[plan_x_guid]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_log].[service_guid]'
	EXEC sp_bindrule N'[dbo].[R_task_state]', N'[am_plan_log].[state]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_plan_log].[state]'
	
end
GO

