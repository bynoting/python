if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_get_record_ftp_info]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_get_record_ftp_info]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
//Description :获取录象(图片)下载时访问的FTP服务器的IP地址、用户名、密码,格式如ftp://gtdev:gtdev@192.168.1.103
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-09-29
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_get_record_ftp_info
(
	@strUserAccount varchar(32),
	@param_value     varchar(200) output			--返回值
)
 AS
	declare @intLen int
	declare @strIP  varchar(20)
	declare @strIsp varchar(20)
	declare @strUserPassword varchar(200)

	--获取用户ISP
	if exists(select isp from t_org_user where useraccount = @strUserAccount)
		select @strIsp = isnull(isp, '') from t_org_user where useraccount = @strUserAccount
	else
		set @strIsp = '' 
	--print @strIsp

	--获取FTP服务的IP地址
	if @strIsp = ''
		set @strIP = ''
	else
	begin
		if exists(select ip from t_service_isp where type = 'ftp' and isp = @strIsp and isuse = 1)
			select @strIP = isnull(ip, '') from t_service_isp where type = 'ftp' and isp = @strIsp and isuse = 1
		else
			set @strIP = ''
	end

	if @strIP = ''
	begin
		if exists(select outip from t_services where type = 'ftp' and is_live = 1)
			select @strIP = isnull(outip, 'null') from t_services where type = 'ftp' and is_live = 1
		else
			set @strIP = 'null'
	end
	--print @strIP

	--获取FTP密码
	if exists(select services from t_services where type = 'ftp' and is_live = 1)
		select @strUserPassword = isnull(services, 'null') from t_services where type='ftp' and is_live=1
	else
		set @strUserPassword = 'null'
	--print @strUserPassword

	set @param_value = 'ftp://' + @strUserPassword + '@' + @strIP
	--print @param_value
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

