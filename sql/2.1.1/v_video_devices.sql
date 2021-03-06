/****** 对象: 视图 dbo.v_video_devices    脚本日期: 2010-6-3 17:14:46 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_video_devices]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_video_devices]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** 对象: 视图 dbo.v_video_devices    脚本日期: 2010-6-3 17:14:47 ******/

--------------------------------------------------------------------------
-- 去掉对t_lens表的联合
-- 加入matrix_guid的查询，支持云台直连矩阵的控制
--------------------------------------------------------------------------
CREATE VIEW dbo.v_video_devices
AS
SELECT matrix_id as id, 'matrix' AS type, guid, video_serial_port, video_serial_port_no, serial_addr,product_type_id,guid as matrix_guid 
FROM t_matrix

UNION ALL

SELECT ptz_id as id, 'ptz' AS type, guid, video_serial_port, video_serial_port_no, serial_addr,product_type_id,
      matrix_guid = case serial_link_type 
			when 0 then device_guid
			when 1 then ''
			else ''	end
FROM t_ptz



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

