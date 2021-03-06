if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EafFunctionTree]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EafFunctionTree]
GO

CREATE TABLE [dbo].[EafFunctionTree] (
	[Id] [int] NOT NULL ,
	[DataCreateTime] [datetime] NULL ,
	[Name] [nvarchar] (32) COLLATE Chinese_PRC_CI_AS NULL ,
	[ExtendTag] [nvarchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[EntityGuid] [uniqueidentifier] NULL ,
	[EntityType] [nvarchar] (128) COLLATE Chinese_PRC_CI_AS NULL ,
	[LevelCode] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[ParentId] [int] NULL 
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[EafFunctionTree] ADD 
	CONSTRAINT [PK_EafFunctionTree] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
GO


