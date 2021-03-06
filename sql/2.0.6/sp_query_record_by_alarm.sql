if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_record_by_alarm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_record_by_alarm]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :查询指定报警的报警录象
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-08-17
//modify Info list:
//   2006.10.27   plq   新的方案采取只有一个ftp服务的方式,原先的通过录象服务器的guid去查找ftp服务地址的方式被注释掉
//   2007.05.09   plq   去掉video_server_id, point_name, point_addr字段
*/
CREATE PROCEDURE dbo.sp_query_record_by_alarm
(
	@strUserAccount varchar(32),			--用户帐号
	@intAlarmID int                                 		--报警ID
)
AS

	--获取ftp地址
	declare @strFtpInfo varchar(200)
	exec sp_get_record_ftp_info @strUserAccount, @strFtpInfo output

	SELECT 
		alarm_id, 
		record_type, 
		duration_s, 
		video_server_sn, 
		video_server_name,
		alarm_time, 
		record_state, 
		( @strFtpInfo + file_path)  whole_file_path 
	FROM
		v_alarm_record_file  
	WHERE
		alarm_id =  @intAlarmID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

