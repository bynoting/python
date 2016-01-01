if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_move_device_fault_log]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_move_device_fault_log]
GO

--------------------------------------------------------------------------------------------------------------------
-- 描述: 将APP2.0.6以前的数据库中的设备故障表的数据导入新表
-- 注意: 由于该表数据太多,处理会较慢. 参考测试结果: 赛扬的PC机上, 100万条数据大约用去半个小时
-- 提示: 由于处理太慢而原表内容角度, 请考虑从原表中删除数据,仅保留最近一段时间的故障记录
--------------------------------------------------------------------------------------------------------------------
create procedure dbo.spt_move_device_fault_log 
as
declare @video_server_sn char (16)
declare @report_time datetime
declare @type varchar(4)
declare @guid guid
declare @id int

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_device_fault_log]') )
begin
	print 'error: am_device_fault_log is not exists'
	return
end	

while 1 = 1
begin
	set @id = null
	select top 1 @id = id,@video_server_sn = video_server_sn,@type = fault_type,@report_time=data_create_time from am_device_fault_log order by id asc

	if @id is null
		break
	
	print @id

	if @type = '999'	
	begin 
		print 'reset: ' + @video_server_sn  
		/**将已经恢复的故障移入历史表中*/
		insert into am_device_fault_his select * from am_device_fault where video_server_sn = @video_server_sn
		if @@rowcount > 0
			delete from am_device_fault where video_server_sn = @video_server_sn
	end 
	else
	begin
		/** 查找相同设备故障是否存在, 如存在则更新报告时间和报告次数,否则插入新故障记录*/
		set @guid = null
		select @guid = guid  from am_device_fault where video_server_sn = @video_server_sn and fault_type = @type
		
		if @guid is null
			insert into am_device_fault (video_server_sn,fault_type,last_report_time,data_create_time) values(@video_server_sn,@type,@report_time,@report_time)
		else
			update am_device_fault set report_count = report_count + 1,last_report_time=@report_time  where guid = @guid
	end

	delete am_device_fault_log where id = @id
end

go
