/** drop object unused */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_default_day_collect]') and OBJECTPROPERTY(id, N'IsView') = 1)
begin
	drop view v_default_day_collect
end
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_details_day_collect]') and OBJECTPROPERTY(id, N'IsView') = 1)
begin
	drop view v_details_day_collect
end
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_DefaultDayCollect]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	drop table [dbo].[t_DefaultDayCollect]
end
GO

/** create table am_device_fault */
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_device_fault]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_device_fault] (
	[guid] [guid] NOT NULL ,
	[video_server_sn] [char] (16) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[fault_type] [varchar] (4) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[report_count] [int] NULL ,
	[last_report_time] [datetime] NOT NULL ,
	[is_process] [bool] NULL ,
	[process_user] [user_account] NULL ,	
	[data_create_time] [datetime] NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_device_fault] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_device_fault] PRIMARY KEY  CLUSTERED 
	(
	[guid]
	)  ON [PRIMARY] 

	ALTER TABLE [dbo].[am_device_fault] ADD 
	CONSTRAINT [DF_am_device_fault_state] DEFAULT (1) FOR [report_count],
	CONSTRAINT [DF_am_device_fault_data_create_time] DEFAULT (getdate()) FOR [data_create_time]

	CREATE  INDEX [IX_am_device_fault_vs_sn] ON [dbo].[am_device_fault]([video_server_sn]) ON [PRIMARY]

	EXEC sp_bindefault N'[dbo].[guid]', N'[am_device_fault].[guid]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_device_fault].[is_process]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_device_fault].[process_user]'

end
GO

/** creat table am_device_fault_his */
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_device_fault_his]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_device_fault_his] (
		[guid] [guid] NOT NULL ,
		[video_server_sn] [char] (16) COLLATE Chinese_PRC_CI_AS NOT NULL ,
		[fault_type] [varchar] (4) COLLATE Chinese_PRC_CI_AS NOT NULL ,
		[report_count] [int] NULL ,
		[last_report_time] [datetime] NOT NULL ,
		[is_process] [bool] NULL ,
		[process_user] [user_account] NULL ,		
		[data_create_time] [datetime] NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_device_fault_his] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_device_fault_his] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 

	ALTER TABLE [dbo].[am_device_fault_his] ADD 
	CONSTRAINT [DF_am_device_fault_log_his_state] DEFAULT (1) FOR [report_count],
	CONSTRAINT [DF_am_device_fault_log_his_data_create_time] DEFAULT (getdate()) FOR [data_create_time]

	CREATE  INDEX [IX_am_device_fault_log_his] ON [dbo].[am_device_fault_his]([video_server_sn]) ON [PRIMARY]

	EXEC sp_bindefault N'[dbo].[guid]', N'[am_device_fault_his].[guid]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_device_fault_his].[is_process]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_device_fault_his].[process_user]'
end
GO
setuser
GO


