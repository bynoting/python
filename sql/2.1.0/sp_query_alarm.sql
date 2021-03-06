if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_alarm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_alarm]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :根据用户输入的查询条件查询报警
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-08-29
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_query_alarm 
(
	@strUserAccount varchar(32),			--用户帐号
	@strPointAddr varchar(100),			--监控点名称
	@strDeviceName varchar(100),			--设备名称
	@strDeviceGuid varchar(38),			--设备GUID
	@strAlarmClass varchar(1) ,                                     --报警级别
	@strReceiver varchar(32),	                           --接警人
	@strState varchar(1),                                               --处理状态
	@dtBeginTime varchar(30),			--查询起始日期
	@dtEndTime varchar(30)				--查询结束日期
)
AS
declare @SQLString nvarchar(4000)
declare @strIsp varchar(20)
declare @intLength int
set @SQLString=	"SELECT " +
			"		id, device_guid, device_name, point_id, point_name, " +
			"		point_addr, alarm_time, receiver_name, alarm_class, state, loadrecord_finish, " +
			"		process_comment, reset_invoker, reset_time, alarm_type, comment, relieve_invoker, relieve_time," + 
			"		(select name_cn from t_alarm_type where code = alarm_type) alarm_type_name, " +
			"		(select codename from t_codediction where codetype = 'ALARM_CLASS' and codevalue = convert(varchar, alarm_class)) alarm_class_name," +
			"		(select codename from t_codediction where codetype = 'ALARM_HANDLE_STATE' and codevalue = convert(varchar, state)) state_name " +
			"FROM " +
			"		t_alarm_log " +
			"WHERE " +
			"		1 = 1 "
--判断是否为超级系统管理员 1:是   0:不是(设备权限限制)
exec sp_check_is_admin @strUserAccount, @intLength output
--print @intLength
--return
if  @intLength  = 0 
	set @SQLString = @SQLString  + " AND EXISTS(select 1 from v_useraccount_device where device_guid = t_alarm_log.device_guid and USERACCOUNT ='"+ @strUserAccount +"' and device_type_id = 3)" 
--按监控点名称查询
set @intLength = len(@strPointAddr)
if  @intLength  >=1
	set @SQLString =  @SQLString  + " AND point_name like '%" + @strPointAddr + "%'"
--按前端设备名称查询
set @intLength = len(@strDeviceName)
if  @intLength  >=1 
	set @SQLString =  @SQLString  + " AND device_name like '%" + @strDeviceName + "%'"
--按前端设备guid查询
set @intLength = len(@strDeviceGuid)
if  @intLength  >=1
	set @SQLString =  @SQLString  + " AND device_guid like '%" + @strDeviceGuid + "%'"
--按报警级别查询
set @intLength = len(@strAlarmClass)
if  @intLength  >=1
	set @SQLString =  @SQLString  + " AND alarm_class =" + @strAlarmClass
--按接警人查询
set @intLength = len(@strReceiver)
if  @intLength  >=1 
	set @SQLString =  @SQLString  + " AND receiver_name like '%" + @strReceiver + "%'"
--按处理状态查询
set @intLength = len(@strState)
if  @intLength  >=1
	set @SQLString =  @SQLString  + " AND state =" + @strState
--按报警时间查询
set @intLength = len(@dtBeginTime)
if  @intLength  >=1
	set @SQLString  = @SQLString + " AND (alarm_time between '" + @dtBeginTime+ "' and '" + @dtEndTime + "' ) " 
set @SQLString  = @SQLString + " order by id desc "
--print @SQLString
--return
exec sp_executesql @SQLString
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

