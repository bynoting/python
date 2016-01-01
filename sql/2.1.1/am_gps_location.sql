if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_gps_location]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_gps_location]
GO

CREATE TABLE [dbo].[am_gps_location] (
	[video_server_sn] [video_server_sn] NOT NULL ,
	[state] [int] NULL ,
	[latitude] [float] NULL ,
	[longitude] [float] NULL ,
	[direction] [float] NULL ,
	[altitude] [float] NULL ,
	[speed] [float] NULL ,
	[locating_time] [datetime] NULL ,
	[start_time] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[am_gps_location] ADD 
	CONSTRAINT [PK_am_gps_location] PRIMARY KEY  CLUSTERED 
	(
		[video_server_sn] 
	)  ON [PRIMARY] 
GO


EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_gps_location].[state]'
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[am_gps_location].[video_server_sn]'
GO


GO


exec sp_addextendedproperty N'MS_Description', N'�豸���к�', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'video_server_sn'
GO
exec sp_addextendedproperty N'MS_Description', N'״̬��0������ 1����gps�ź� 2�����ڶ�λ', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'state'
GO
exec sp_addextendedproperty N'MS_Description', N'γ��', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'latitude'
GO
exec sp_addextendedproperty N'MS_Description', N'����', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'longitude'
GO
exec sp_addextendedproperty N'MS_Description', N'����', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'direction'
GO
exec sp_addextendedproperty N'MS_Description', N'����', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'altitude'
GO
exec sp_addextendedproperty N'MS_Description', N'�ٶ�', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'speed'
GO
exec sp_addextendedproperty N'MS_Description', N'��ǰ��λ���ݻ�ȡʱ��', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'locating_time'
GO
exec sp_addextendedproperty N'MS_Description', N'��ʼ��λʱ��', N'user', N'dbo', N'table', N'am_gps_location', N'column', N'start_time'


GO

