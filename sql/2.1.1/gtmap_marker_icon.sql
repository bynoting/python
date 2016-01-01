USE [gtalarm]

ALTER TABLE [dbo].[am_map_markers] DROP CONSTRAINT [FK_AM_MAP_MARKERS_FK_AM_MAP_MARKER_TYPE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_map_marker_type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_map_marker_type]
GO

CREATE TABLE [dbo].[am_map_marker_type](
  [marker_type_id] [int] IDENTITY(1,1) NOT NULL,
  [marker_icon] [image] NULL,
  [marker_icon_width] [int] NULL,
  [marker_icon_height] [int] NULL,
  [marker_icon_type] VARCHAR(16) NULL,
    CONSTRAINT [PK_am_map_marker_type] PRIMARY KEY CLUSTERED 
    (
        [marker_type_id] ASC
    ) ON [PRIMARY]
) ON [PRIMARY]
GO

if not exists (select a.id from dbo.syscolumns a, dbo.sysObjects b where a.id = b.id and b.name = 'am_map_markers' and a.name = 'update_user')
ALTER TABLE [dbo].[am_map_markers] ADD update_user NVARCHAR(32)
GO

if not exists (select a.id from dbo.syscolumns a, dbo.sysObjects b where a.id = b.id and b.name = 'am_map_markers' and a.name = 'icon_name')
ALTER TABLE [dbo].[am_map_markers] ADD icon_name NVARCHAR(256)
GO

ALTER TABLE [dbo].[am_map_markers]  WITH NOCHECK ADD  CONSTRAINT [FK_AM_MAP_MARKERS_FK_AM_MAP_MARKER_TYPE] FOREIGN KEY([marker_type_id])
REFERENCES [dbo].[am_map_marker_type] ([marker_type_id])
GO

ALTER TABLE [dbo].[am_map_markers] CHECK CONSTRAINT [FK_AM_MAP_MARKERS_FK_AM_MAP_MARKER_TYPE]
GO

INSERT INTO [dbo].[am_map_marker_type]([marker_icon_width],[marker_icon_height],[marker_icon_type]) VALUES(12, 12, 'image/png')
GO
