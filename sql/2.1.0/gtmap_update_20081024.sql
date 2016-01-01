-- delete the camera position data first
if exists (select a.id from dbo.syscolumns a, dbo.systypes b, dbo.sysObjects c where a.xtype = b.xusertype and a.id = c.id and c.name = 'am_map_position' and a.name = 'device_guid' and b.name = 'uniqueidentifier')
DELETE FROM am_map_position WHERE device_type = 5
GO

-- change the device_guid type to nvarchar
if exists (select a.id from dbo.syscolumns a, dbo.systypes b, dbo.sysObjects c where a.xtype = b.xusertype and a.id = c.id and c.name = 'am_map_position' and a.name = 'device_guid' and b.name = 'uniqueidentifier')
EXEC dbo.sp_unbindefault @objname=N'[dbo].[am_map_position].[device_guid]' , @futureonly='futureonly'
GO

ALTER TABLE [dbo].[am_map_position] ALTER COLUMN device_guid [nvarchar](36) NULL
GO

UPDATE [dbo].[am_map_position] SET device_guid = video_server_sn WHERE device_type = 3
GO

ALTER TABLE [dbo].[am_map_position] ALTER COLUMN device_guid [nvarchar](36) NOT NULL
GO

if not exists (select a.id from dbo.syscolumns a, dbo.sysObjects b where a.id = b.id and b.name = 'am_map_position' and a.name = 'on_plan_map')
ALTER TABLE [dbo].[am_map_position] ADD on_plan_map [bit] DEFAULT(0) NOT NULL
GO

if not exists (select a.id from dbo.syscolumns a, dbo.sysObjects b where a.id = b.id and b.name = 'am_map_position' and a.name = 'plan_map_id')
ALTER TABLE [dbo].[am_map_position] ADD plan_map_id [guid]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_plan_map]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[am_plan_map](
	[id] [guid] NOT NULL,
	[device_guid] [nvarchar](36) NOT NULL,
	[map_name] [nvarchar](100) NOT NULL,
	[map_content] [image] NOT NULL,
	[map_width] [int] NOT NULL,
	[map_height] [int] NOT NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_am_plan_map] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO


