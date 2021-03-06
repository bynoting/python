if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_alarm_ptz_preset_update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarm_ptz_preset_update]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
//Description :报警预置位联动设置
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2007-04-12
//modify Info list:
//   modified by  plq 2007.05.14
*/

CREATE PROCEDURE dbo.sp_alarm_ptz_preset_update
	@guid                     	uniqueidentifier,          --guid
	@video_server_sn  	char(16),                     --视频服务器序列号
	@port			int,                              --报警端口
	@lens_id		int,                              --转动的摄像头id
	@ptz_id			int,                              --控制的云台id
	@position_number	int,                              --转动的目标预置位
	@command		varbinary(100),                --透明协议指令
	@remark		varchar(200),
	@data_create_user	nvarchar(36),  
	@mode			int                               --设置方式 0:插入  1:更新   -1:删除
AS
	DECLARE @myid uniqueidentifier

	--查询得到ptz连接的串口
	declare @video_serial_port int
	select @video_serial_port = video_serial_port_no  from t_ptz where ptz_id = @ptz_id

	--插入
	if @mode = 0 
	begin
		--获取新的id
		SET @myid = NEWID()

		--插入数据到防区联动动作表
		insert into am_alarm_action_serials(
			guid,
			video_server_sn, 
			zone_id, 
			serial_port, 
			command)
		values(
			@myid,
			@video_server_sn,
			@port,
			@video_serial_port,
			@command)

		--插入数据到报警联动预置位设置表
		insert into am_alarm_ptz_preset(
			video_server_sn,
			zone_id,
			lens_id,
			ptz_id,
			position_number,
			action_guid,
			remark,
			data_create_user)
		values(
			@video_server_sn,
			@port,
			@lens_id,
			@ptz_id,
			@position_number,
			@myid,
			@remark,
			@data_create_user)

		return ;
	end
	
	--更新
	if @mode = 1
	begin
		select @myid = action_guid from am_alarm_ptz_preset where guid = @guid

		update am_alarm_action_serials
		set
			serial_port = @video_serial_port,
			command = @command
		where
			guid = @myid

		update am_alarm_ptz_preset
		set 
			lens_id = @lens_id, 
			ptz_id = @ptz_id,
			position_number = @position_number,
			remark = @remark
		where
			guid = @guid

		return
	end


	--删除
	select @myid = action_guid from am_alarm_ptz_preset where guid = @guid

	delete am_alarm_action_serials
	where
		guid = @myid

	delete am_alarm_ptz_preset
	where
		guid = @guid
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

