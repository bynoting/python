if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_notice_receiver]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
CREATE TABLE [dbo].[am_notice_receiver] (
	[guid] [guid] NOT NULL ,
	[notice_type] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[useraccount] [user_account] NOT NULL ,
	[data_create_user] [user_account] NOT NULL ,
	[data_create_time] [datetime] NOT NULL 
) ON [PRIMARY]

ALTER TABLE [dbo].[am_notice_receiver] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_notice_receiver] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	)  ON [PRIMARY] 

EXEC sp_bindefault N'[dbo].[now]', N'[am_notice_receiver].[data_create_time]'
EXEC sp_bindefault N'[dbo].[null_string]', N'[am_notice_receiver].[data_create_user]'
EXEC sp_bindefault N'[dbo].[guid]', N'[am_notice_receiver].[guid]'
EXEC sp_bindefault N'[dbo].[null_string]', N'[am_notice_receiver].[useraccount]'
end
GO

