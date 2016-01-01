if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_zone_state_log]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_zone_state_log] (
		[guid] [guid] NOT NULL ,
		[zone_guid] [guid] NOT NULL ,
		[changed_state] [int] NOT NULL ,
		[change_time] [datetime] NOT NULL ,
		[data_create_user] [user_account] NULL ,
		[data_create_time] [datetime] NOT NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_zone_state_log] WITH NOCHECK ADD 
		CONSTRAINT [PK_am_zone_change_log] PRIMARY KEY  CLUSTERED 
		(
			[guid]
		)  ON [PRIMARY] 

	EXEC sp_bindefault N'[dbo].[now]', N'[am_zone_state_log].[data_create_time]'
	EXEC sp_bindefault N'[dbo].[null_string]', N'[am_zone_state_log].[data_create_user]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_zone_state_log].[guid]'
	EXEC sp_bindefault N'[dbo].[guid]', N'[am_zone_state_log].[zone_guid]'
end
go

