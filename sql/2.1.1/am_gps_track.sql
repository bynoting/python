if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_gps_track]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_gps_track]
GO

CREATE TABLE [dbo].[am_gps_track] (
	[guid] [guid] NOT NULL ,
	[video_server_sn] [video_server_sn] NOT NULL ,
	[latitude] [float] NULL ,
	[longitude] [float] NULL ,
	[direction] [float] NULL ,
	[altitude] [float] NULL ,
	[speed] [float] NULL ,
	[locating_time] [datetime] NULL ,
	[start_time] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[am_gps_track] ADD 
	CONSTRAINT [PK_am_gps_track] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_gps_track].[guid]'
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[am_gps_track].[video_server_sn]'
GO
