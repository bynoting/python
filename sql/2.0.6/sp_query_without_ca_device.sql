if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_without_ca_device]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_without_ca_device]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.sp_query_without_ca_device
	@user_account nvarchar(36) 
AS
	SELECT 	
		videoservguid, --视频服务器序列号
		video_server_name, --视频服务器名称
		(select department_name from t_department where state = 0  and department_id = t_watch_point.department_id) unit_name, --单位名称
		(select protected_dept_name from t_protected_dept where state = 0 and protected_dept_id = t_watch_point.protected_dept) dept_name, --部门名称
		isnull(t_ca_device.state, 2) state 
	FROM
		t_video_server 
			left join t_ca_device on t_ca_device.video_server_sn = t_video_server.videoservguid 
			left join t_watch_point on t_watch_point.point_id = t_video_server.point_id
	WHERE 
		not exists(select state from t_ca_device where state = 0  and video_server_sn = t_video_server.videoservguid)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

