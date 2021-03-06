if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_alarm_statistics]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarm_statistics]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :根据用户输入的查询条件进行报警统计
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-08-29
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_alarm_statistics
(
	@get_mode int,                                                       --获取数据的方式.0:查询详细 1:生成报表数据
	@user_account varchar(32),			--用户帐号
	@user_name   varchar(50),                                     --用户名称
	@point_name varchar(100),			--监控点名称
	@device_name varchar(100),			--设备名称
	@device_guid varchar(38),			--设备GUID
	@receiver_name varchar(32),	                           --接警人
	@zone_ids varchar(15),                                           --报警防区
	@alarm_type varchar(1),                                      	--报警类型
	@alarm_class varchar(1) ,                                     	--报警级别
	@state varchar(1),                                               	--处理状态
	@begin_time varchar(30),			--查询起始日期
	@end_time varchar(30)				--查询结束日期
)
AS
declare @isAdmin int
declare @intLength int
declare @WhereString nvarchar(4000)
declare @SQLString nvarchar(4000)

declare @deptCount int
declare @deviceCount int
declare @alarmDeviceCount int 

declare @totalAlarmCount int
declare @cancelAlarmCount int 

set @WhereString = "  WHERE 1 = 1 "

--判断是否为超级系统管理员 1:是   0:不是(设备权限限制)
exec sp_check_is_admin @user_account, @isAdmin output
--print @isAdmin

if  @isAdmin  = 0
begin
	set @WhereString = @WhereString  + " AND EXISTS(select 1 from v_useraccount_device where device_guid = t_alarm_log.device_guid and USERACCOUNT ='"+ @user_account +"' and device_type_id = 3)" 
end

--按监控点名称查询
set @intLength = len(@point_name)
if  @intLength  >=1
	set @WhereString =  @WhereString  + " AND point_name like '%" + @point_name + "%'"

--按前端设备名称查询
set @intLength = len(@device_name)
if  @intLength  >=1 
	set @WhereString =  @WhereString  + " AND device_name like '%" + @device_name + "%'"

--按前端设备guid查询
set @intLength = len(@device_guid)
if  @intLength  >=1
	set @WhereString =  @WhereString  + " AND device_guid like '%" + @device_guid + "%'"

--按报警类型查询
set @intLength = len(@alarm_type)
if  @intLength  >=1
	set @WhereString =  @WhereString  + " AND alarm_type =" + @alarm_type

--按报警级别查询
set @intLength = len(@alarm_class)
if  @intLength  >=1
	set @WhereString =  @WhereString  + " AND alarm_class =" + @alarm_class

--按接警人查询
set @intLength = len(@receiver_name)
if  @intLength  >=1 
	set @WhereString =  @WhereString  + " AND receiver_name like '%" + @receiver_name + "%'"

--按防区查询
set @intLength = len(@zone_ids)
if  @intLength  >=1 
	set @WhereString =  @WhereString  + " AND zone_ids = '" + @zone_ids + "'"

--按处理状态查询
set @intLength = len(@state)
if  @intLength  >=1
	set @WhereString =  @WhereString  + " AND state =" + @state

--按报警时间查询
set @intLength = len(@begin_time)
if  @intLength  >=1
	set @WhereString  = @WhereString + " AND (alarm_time between '" + @begin_time+ "' and '" + @end_time + "' ) " 

--获取报警详细信息
set @SQLString=	"SELECT " +
			"	id, point_id, point_name, device_guid, device_name, point_addr, alarm_time, receiver_name, zone_ids, comment, process_comment, " + 
			"	reset_invoker, reset_time, relieve_invoker, relieve_time, loadrecord_finish, state, " +
			"	(select name from t_alarm_type where code = alarm_type) alarm_type_name, " +
			"	(select principal + '(' + teleph + ')' from t_watch_point where point_id = t_alarm_log.point_id ) as linkman, " +
			"	(select codename from t_codediction where codetype = 'ALARM_CLASS' and codevalue = convert(varchar, alarm_class)) alarm_class_name, " +
			"	(select codename from t_codediction where codetype = 'ALARM_HANDLE_STATE' and codevalue = convert(varchar, state)) state_name " +
			"FROM " +
			"	t_alarm_log " +   @WhereString
-- 排序方式
if @get_mode = 0
	set @SQLString = @SQLString + " order by id desc "
else
	set @SQLString = @SQLString + " order by point_id  "

--print @SQLString
execute sp_executesql @SQLString

if @get_mode = 0 return

--获取入网监控点数和入网设备数
if  @isAdmin  = 0
begin
	select @deptCount = count(tree_id) from v_useraccount_device where USERACCOUNT = @user_account and device_type_id = 2
	select @deviceCount = count(tree_id) from v_useraccount_device where USERACCOUNT = @user_account and device_type_id = 3
end
else
begin
	select @deptCount = count(point_id) from t_watch_point
	select @deviceCount = count(VideoServGuid) from t_video_server
end

--获取报警设备数
set @SQLString = " select @alarmDeviceCount = count(distinct device_guid) from t_alarm_log " +  @WhereString
--print @SQLString
execute sp_executesql  @SQLString, N'@alarmDeviceCount int output', @alarmDeviceCount output


--获取总报警次数
set @SQLString = " select @totalAlarmCount = count(id) from t_alarm_log " +  @WhereString
--print @SQLString
execute sp_executesql @SQLString, N'@totalAlarmCount int output', @totalAlarmCount output

--获取误报次数
set @SQLString = " select @cancelAlarmCount = count(id) from t_alarm_log " +  @WhereString + " AND alarm_class = 0"
--print @SQLString
execute sp_executesql @SQLString, N'@cancelAlarmCount int output', @cancelAlarmCount output

--获取报警统计信息
select 
	@deptCount as total_department_count, 
	@deviceCount as total_device_count, 
	@alarmDeviceCount as alarm_device_count,
	@totalAlarmCount as total_alarm_count, 
	@totalAlarmCount - @cancelAlarmCount as actual_alarm_count,
	@cancelAlarmCount as cancel_alarm_count

--获取按监控点统计信息
set @SQLString = " select point_id, point_name, count(distinct device_guid) as alarm_device_count from  t_alarm_log " +  @WhereString + " group by point_id, point_name" 
--print @SQLString
execute sp_executesql @SQLString
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

