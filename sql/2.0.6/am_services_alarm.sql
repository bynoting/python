if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_temp_recordServerIP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_temp_recordServerIP]
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_services_alarm]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_services_alarm] (
		[guid] [guid] NOT NULL ,
		[service_guid] [guid] NOT NULL ,
		[service_type] [gt_service_type] NOT NULL ,
		[alarm_key] [nvarchar] (36) COLLATE Chinese_PRC_CI_AS NOT NULL ,
		[data_create_time] [data_create_time] NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_services_alarm] WITH NOCHECK ADD 
		CONSTRAINT [PK_am_services_alarm] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	CREATE  INDEX [IX_am_services_alarm_key] ON [dbo].[am_services_alarm]([alarm_key] DESC ) ON [PRIMARY]

	EXEC sp_bindefault N'[dbo].[now]', N'[am_services_alarm].[data_create_time]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_services_alarm].[guid]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_services_alarm].[service_guid]'
	EXEC sp_bindrule N'[dbo].[R_gt_service_type]', N'[am_services_alarm].[service_type]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_services_alarm].[service_type]'

end
GO