if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_watch_point_device]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_watch_point_device]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------------------------
-- 以设备为起点展示监控的信息，包括：
-- * 设备基本信息
-- * 监控点信息
-- * 监控组信息
-- * 设备所属单位和部门的信息
-- * 设备管理人和部门信息
----------------------------------------------------------------------------------------------------------------------
CREATE VIEW v_watch_point_device
AS
SELECT 
	vs.video_server_id, 
	vs.VideoServGuid as video_server_sn, 
	vs.video_server_name, 
	vs.product_type, 
	vs.ip_address, 
	vs.software_version, 
	vs.dev_info, 
	vs.ProtocolVersion, 
	vs.state as device_state, 
	vs.photo_index_file,
	vs.is_testing,
  vs.storage_type,

	wp.point_id, 	
	wp.point_name, 
	wp.point_addr, 

	wp.principal, 
	wp.teleph, 

	wp.principal1,
	wp.teleph1,

	wp.principal2,
	wp.teleph2,

	wp.department_id, 
	t_department.department_name,
	
	wp.protect_dept_id, 
	t_protectdept.protect_dept_name,
	
	wp.protected_dept,      
	t_protected_dept.protected_dept_name,
	
	t_watch_point_group.group_code, 
	t_watch_point_group.group_name
      
FROM t_video_server vs
 inner join  t_watch_point wp ON wp.point_id =  vs.point_id 
 inner join  t_watch_point_group ON t_watch_point_group.group_code = wp.group_code
 left join  t_department on t_department.department_id = wp.department_id
 left join  t_protectdept on t_protectdept.protect_dept_id = wp.protect_dept_id
 left join  t_protected_dept on t_protected_dept.protected_dept_id = wp.protected_dept






