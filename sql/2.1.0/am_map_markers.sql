if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_map_markers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin

CREATE TABLE [dbo].[am_map_markers] (
	[marker_id] [guid] NOT NULL ,
	[marker_type_id] [int] NOT NULL ,
	[marker_name] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[marker_content] [text] COLLATE Chinese_PRC_CI_AS NULL ,
	[map_name] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[lon] [float] NOT NULL ,
	[lat] [float] NOT NULL ,
	[update_time] [datetime] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[am_map_markers] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_map_markers] PRIMARY KEY  CLUSTERED 
	(
		[marker_id]
	)  ON [PRIMARY] 

EXEC sp_bindefault N'[dbo].[guid]', N'[am_map_markers].[marker_id]'

ALTER TABLE [dbo].[am_map_markers] ADD 
	CONSTRAINT [FK_AM_MAP_MARKERS_FK_AM_MAP_MARKER_TYPE] FOREIGN KEY 
	(
		[marker_type_id]
	) REFERENCES [dbo].[am_map_marker_type] (
		[marker_type_id]
	)

end
GO

