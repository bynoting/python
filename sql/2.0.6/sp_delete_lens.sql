if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_delete_lens]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_delete_lens]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :删除摄像头
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2008-02-29
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_delete_lens
(
	@guid          		char(36),
	@tree_id                   	int
)
AS
	declare @lens_id int
	declare @link_type int
	declare @video_input_port_id int

	declare @ptz_guid char(36)
	declare @ptz_tree_id int

	--获取摄像头相关信息
	SELECT  @lens_id = lens_id,   @link_type = link_type,  @video_input_port_id = input_port_id  FROM  t_lens  WHERE  guid = @guid
	if @lens_id is null  return 

	--获取摄像头对应的云台信息
	SELECT  @ptz_guid = guid  FROM t_ptz  WHERE lens_id = @lens_id

	begin tran 

	if @ptz_guid is not null
	begin
		SELECT @ptz_tree_id = tree_id FROM t_tree WHERE device_guid = @ptz_guid
		exec sp_delete_ptz @ptz_guid, @ptz_tree_id
		if @@ERROR <> 0 rollback tran
	end

	--删除摄像头
	-- '删除摄像头t_tree'
	DELETE t_tree WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	-- '删除摄像头t_device_role_device'
	DELETE t_device_role_device WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	-- '删除摄像头t_lens'
	DELETE t_lens WHERE guid = @guid
	if @@ERROR <> 0 rollback tran

	-- '更新摄像头连接的视频端口状态'
	if @link_type = 1
		UPDATE t_video_input_port SET is_use = 0 WHERE video_input_port_id = @video_input_port_id
	else
		UPDATE t_matrix_inputport SET is_use = 0 WHERE input_port_id = @video_input_port_id
	if @@ERROR <> 0 rollback tran

	commit tran
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

