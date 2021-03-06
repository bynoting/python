if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_alarm_ptz_preset]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_alarm_ptz_preset] (
		[guid] [guid] NOT NULL ,
		[video_server_sn] [video_server_sn] NOT NULL ,
		[zone_id] [int] NOT NULL ,
		[lens_id] [int] NOT NULL ,
		[ptz_id] [int] NOT NULL ,
		[position_number] [int] NOT NULL ,
		[action_guid] [guid] NOT NULL ,
		[remark] [varchar] (200) COLLATE Chinese_PRC_CI_AS NULL ,
		[data_create_user] [varchar] (36) COLLATE Chinese_PRC_CI_AS NULL ,
		[data_create_time] [data_create_time] NULL 
	) ON [PRIMARY]
	ALTER TABLE [dbo].[am_alarm_ptz_preset] WITH NOCHECK ADD 
		CONSTRAINT [PK_am_alarm_preset] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	ALTER TABLE [dbo].[am_alarm_ptz_preset] ADD 
		CONSTRAINT [DF_am_alarm_ptz_preset_data_create_user] DEFAULT ('_sys_') FOR [data_create_user]

	CREATE  INDEX [IX_am_alarm_preset] ON [dbo].[am_alarm_ptz_preset]([video_server_sn]) ON [PRIMARY]

	EXEC sp_bindefault N'[dbo].[guid]', N'[am_alarm_ptz_preset].[action_guid]'
	EXEC sp_bindefault N'[dbo].[now]', N'[am_alarm_ptz_preset].[data_create_time]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_alarm_ptz_preset].[guid]'
end
go

setuser
GO

