if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_case_alarm_report]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_case_alarm_report]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.v_case_alarm_report
AS
SELECT (SELECT DISTINCT group_name
          FROM t_watch_point_group
          WHERE t_watch_point_group.group_code =
                    (SELECT DISTINCT group_code
                   FROM t_watch_point
                   WHERE point_id = t_alarm_log.point_id)) AS Case_GroupName, 
	point_id,
          	point_name AS Case_PointName,
	device_name  AS DeviceName, device_guid, 
      state, receiver_name,
          (SELECT  CODENAME
         FROM T_CODEDICTION
         WHERE CODETYPE = 'ALARM_HANDLE_STATE' AND CODEVALUE = convert(varchar, state))
      AS ALARM_HANDLE_STATE, alarm_time,
          (SELECT  CODENAME
         FROM T_CODEDICTION
         WHERE CODETYPE = 'ALARM_CLASS' AND CODEVALUE = convert(varchar, alarm_class))
      AS alarm_class,
          (SELECT  name_cn
         FROM t_alarm_type
         WHERE code  = alarm_type) 
      AS alarm_type
FROM dbo.t_alarm_log



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

