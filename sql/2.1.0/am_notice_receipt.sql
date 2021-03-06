if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_notice_receipt]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
CREATE TABLE [dbo].[am_notice_receipt] (
	[guid] [guid] NOT NULL ,
	[notice_guid] [guid] NOT NULL ,
	[is_receipted] [int] NULL ,
	[receipt_content] [text] COLLATE Chinese_PRC_CI_AS NULL ,
	[attachment] [nvarchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[data_create_user] [user_account] NOT NULL ,
	[data_create_time] [data_create_time] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[am_notice_receipt] ADD 
	CONSTRAINT [PK_am_notice_receipt] PRIMARY KEY  CLUSTERED 
	(
		[notice_guid],
		[data_create_user]
	)  ON [PRIMARY] 

EXEC sp_bindefault N'[dbo].[now]', N'[am_notice_receipt].[data_create_time]'
EXEC sp_bindefault N'[dbo].[null_string]', N'[am_notice_receipt].[data_create_user]'
EXEC sp_bindefault N'[dbo].[guid]', N'[am_notice_receipt].[guid]'
EXEC sp_bindefault N'[dbo].[guid]', N'[am_notice_receipt].[notice_guid]'
end
GO

