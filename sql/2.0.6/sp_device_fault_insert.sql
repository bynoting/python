if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_device_fault_insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_device_fault_insert]
GO
----------------------------------------------------------------------------------------------------------------------------
--存储过程: sp_device_fault_insert
--描述:     向设备故障表中加入故障记录,如果要清除当前故障则将@fault_type_array传空或'999'
--作者:     zhangtao, 200704
----------------------------------------------------------------------------------------------------------------------------
CREATE   PROCEDURE dbo.sp_device_fault_insert(
	/** 设备序列号 */
	@video_server_sn char (16), 
	/** 故障类型的列表,以'|'分割, 格式如: 001|021|018 */
	@fault_type_array varchar (300)   
    )
AS
	declare @report_time datetime
	declare @strlist varchar(50),@pos int, @delim char, @type varchar(50)
	declare @guid guid
		
	set @report_time = getdate()
	set @strlist = replace(@fault_type_array,'999','')
	set @delim = '|' 
	
	begin tran t1
	while ((len(@strlist) > 0) and (@strlist <> ''))
	begin
		--从故障类型串中解析单个故障类型 
		set @pos = charindex(@delim, @strlist)
	
		if @pos > 0
		begin
			set @type = substring(@strlist, 1, @pos-1)
			set @strlist = ltrim(substring(@strlist,charindex(@delim, @strlist)+1, 8000))
		end
		else
		begin
			set @type = @strlist
			set @strlist = ''
		end

		-- 查找相同设备故障是否存在, 如存在则更新报告时间和报告次数,否则插入新故障记录
		set @guid = null
		select @guid = guid  from am_device_fault where video_server_sn = @video_server_sn and fault_type = @type
		
		if @guid is null
			insert into am_device_fault (video_server_sn,fault_type,last_report_time) values(@video_server_sn,@type,@report_time)
		else
			update am_device_fault set report_count = report_count + 1,last_report_time=@report_time  where guid = @guid
	end

	--将已经恢复的故障移入历史表中
	insert into am_device_fault_his  select * from am_device_fault where video_server_sn = @video_server_sn and last_report_time <> @report_time
	delete from am_device_fault where video_server_sn = @video_server_sn and last_report_time <> @report_time
	commit tran t1
GO
