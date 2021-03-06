if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_sub_device]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_sub_device]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

-------------------------------------------------------------------------------------------------
-- 设备连接的子设备视图
-------------------------------------------------------------------------------------------------
CREATE VIEW dbo.v_sub_device
AS
-- 串口
SELECT 
	serial_port_id, 
	serial_port_name, 
	SerialGuid, 
	device_type, 
	serial_port_number, 
	device_type_name, 
	VideoServGuid, 
	video_server_id
FROM 
	t_serial_port, t_device_type
WHERE 
	t_serial_port.device_type = t_device_type.device_type_id
UNION
-- 输入端口
SELECT 
	input_port_id,
	input_port_name, 
	DiGuid, 
	device_type,  
	input_port_number,
      	device_type_name, 
	VideoServGuid, 
	video_server_id
FROM 
	t_input_port, t_device_type
WHERE 
	t_input_port.device_type = t_device_type.device_type_id
UNION
--视频输入端口
SELECT 
	video_input_port_id, 
	video_input_port_name, 
	 VideoInputPortGuid, 
	device_type, 
	video_input_port_no, 
	device_type_name, 
	VideoServGuid, 
	video_server_id
FROM 
	t_video_input_port, t_device_type
WHERE 
	t_video_input_port.device_type = t_device_type.device_type_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

