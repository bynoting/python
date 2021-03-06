if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_notice]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin

CREATE TABLE [dbo].[am_notice] (
	[guid] [guid] NOT NULL ,
	[notice_type] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[dispatching_number] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[notice_state] [int] NOT NULL ,
	[notice_department] [int] NOT NULL ,
	[datetime_begin] [datetime] NOT NULL ,
	[datetime_end] [datetime] NOT NULL ,
	[title] [nvarchar] (200) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[content] [text] COLLATE Chinese_PRC_CI_AS NULL ,
	[data_create_user] [user_account] NOT NULL ,
	[data_create_time] [data_create_time] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[am_notice] WITH NOCHECK ADD 
	CONSTRAINT [PK_Am_Announcement] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 

EXEC sp_bindefault N'[dbo].[now]', N'[am_notice].[data_create_time]'
EXEC sp_bindefault N'[dbo].[null_string]', N'[am_notice].[data_create_user]'
EXEC sp_bindefault N'[dbo].[guid]', N'[am_notice].[guid]'

end
GO

if not exists( select 1 from dbo.syscolumns s where name ='is_need_receipt'
	and id = object_id(N'am_notice'))
begin
	ALTER TABLE [dbo].[am_notice] 
	ADD [is_need_receipt] [bit] NULL 
end

if not exists( select 1 from dbo.syscolumns s where name ='attachment'
	and id = object_id(N'am_notice'))
begin
	ALTER TABLE [dbo].[am_notice] 
		ADD [attachment] [nvarchar] (255) COLLATE Chinese_PRC_CI_AS NULL;
end

