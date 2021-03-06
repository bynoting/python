if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_alarm_record_file]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_alarm_record_file]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.v_alarm_record_file
AS
SELECT 
	dbo.t_alarm_log.id AS alarm_id, 
	dbo.t_alarm_log.alarm_time, 
      	dbo.t_alarm_log.alarm_class, 
	dbo.t_alarm_log.device_guid as video_server_sn, 
      	dbo.t_alarm_log.device_name as video_server_name, 
	dbo.t_alarm_log.state, 
	dbo.t_alarm_log.alarm_type, 
      	dbo.t_alarm_kinescope_log.type as record_type, 
	dbo.t_alarm_kinescope_log.filePath as file_path, 
      	dbo.t_alarm_kinescope_log.vedioLong as duration_s, 
      	dbo.t_alarm_kinescope_log.highRecordState as record_state
FROM dbo.t_alarm_log INNER JOIN
      	dbo.t_alarm_kinescope_log ON 
      	dbo.t_alarm_log.id = dbo.t_alarm_kinescope_log.alarmId




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

