if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_photo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_photo]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


----------------------------------------------------------------------------------------------------------------
--Description :根据用户输入的查询条件查询抓图
--Company :GTAlarm 
--author: 潘龙泉
--Create Date :2006-08-17
--modify Info list:
--   2006.10.27   plq   新的方案采取只有一个ftp服务的方式,原先的通过录象服务器的guid去查找ftp服务地址的方式被注释掉
----------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.sp_query_photo 
(
	@strUserAccount varchar(32),			--用户帐号
	@strOperator varchar(32),			--抓图人帐号
	@strState varchar(1),				--抓图处理状态
	@strDeviceName varchar(100),			--设备名称
	@strDeviceGuid varchar(38),			--设备GUID
	@dtBeginTime varchar(30),			--查询起始日期
	@dtEndTime varchar(30)				--查询结束日期
)
AS
declare @SQLString nvarchar(4000)
declare @intLength int

/*
--获取用户ISP
declare @strIsp varchar(20)
select @strIsp = isnull(isp, '') from t_org_user where useraccount = @strUserAccount
--print @strIsp
--获取访问FTP的用户名、密码
declare @strFtpUserPwd varchar(200)
exec sp_get_record_ftp_userpwd @strFtpUserPwd output
--print @strFtpUserPwd
set @SQLString= "  SELECT " +
		"	apply_time,   user_account,     device_guid,        device_name,     alarm_id,   " +
		"	(select codename from t_codediction where upper(codetype) = upper('PHOTOSTATE') and codevalue = state) state,  " +
		"	('ftp://' + '" + @strFtpUserPwd + "'" + " + '@' + isnull(t_service_isp.ip,  t_services.outip) + t_photo_file.ph_file)  file5   " +
		"  FROM " +
		"	v_photo  " +
		"		left join t_service_isp on t_service_isp.server_guid = v_photo.record_server_guid and t_service_isp.isp ='" + @strIsp + "' " +
		"		left join t_services on t_services.guid = v_photo.record_server_guid  , " +
		"	t_photo_file  " +
		"  WHERE " +
		" 	t_photo_file.ph_timestamp = v_photo.ph_timestamp " 
*/
--获取ftp服务信息
declare @strFtpInfo varchar(200)
exec sp_get_record_ftp_info @strUserAccount, @strFtpInfo output
set @SQLString= "  SELECT " +
		"	apply_time,   user_account,     device_guid,        device_name,     alarm_id,   " +
		"	(select codename from t_codediction where codetype = 'PHOTOSTATE' and codevalue = convert(varchar, state)) state,  " +
		"	('" + @strFtpInfo + "' + t_photo_file.ph_file)  file5   " +
		"  FROM " +
		"	v_photo, " +
		"	t_photo_file  " +
		"  WHERE " +
		" 	t_photo_file.ph_timestamp = v_photo.ph_timestamp " 
--判断是否为超级系统管理员 1:是   0:不是(设备权限限制)
exec sp_check_is_admin @strUserAccount, @intLength output
--print @intLength
if  @intLength  = 0 
	set @SQLString = @SQLString  + " AND EXISTS(select device_guid from v_useraccount_device where device_guid = v_photo.device_guid and USERACCOUNT ='"+ @strUserAccount +"' and device_type_id = 3)" 
--按抓拍人查询
set @intLength = len(@strOperator)
if  @intLength  >=1
	set @SQLString =  @SQLString  + " AND user_account like '%" + @strOperator + "%'"
--按处理状态查询
set @intLength = len(@strState)
if  @intLength  >=1
	set @SQLString =  @SQLString  + " AND state =" + @strState
--按前端设备名称查询
set @intLength = len(@strDeviceName)
if  @intLength  >=1 
	set @SQLString =  @SQLString  + " AND device_name like '%" + @strDeviceName + "%'"
--按前端设备guid查询
set @intLength = len(@strDeviceGuid)
if  @intLength  >=1
	set @SQLString =  @SQLString  + " AND device_guid like '%" + @strDeviceGuid + "%'"
--按抓拍时间查询
set @intLength = len(@dtBeginTime)
if  @intLength  >=1
	set @SQLString  = @SQLString + " AND (apply_time between '" + @dtBeginTime+ "' and '" + @dtEndTime + "' ) " 

set @SQLString  = @SQLString + " ORDER BY apply_time desc"
--print @SQLString
--return
exec sp_executesql @SQLString
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

