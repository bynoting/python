/****** 对象: 表 [dbo].[am_plan_photo]    脚本日期: 2010-6-8 16:17:10 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_plan_photo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_plan_photo]
GO

/****** 对象: 表 [dbo].[am_plan_photo]    脚本日期: 2010-6-8 16:17:11 ******/
CREATE TABLE [dbo].[am_plan_photo] (
	[guid] [guid] NOT NULL ,
	[plan_guid] [guid] NOT NULL ,
	[video_server_sn] [video_server_sn] NOT NULL ,
	[lens_guid] [nvarchar] (36) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[video_input_port] [int] NOT NULL ,
	[ptz_guid] [nvarchar] (36) COLLATE Chinese_PRC_CI_AS NULL ,
	[position_number] [nvarchar] (64) COLLATE Chinese_PRC_CI_AS NULL ,
	[data_create_user] [user_account] NULL ,
	[data_create_time] [data_create_time] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[am_plan_photo] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_plan_photo] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[am_plan_photo] ADD 
	CONSTRAINT [DF_am_plan_photo_position_number] DEFAULT ((-1)) FOR [position_number]
GO

 CREATE  INDEX [idx_planphoto_planguid] ON [dbo].[am_plan_photo]([plan_guid]) ON [PRIMARY]
GO

setuser
GO

EXEC sp_bindefault N'[dbo].[now]', N'[am_plan_photo].[data_create_time]'
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_photo].[guid]'
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_photo].[lens_guid]'
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_photo].[plan_guid]'
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_plan_photo].[ptz_guid]'
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[am_plan_photo].[video_server_sn]'
GO

setuser
GO

