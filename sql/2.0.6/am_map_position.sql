if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_map_position]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_map_position] (
		[guid] [guid] NOT NULL ,
		[device_guid] [guid] NOT NULL ,
		[device_type] [device_type_code] NOT NULL ,
		[ox] [float] NOT NULL ,
		[oy] [float] NOT NULL ,
		[oz] [float] NULL ,
		[video_server_sn] [video_server_sn] NOT NULL ,
		[data_create_user] [user_account] NOT NULL ,
		[data_create_time] [data_create_time] NOT NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_map_position] WITH NOCHECK ADD 
		CONSTRAINT [PK_AM_MAP_POSITION] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	ALTER TABLE [dbo].[am_map_position] ADD 
		CONSTRAINT [DF_am_map_position_oz] DEFAULT (0) FOR [oz]

	CREATE  INDEX [idx_map_position_video_server_sn] ON [dbo].[am_map_position]([video_server_sn]) ON [PRIMARY]

	EXEC sp_bindefault N'[dbo].[now]', N'[am_map_position].[data_create_time]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_map_position].[data_create_user]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_map_position].[device_guid]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_map_position].[device_type]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_map_position].[guid]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_map_position].[video_server_sn]'

end

GO
