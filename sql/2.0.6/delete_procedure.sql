if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_alarm_preset_update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[sp_alarm_preset_update]

	
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_get_record_ftp_userpwd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[sp_get_record_ftp_userpwd]