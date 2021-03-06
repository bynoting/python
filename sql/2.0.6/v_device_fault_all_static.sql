if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_device_fault_all_static]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_device_fault_all_static]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

------------------------------------------------------------------------------------
-- 描述：为数据统计提供的设备故障日志视图
-- 作者：zhangtao
------------------------------------------------------------------------------------
CREATE VIEW dbo.v_device_fault_all_static
AS
SELECT video_server_name, video_server_sn, point_id, point_name, group_code, 
      group_name, fault_type, fault_name, [year], [month], [day], COUNT(*) AS times
FROM dbo.v_device_fault_all
GROUP BY video_server_name, video_server_sn, point_id, point_name, group_code, 
      group_name, fault_type, fault_name, [year], [month], [day]

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

