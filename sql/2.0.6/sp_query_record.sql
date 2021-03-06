if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_record]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_record]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :根据用户输入的查询条件查询录象
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-08-17
//modify Info list:
//   2006.10.27   plq   新的方案采取只有一个ftp服务的方式,原先的通过录象服务器的guid去查找ftp服务地址的方式被注释掉
*/
CREATE PROCEDURE dbo.sp_query_record
(
	@strUserAccount varchar(32),			--用户帐号
	@strRecordType varchar(4),			--录象类型    -1: 计划录象   0:报警录像    1: 报警录象(低清晰)    2: 报警录象(高清晰)   
	@strPlanName varchar(100),			--录象计划名称
	@strDeviceName varchar(100),			--设备名称
	@strDeviceGuid varchar(38),			--设备GUID
	@dtBeginTime varchar(30),			--查询起始日期
	@dtEndTime varchar(30)				--查询结束日期
)
AS
declare @SQLString nvarchar(4000)
declare @intLength int

--获取ftp服务信息
declare @strFtpInfo varchar(200)
exec sp_get_record_ftp_info @strUserAccount, @strFtpInfo output

if @strRecordType = '-1'--计划录象
begin
	set @SQLString= '  SELECT ' +
			'	v_biz_record_file_plan.plan_id,  v_biz_record_file_plan.duration_s, ' +
			'	v_biz_record_file_plan.data_create_time,  ' +
			'	t_video_server.video_server_name, ' + 
			'	v_biz_record_file_plan.video_server_sn,  ' +
			'	v_biz_record_file_plan.plan_name, ' +
			'	(''' + @strFtpInfo + ''' + v_biz_record_file_plan.file_path)  whole_file_path  ' +
			'  FROM ' +
			'	v_biz_record_file_plan, t_video_server  ' +
			'  WHERE ' +
			' 	t_video_server.videoservguid = v_biz_record_file_plan.video_server_sn  ' 

	--判断是否为超级系统管理员 1:是   0:不是(设备权限限制)
	exec sp_check_is_admin @strUserAccount, @intLength output
	if  @intLength  = 0 
		set @SQLString = @SQLString  + ' AND EXISTS(select device_guid from v_useraccount_device where device_guid = v_biz_record_file_plan.video_server_sn and USERACCOUNT =''' + @strUserAccount + ''' and device_type_id = 3)' 
	--按计划名称查询
	set @intLength = len(@strPlanName)
	if  @intLength  >=1
		set @SQLString =  @SQLString  + ' AND v_biz_record_file_plan.plan_name like ''%' + @strPlanName + '%'''
	--按前端设备名称查询
	set @intLength = len(@strDeviceName)
	if  @intLength  >=1 
		set @SQLString =  @SQLString  + ' AND t_video_server.video_server_name like ''%' + @strDeviceName + '%'''
	--按前端设备guid查询
	set @intLength = len(@strDeviceGuid)
	if  @intLength  >=1
		set @SQLString =  @SQLString  + ' AND v_biz_record_file_plan.video_server_sn like ''%' + @strDeviceGuid + '%'''
	--按时间查询
	set @intLength = len(@dtBeginTime)
	if  @intLength  >=1
		set @SQLString  = @SQLString + ' AND (v_biz_record_file_plan.data_create_time between ''' + @dtBeginTime+ ''' and ''' + @dtEndTime + ''' ) ' 
	set @SQLString  = @SQLString +  ' order by v_biz_record_file_plan.data_create_time desc ' 
end
else
begin
	set @SQLString= '  SELECT alarm_id,  record_type,  duration_s,  video_server_sn,   video_server_name,  alarm_time,  record_state,   file_path as local_file_path, ' +
			 '	(''' + @strFtpInfo + ''' + file_path)  whole_file_path ' +
			 '  FROM   v_alarm_record_file WHERE 1 = 1 '

	--判断是否为超级系统管理员 1:是   0:不是(设备权限限制)
	exec sp_check_is_admin @strUserAccount, @intLength output
	if  @intLength  = 0 
		set @SQLString = @SQLString  + '  AND EXISTS(select tree_id from v_useraccount_device where device_guid = v_alarm_record_file.video_server_sn and USERACCOUNT ='''+ @strUserAccount + ''' and device_type_id = 3)'
	--按清晰度查询
	set @intLength = len(@strRecordType)
	if  @intLength  >=1 and @strRecordType > 0
	begin
		--为兼容旧数据库作一下转换处理
		if @strRecordType = 1
			set @strRecordType = 'Low'
		else
			set @strRecordType = 'High'
		set @SQLString =  @SQLString  + ' AND record_type =''' + @strRecordType + ''''
	end
	--按前端设备名称查询
	set @intLength = len(@strDeviceName)
	if  @intLength  >=1 
		set @SQLString =  @SQLString  + ' AND video_server_name like ''%' + @strDeviceName + '%'''
	--按前端设备guid查询
	set @intLength = len(@strDeviceGuid)
	if  @intLength  >=1
		set @SQLString =  @SQLString  + ' AND video_server_sn like ''%' + @strDeviceGuid + '%'''
	--按时间查询
	set @intLength = len(@dtBeginTime)
	if  @intLength  >=1
		set @SQLString  = @SQLString + ' AND (alarm_time between ''' + @dtBeginTime+ ''' and ''' + @dtEndTime + ''') '
	set @SQLString  = @SQLString + ' order by alarm_id desc '
end
print @SQLString
--return
exec sp_executesql @SQLString
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

