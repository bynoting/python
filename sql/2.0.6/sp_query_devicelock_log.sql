if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_devicelock_log]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_devicelock_log]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
//Description :查询落锁设备状态变更日志
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2008-02-03
//modify Info list:
*/

CREATE PROCEDURE dbo.sp_query_devicelock_log
	@user_account			varchar(32),               --用户帐号
	@video_server_sn		varchar(16),               --设备guid,   当传入null字符串时该参数不使用,即不作为查询条件
	@video_server_name		varchar(100),
	@point_name			varchar(100),
	@group_name			varchar(100),
	@department_name		varchar(100),
	@protect_dept_name		varchar(100),
	@lock_state			int
 AS
	declare @sqlString nvarchar(4000)
	declare @intLength int	

	set @sqlString = 'SELECT  ' + 
			'	am_zone_state_log.guid,  ' +
			'	am_zone_state_log.zone_guid,   '+
			'	am_zone_state_log.changed_state,   '+
			'	changed_state_name = ' +
			'	case am_zone_state_log.changed_state  ' +
			'		when 0 then ''关''   ' +
			'		when 1 then ''开''  end, ' +
			'	am_zone_state_log.change_time,  '+
			'	v_watch_point_device.video_server_name,   '+
			'	v_watch_point_device.video_server_sn,  '+
			'	t_input_port.input_port_number as port   '+
			'FROM '+
			'	am_zone_state_log,    '+
			'	t_input_port,   '+
			'	v_watch_point_device  '+
			'WHERE'+
			'	v_watch_point_device.video_server_sn = t_input_port.VideoServGuid AND '+
			'	am_zone_state_log.zone_guid = t_input_port.DiGuid  '

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

	--锁状态
	IF @lock_state >= 0
	BEGIN
		set @sqlString = @sqlString + ' AND (am_zone_state_log.changed_state  = ' + Convert(varchar(1), @lock_state) + ') '
	END

	set @sqlString = @sqlString + ' ORDER BY am_zone_state_log.change_time  desc ' ;

	print @sqlString
	exec sp_executesql @sqlString
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

