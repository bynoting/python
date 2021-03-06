/****** 对象: 表 [dbo].[am_switch_device]    脚本日期: 2010-6-8 16:18:08 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_switch_device]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_switch_device]
GO

/****** 对象: 表 [dbo].[am_switch_device]    脚本日期: 2010-6-8 16:18:08 ******/
CREATE TABLE [dbo].[am_switch_device] (
	[guid] [guid] NOT NULL ,
	[group_id] [nvarchar] (36) COLLATE Chinese_PRC_CI_AS NULL ,
	[video_server_sn] [video_server_sn] NOT NULL ,
	[serial_port_no] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[am_switch_device] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_switch_device] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 
GO

setuser
GO

EXEC sp_bindefault N'[dbo].[guid]', N'[am_switch_device].[guid]'
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[am_switch_device].[video_server_sn]'
GO

setuser
GO

