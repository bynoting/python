if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_alarmDayCollect]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_alarmDayCollect]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.v_alarmDayCollect
AS
SELECT id, DATEPART([year], alarm_time) AS [Year], DATEPART([month], alarm_time) 
      AS [Month], DATEPART([day], alarm_time) AS [Day],
          (SELECT DISTINCT group_name
         FROM t_watch_point_group
         WHERE t_watch_point_group.group_code =
                   (SELECT DISTINCT group_code
                  FROM t_watch_point
                  WHERE t_watch_point.point_id = t_alarm_log.point_id)) AS group_name, 
      point_name, device_name AS video_server_name,
          (SELECT name_cn
         FROM t_alarm_type
         WHERE code = alarm_type) AS CASEALARM_TYPE,
          (SELECT DISTINCT CODENAME
         FROM T_CODEDICTION
         WHERE CODETYPE = 'ALARM_HANDLE_STATE' AND CODEVALUE = convert(varchar, state))
      AS ALARM_HANDLE_STATE, receiver_name AS handler, point_id, 
      device_guid AS video_server_sn
FROM dbo.t_alarm_log




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

