if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_ca_device]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  return

CREATE TABLE [dbo].[t_ca_device] (
	[guid]  [guid]  NOT NULL ,
	[video_server_sn] [video_server_sn] NOT NULL ,
	[pki_cert] [varchar] (3072) COLLATE Chinese_PRC_CI_AS NULL ,
	[zip_cert_key] [varbinary] (4096) NOT NULL ,
	[cert_sn] [varchar] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[valid_begin] [datetime] NOT NULL ,
	[valid_end] [datetime] NOT NULL ,
	[valid_days] [int] NOT NULL ,
	[issue_date] [datetime] NOT NULL ,
	[state] [int] NOT NULL ,
	[is_applied] [bool] NULL ,
	[apply_time] [datetime] NULL ,
	[data_create_user] [user_account] NULL ,
	[data_create_time] [data_create_time] NULL 
) ON [PRIMARY]

ALTER TABLE [dbo].[t_ca_device] WITH NOCHECK ADD 
	CONSTRAINT [PK_t_ca_device] PRIMARY KEY  CLUSTERED 
	(
		[guid]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 


ALTER TABLE [dbo].[t_ca_device] WITH NOCHECK ADD 
	CONSTRAINT [DF_t_ca_device_issue_date] DEFAULT (getdate()) FOR [issue_date],
	CONSTRAINT [DF_t_ca_device_state] DEFAULT (0) FOR [state],
	CONSTRAINT [DF_t_ca_device_is_applied] DEFAULT (0) FOR [is_applied]

CREATE  INDEX [IX_t_ca_device_serversn] ON [dbo].[t_ca_device]([video_server_sn]) WITH  FILLFACTOR = 90 ON [PRIMARY]

exec sp_addextendedproperty N'MS_Description', N'应用到设备的时间', N'user', N'dbo', N'table', N't_ca_device', N'column', N'apply_time'

exec sp_addextendedproperty N'MS_Description', N'创建日期', N'user', N'dbo', N'table', N't_ca_device', N'column', N'data_create_time'

exec sp_addextendedproperty N'MS_Description', N'创建人', N'user', N'dbo', N'table', N't_ca_device', N'column', N'data_create_user'

exec sp_addextendedproperty N'MS_Description', N'是否应用于设备', N'user', N'dbo', N'table', N't_ca_device', N'column', N'is_applied'

exec sp_addextendedproperty N'MS_Description', N'发证日期', N'user', N'dbo', N'table', N't_ca_device', N'column', N'issue_date'

exec sp_addextendedproperty N'MS_Description', N'证书状态(0:有效 1:过期)', N'user', N'dbo', N'table', N't_ca_device', N'column', N'state'

exec sp_addextendedproperty N'MS_Description', N'证书有效期开始日期', N'user', N'dbo', N'table', N't_ca_device', N'column', N'valid_begin'

exec sp_addextendedproperty N'MS_Description', N'有效期(天)', N'user', N'dbo', N'table', N't_ca_device', N'column', N'valid_days'

exec sp_addextendedproperty N'MS_Description', N'证书有效期结束日期', N'user', N'dbo', N'table', N't_ca_device', N'column', N'valid_end'

exec sp_addextendedproperty N'MS_Description', N'视频服务器序列号', N'user', N'dbo', N'table', N't_ca_device', N'column', N'video_server_sn'

exec sp_addextendedproperty N'MS_Description', N'将密钥和证书通过Zip压缩后的数据', N'user', N'dbo', N'table', N't_ca_device', N'column', N'zip_cert_key'

GO

