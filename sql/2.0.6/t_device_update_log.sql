if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_update_software]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_update_software]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_device_update_log]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_device_update_log]
GO

CREATE TABLE [dbo].[t_device_update_log] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[video_server_sn] [video_server_sn] NOT NULL ,
	[type] [int] NULL ,
	[reset_flag] [int] NULL ,
	[file_size] [int] NULL ,
	[file_path] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[finish_time] [datetime] NULL ,
	[state] [int] NOT NULL ,
	[error] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,
	[data_create_user] [user_account] NULL ,
	[data_create_time] [data_create_time] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_device_update_log] WITH NOCHECK ADD 
	CONSTRAINT [PK_t_device_update_log] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[t_device_update_log] ADD 
	CONSTRAINT [DF_t_update_software_Type] DEFAULT (0) FOR [type],
	CONSTRAINT [DF_t_update_software_ResetFlag] DEFAULT (0) FOR [reset_flag],
	CONSTRAINT [DF_t_update_software_state] DEFAULT (0) FOR [state]
GO

 CREATE  INDEX [IX_t_device_update_log_vs_sn] ON [dbo].[t_device_update_log]([video_server_sn]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_t_device_update_log_creat_time] ON [dbo].[t_device_update_log]([data_create_time] DESC ) ON [PRIMARY]
GO

setuser
GO

EXEC sp_bindefault N'[dbo].[now]', N'[t_device_update_log].[data_create_time]'
GO

setuser
GO

