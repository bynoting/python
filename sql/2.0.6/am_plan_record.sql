if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_plan_record]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_plan_record] (
		[guid] [guid] NOT NULL ,
		[plan_guid] [guid] NOT NULL ,
		[record_type] [record_type] NOT NULL ,
		[video_server_sn] [video_server_sn] NOT NULL ,
		[video_channel_guid] [guid] NULL ,
		[data_create_user] [user_account] NOT NULL ,
		[data_create_time] [data_create_time] NOT NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_plan_record] WITH NOCHECK ADD 
		CONSTRAINT [PK_am_plan_record] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	EXEC sp_bindefault N'[dbo].[now]', N'[am_plan_record].[data_create_time]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_plan_record].[data_create_user]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_record].[guid]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_record].[plan_guid]'
	EXEC sp_bindrule N'[dbo].[R_record_type]', N'[am_plan_record].[record_type]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_plan_record].[record_type]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_record].[video_channel_guid]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_plan_record].[video_server_sn]'
 
  create   index idx_am_plan_record_plan_guid on am_plan_record (plan_guid ASC)
  create   index idx_am_plan_record_video_server_sn on am_plan_record (video_server_sn ASC)
end

GO

