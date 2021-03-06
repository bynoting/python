if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_ca_user]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  return

CREATE TABLE [dbo].[t_ca_user] (
	[guid]  [guid]  NOT NULL ,
	[user_account] [user_account] NOT NULL ,
	[card_sn] [nvarchar] (64) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[pki_cert] [nvarchar] (3072) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[cert_sn] [varchar] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[valid_begin] [datetime] NOT NULL ,
	[valid_end] [datetime] NOT NULL ,
	[valid_days] [int] NOT NULL ,
	[issue_date] [datetime] NOT NULL ,
	[state] [int] NOT NULL ,
	[data_create_user] [user_account]  NULL ,
	[data_create_time] [data_create_time] NULL 
) ON [PRIMARY]

ALTER TABLE [dbo].[t_ca_user] WITH NOCHECK ADD 
	CONSTRAINT [PK_t_ca_user] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 


ALTER TABLE [dbo].[t_ca_user] WITH NOCHECK ADD 
	CONSTRAINT [DF_t_ca_user_issue_date] DEFAULT (getdate()) FOR [issue_date],
	CONSTRAINT [DF_t_ca_user_state] DEFAULT (0) FOR [state]

CREATE  UNIQUE  INDEX [IX_t_ca_user_useraccount] ON [dbo].[t_ca_user]([user_account]) WITH  FILLFACTOR = 90 ON [PRIMARY]


exec sp_addextendedproperty N'MS_Description', N'USB卡的序列号', N'user', N'dbo', N'table', N't_ca_user', N'column', N'card_sn'

exec sp_addextendedproperty N'MS_Description', N'证书序列号', N'user', N'dbo', N'table', N't_ca_user', N'column', N'cert_sn'

exec sp_addextendedproperty N'MS_Description', N'创建日期', N'user', N'dbo', N'table', N't_ca_user', N'column', N'data_create_time'

exec sp_addextendedproperty N'MS_Description', N'创建人', N'user', N'dbo', N'table', N't_ca_user', N'column', N'data_create_user'

exec sp_addextendedproperty N'MS_Description', N'发证日期', N'user', N'dbo', N'table', N't_ca_user', N'column', N'issue_date'

exec sp_addextendedproperty N'MS_Description', N'证书', N'user', N'dbo', N'table', N't_ca_user', N'column', N'pki_cert'

exec sp_addextendedproperty N'MS_Description', N'证书状态(0:有效 1:过期)', N'user', N'dbo', N'table', N't_ca_user', N'column', N'state'

exec sp_addextendedproperty N'MS_Description', N'用户帐号', N'user', N'dbo', N'table', N't_ca_user', N'column', N'user_account'

exec sp_addextendedproperty N'MS_Description', N'证书有效期开始日期', N'user', N'dbo', N'table', N't_ca_user', N'column', N'valid_begin'

exec sp_addextendedproperty N'MS_Description', N'有效期(天)', N'user', N'dbo', N'table', N't_ca_user', N'column', N'valid_days'

exec sp_addextendedproperty N'MS_Description', N'证书有效期结束日期', N'user', N'dbo', N'table', N't_ca_user', N'column', N'valid_end'

GO

