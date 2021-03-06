if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_alarm_preset_update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarm_preset_update]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.sp_alarm_preset_update
	@guid                     	char(36),                    --guid
	@video_server_sn  	char(16),                    --视频服务器序列号
	@port			int, 
	@lens_id		int,
	@ptz_id			int,
	@position_number	int,
	@command		binary(100),
	@remark		varchar(200),
	@data_create_user	nvarchar(36),  
	@mode			int
AS
	if @mode = 0 
	begin
		insert into am_alarm_preset(
			guid,
			video_server_sn,
			port,
			lens_id,
			ptz_id,
			position_number,
			command,
			remark,
			data_create_user)
		values(
			@guid,
			@video_server_sn,
			@port,
			@lens_id,
			@ptz_id,
			@position_number,
			@command,
			@remark,
			@data_create_user)
	end
	else
	begin
		update am_alarm_preset
		set 
			lens_id = @lens_id, 
			ptz_id = @ptz_id,
			position_number = @position_number,
			command = @command,
			remark = @remark
		where
			guid = @guid
	end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

