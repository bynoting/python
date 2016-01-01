----------------------------------------------------------------------------
--添加 报警联动的透明串口动作表
----------------------------------------------------------------------------
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_alarm_action_serials]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	CREATE TABLE [dbo].[am_alarm_action_serials] (
	    [guid] [guid] NOT NULL ,
	    [video_server_sn] [video_server_sn] NOT NULL ,
	    [zone_id] [int] NOT NULL ,
	    [serial_port] [int] NOT NULL , 
	    [command] [varbinary] (96) NOT NULL ,
	    [data_create_time] [data_create_time] NOT NULL 
	) ON [PRIMARY]

	ALTER TABLE [dbo].[am_alarm_action_serials] WITH NOCHECK ADD 
	CONSTRAINT [PK_am_alarm_action_serials] PRIMARY KEY  CLUSTERED 
	(
	    [guid]
	)  ON [PRIMARY] 

	CREATE  INDEX [IX_am_alarm_action_serials_vs_sn] ON [dbo].[am_alarm_action_serials]([video_server_sn]) ON [PRIMARY]

	EXEC sp_bindefault N'[dbo].[now]', N'[am_alarm_action_serials].[data_create_time]'

	EXEC sp_bindefault N'[dbo].[guid]', N'[am_alarm_action_serials].[guid]'
	EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[am_alarm_action_serials].[video_server_sn]'
end
go

