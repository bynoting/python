if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_autocheck_result]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_autocheck_result]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.v_autocheck_result
AS
SELECT a.video_server_id, a.video_server_sn, a.video_server_name, a.point_id, 
      a.point_name, a.point_addr, a.principal, a.teleph,
          (SELECT department_name
         FROM t_department
         WHERE department_id = a.department_id) AS department_name,
          (SELECT codename
         FROM t_codediction
         WHERE upper(codetype) = upper('CHECKTYPE') AND codevalue = b.FaultType) 
      AS FaultTypeName, b.InspectPlanID, b.InspectTime, b.InspectLogType, b.InspectUser, 
      b.FaultType, b.InspectLogID
FROM dbo.v_watch_point_device a INNER JOIN
      dbo.T_InspectLog b ON a.video_server_sn = b.DeviceID AND b.InspectLogType = '0'


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

