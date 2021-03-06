if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_devicelock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_devicelock]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
//Description :查询出已设置落锁功能的设备、端口及端口上的联动动作
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2008-01-24
//modify Info list:
*/

CREATE PROCEDURE dbo.sp_query_devicelock
	@user_account			varchar(32),		--用户帐号
	@video_server_sn		varchar(16),		--设备guid
	@video_server_name		varchar(100),		--设备名称
	@point_name			varchar(100),		--监控点名称
	@group_name			varchar(100),		--监控点组名称
	@department_name		varchar(100),		--所属单位名称
	@protect_dept_name		varchar(100),		--管辖单位名称
	@device_state			int			--设备状态
 AS
	declare @sqlString nvarchar(4000)
	declare @intLength int	

	set @sqlString = 'SELECT ' + 
				'v_watch_point_device.video_server_sn, '+
				'v_watch_point_device.video_server_name, ' +
				'v_watch_point_device.device_state,'+
				'device_state_name = case v_watch_point_device.device_state when 6 then ''在线'' when 8 then ''离线''  when 7 then ''暂停服务'' end, ' +
				't_event_sender_set.channel_id as port, '+
      				't_alarm_linkage.linkage_action  ' + 
			'FROM ' +
				'v_watch_point_device, t_event_sender_set LEFT OUTER JOIN ' +
      				't_alarm_linkage ON t_alarm_linkage.linkage_type = 0 AND ' +
      				't_alarm_linkage.video_server_guid = t_event_sender_set.device_guid AND ' +
     		 		't_alarm_linkage.linkage_port = t_event_sender_set.channel_id ' +
			'WHERE ' +
				'(v_watch_point_device.video_server_sn = t_event_sender_set.device_guid) AND ' +
				'(t_event_sender_set.alarm_type = 9) '

	--判断是否是超级系统管理员
	exec sp_check_is_admin @user_account, @intLength output

	IF @intLength = 0--如果不是超级系统管理员,则只能查看有权限的设备
	BEGIN
		set @sqlString = @sqlString + ' AND EXISTS(select device_guid from v_useraccount_device where device_guid = v_watch_point_device.video_server_sn and USERACCOUNT ='''+   @user_account + ''' and device_type_id = 3)'
	END

	-- 设备guid
	set @intLength = len(@video_server_sn)
	IF @intLength >= 1
	BEGIN
		set @sqlString = @sqlString + ' AND (v_watch_point_device.video_server_sn like ''%'+  @video_server_sn + '%'') '
	END

	--设备名称
	set @intLength = len(@video_server_name)
	IF @intLength >= 1
	BEGIN
		set @sqlString = @sqlString + ' AND (v_watch_point_device.video_server_name  like ''%'+  @video_server_name + '%'') '
	END

	--所属监控点
	set @intLength = len(@point_name)
	IF @intLength >= 1
	BEGIN
		set @sqlString = @sqlString + ' AND (v_watch_point_device.point_name  like ''%'+  @point_name + '%'') '
	END
	
	--所属组
	set @intLength = len(@group_name)
	IF @intLength >= 1
	BEGIN
		set @sqlString = @sqlString + ' AND (v_watch_point_device.group_name  like ''%'+  @group_name + '%'') '
	END

	--所属单位
	set @intLength = len(@department_name)
	IF @intLength >= 1
	BEGIN
		set @sqlString = @sqlString + ' AND (v_watch_point_device.department_name  like ''%'+  @department_name + '%'') '
	END

	--所属管辖单位
	set @intLength = len(@protect_dept_name)
	IF @intLength >= 1
	BEGIN
		set @sqlString = @sqlString + ' AND (v_watch_point_device.protect_dept_name  like ''%'+  @protect_dept_name + '%'') '
	END

	--设备在线状态
	IF @device_state > 0
	BEGIN
		set @sqlString = @sqlString + ' AND (v_watch_point_device.device_state  = '+  convert(varchar(1),@device_state) + ') '
	END

	print @sqlString
	exec sp_executesql @sqlString
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

