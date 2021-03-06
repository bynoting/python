if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_delete_matrix]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_delete_matrix]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :删除矩阵
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2008-02-29
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_delete_matrix
(
	@guid          		char(36),
	@tree_id                   	int
)
AS
	declare @matrix_id int
	
	-- 获取矩阵相关信息
	SELECT @matrix_id = matrix_id FROM t_matrix WHERE guid = @guid 

	begin tran 

	-- ==================================删除云台
	-- '删除云台t_tree'
	DELETE t_tree WHERE device_type_id = 6  and exists(SELECT GUID FROM t_ptz WHERE device_guid = @guid and GUID = t_tree.device_guid)
	if @@ERROR <> 0 rollback tran

	-- '删除云台t_device_role_device'
	DELETE t_device_role_device WHERE device_type_id = 6  and exists(SELECT GUID FROM t_ptz WHERE device_guid = @guid and GUID = t_device_role_device.device_guid)
	if @@ERROR <> 0 rollback tran

	-- '删除云台预置位t_advance_position'
	DELETE t_advance_position WHERE exists(SELECT ptz_id FROM t_ptz WHERE device_guid = @guid and ptz_id = t_advance_position.ptz_id)
	if @@ERROR <> 0 rollback tran

	-- '删除云台辅助位t_assistant_device'
	DELETE t_assistant_device WHERE exists(SELECT ptz_id FROM t_ptz WHERE device_guid = @guid and ptz_id = t_assistant_device.ptz_id)
	if @@ERROR <> 0 rollback tran

	-- '删除云台t_ptz'
	DELETE t_ptz WHERE device_guid = @guid
	if @@ERROR <> 0 rollback tran


	-- =================================删除摄像头
	-- '删除摄像头t_tree'
	DELETE t_tree WHERE device_type_id = 5  and exists(SELECT GUID FROM t_lens WHERE device_guid = @guid and GUID = t_tree.device_guid)
	if @@ERROR <> 0 rollback tran

	-- '删除摄像头t_device_role_device'
	DELETE t_device_role_device WHERE device_type_id = 5  and exists(SELECT GUID FROM t_lens WHERE device_guid = @guid and GUID = t_device_role_device.device_guid)
	if @@ERROR <> 0 rollback tran

	-- '删除摄像头t_lens'
	DELETE t_lens WHERE device_guid = @guid
	if @@ERROR <> 0 rollback tran


	-- =================================删除矩阵
	-- 更新矩阵连接的视频输入端口
	UPDATE t_video_input_port  SET is_use = 0  WHERE exists(SELECT video_inputport_id FROM t_matrix_outputport WHERE matrix_id= @matrix_id and video_inputport_id = t_video_input_port.video_input_port_id)
	if @@ERROR <> 0 rollback tran

	-- '删除矩阵t_tree'
	DELETE t_tree WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	-- '删除矩阵t_device_role_device'
	DELETE t_device_role_device WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	-- '删除矩阵输入端口t_matrix_inputport'
	DELETE t_matrix_inputport WHERE matrix_id = @matrix_id
	if @@ERROR <> 0 rollback tran

	-- '删除矩阵输出端口t_matrix_outputport'
	DELETE t_matrix_outputport WHERE matrix_id = @matrix_id
	if @@ERROR <> 0 rollback tran

	-- '删除矩阵串口t_matrix_serialport'
	DELETE t_matrix_serialport WHERE matrix_id = @matrix_id
	if @@ERROR <> 0 rollback tran

	-- '删除矩阵t_matrix'
	DELETE t_matrix WHERE guid = @guid
	if @@ERROR <> 0 rollback tran

	commit tran
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

