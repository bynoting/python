if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_plan]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_plan] (
		[guid] [guid] NOT NULL ,
		[id] [int] IDENTITY (1, 1) NOT NULL ,
		[name] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NOT NULL ,
		[plan_type] [plan_type] NOT NULL ,
		[task_type] [plan_task_type] NOT NULL ,
		[is_valid] [bool] NOT NULL ,
    [begin_datetime] [datetime] NOT NULL ,
    [end_datetime] [datetime] NOT NULL ,
    [delta_seconds] AS (datediff(second,[begin_datetime],[end_datetime])) ,
    [begin_time] AS (convert(varchar,[begin_datetime],8)) ,
    [begin_weekday] AS (datepart(weekday,[begin_datetime])) ,
    [begin_day] AS (datepart(day,[begin_datetime])) ,
    [end_time] AS (convert(varchar,[end_datetime],8)) ,
    [end_weekday] AS (datepart(weekday,[end_datetime])) ,
    [end_day] AS (datepart(day,[end_datetime])) ,
    [data_create_user] [user_account] NOT NULL ,
    [data_create_time] [data_create_time] NOT NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_plan] ADD 
		CONSTRAINT [PK_AM_RECORD_PLAN] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	EXEC sp_bindefault N'[dbo].[now]', N'[am_plan].[data_create_time]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_plan].[data_create_user]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan].[guid]'
	EXEC sp_bindefault N'[dbo].[one_or_true]', N'[am_plan].[is_valid]'
	EXEC sp_bindrule N'[dbo].[R_plan_task_type]', N'[am_plan].[task_type]'
	EXEC sp_bindrule N'[dbo].[R_plan_type]', N'[am_plan].[plan_type]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_plan].[plan_type]'
  EXEC sp_bindrule N'[dbo].[R_plan_task_type]', N'[am_plan].[task_type]'		
		
	CREATE  INDEX [IX_am_plan_endtime] ON [dbo].[am_plan]([end_datetime]) ON [PRIMARY]
end

GO
