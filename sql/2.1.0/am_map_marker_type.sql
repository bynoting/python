if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_map_marker_type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin

CREATE TABLE [dbo].[am_map_marker_type] (
	[marker_type_id] [int] IDENTITY (1, 1) NOT NULL ,
	[marker_type_name] [nvarchar] (30) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[marker_type_desc] [nvarchar] (256) COLLATE Chinese_PRC_CI_AS NULL ,
	[marker_type_icon] [nvarchar] (128) COLLATE Chinese_PRC_CI_AS NULL ,
	[custom_icon] [bit] NULL 
) ON [PRIMARY]

ALTER TABLE [dbo].[am_map_marker_type] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_map_marker_type] PRIMARY KEY  CLUSTERED 
	(
		[marker_type_id]
	)  ON [PRIMARY] 

end
GO

