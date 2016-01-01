if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_zone_info]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_zone_info]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- 删除端口表中的移动侦测端口数据
delete from t_input_port where device_type = 37
go

----------------------------------------------------------------------------------------------------------------------
-- 视频服务器上的防区信息，包括
-- * 该防区上定义的透明串口联动动作信息
----------------------------------------------------------------------------------------------------------------------
CREATE VIEW dbo.v_zone_info
AS
SELECT 
	port.VideoServGuid AS video_server_sn, 
	port.DiGuid AS zone_guid, 
	port.input_port_number,
	port.zone_id,  
	port.input_port_name AS name, 
	port.is_armed, 
	port.device_type,
	CASE WHEN act.guid IS NULL THEN 0 ELSE 1 END AS is_link_serial, 
	act.command AS serial_command, act.serial_port
FROM dbo.t_input_port port 
LEFT OUTER JOIN dbo.am_alarm_action_serials act 
ON act.video_server_sn = port.VideoServGuid AND act.zone_id = port.input_port_number

union all

select 
	VideoServGuid as video_server_sn, 
	VideoInputPortGuid as zone_guid,
	video_input_port_no as input_port_number,
	zone_id,
	video_input_port_name as name,
	is_armed,
	device_type,
	0,
	null,
	null
from t_video_input_port

go




