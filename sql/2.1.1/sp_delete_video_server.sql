if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_delete_video_server]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_delete_video_server]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO




/*
//Description :报废视频服务器
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2008-02-29
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_delete_video_server
(
	@video_server_sn          char(16),
	@tree_id                   	int
)
AS
	
	begin tran 

	/*=====================================删除视频服务器连接设备===================================*/
	--删除云台
	print '删除云台t_tree'
	DELETE t_tree WHERE device_type_id = 6  and exists(SELECT GUID FROM t_ptz WHERE video_server_guid = @video_server_sn and GUID = t_tree.device_guid)
	if @@ERROR <> 0 rollback tran

	print '删除云台t_device_role_device'
	DELETE t_device_role_device WHERE device_type_id = 6  and exists(SELECT GUID FROM t_ptz WHERE video_server_guid = @video_server_sn and GUID = t_device_role_device.device_guid)
	if @@ERROR <> 0 rollback tran

	print '删除云台预置位t_advance_position'
	DELETE t_advance_position WHERE exists(SELECT ptz_id FROM t_ptz WHERE video_server_guid = @video_server_sn and ptz_id = t_advance_position.ptz_id)
	if @@ERROR <> 0 rollback tran

	print '删除云台辅助位t_assistant_device'
	DELETE t_assistant_device WHERE exists(SELECT ptz_id FROM t_ptz WHERE video_server_guid = @video_server_sn and ptz_id = t_assistant_device.ptz_id)
	if @@ERROR <> 0 rollback tran

	print '删除云台t_ptz'
	DELETE t_ptz WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	--删除摄像头
	print '删除摄像头t_tree'
	DELETE t_tree WHERE device_type_id = 5  and exists(SELECT GUID FROM t_lens WHERE video_server_guid = @video_server_sn and GUID = t_tree.device_guid)
	if @@ERROR <> 0 rollback tran

	print '删除摄像头t_device_role_device'
	DELETE t_device_role_device WHERE device_type_id = 5  and exists(SELECT GUID FROM t_lens WHERE video_server_guid = @video_server_sn and GUID = t_device_role_device.device_guid)
	if @@ERROR <> 0 rollback tran

	print '删除摄像头t_lens'
	DELETE t_lens WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	--删除矩阵
	print '删除矩阵t_tree'
	DELETE t_tree WHERE device_type_id = 4  and exists(SELECT GUID FROM t_matrix WHERE video_server_guid = @video_server_sn and GUID = t_tree.device_guid)
	if @@ERROR <> 0 rollback tran

	print '删除矩阵t_device_role_device'
	DELETE t_device_role_device WHERE device_type_id = 4  and exists(SELECT GUID FROM t_matrix WHERE video_server_guid = @video_server_sn and GUID = t_device_role_device.device_guid)
	if @@ERROR <> 0 rollback tran

	print '删除矩阵输入端口t_matrix_inputport'
	DELETE t_matrix_inputport WHERE exists(SELECT matrix_id FROM t_matrix WHERE video_server_guid = @video_server_sn and matrix_id = t_matrix_inputport.matrix_id)
	if @@ERROR <> 0 rollback tran

	print '删除矩阵输出端口t_matrix_outputport'
	DELETE t_matrix_outputport WHERE exists(SELECT matrix_id FROM t_matrix WHERE video_server_guid = @video_server_sn and matrix_id = t_matrix_outputport.matrix_id)
	if @@ERROR <> 0 rollback tran

	print '删除矩阵串口t_matrix_serialport'
	DELETE t_matrix_serialport WHERE exists(SELECT matrix_id FROM t_matrix WHERE video_server_guid = @video_server_sn and matrix_id = t_matrix_serialport.matrix_id)
	if @@ERROR <> 0 rollback tran

	print '删除矩阵t_matrix'
	DELETE t_matrix WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran


	/*==========================================删除视频服务器子设备=========================================*/
	print '删除视频输入端口t_video_input_port'
	DELETE t_video_input_port WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	/*
	print '删除视频编码器t_video_encoder'
	DELETE t_video_encoder WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran
	

	print '删除音频编码器t_audio_encoder'
	DELETE t_audio_encoder WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除音频解码器t_audio_decoder'
	DELETE t_audio_decoder WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran
	*/

	print '删除串口t_serial_port'
	DELETE t_serial_port  WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除输出端口t_output_port'
	DELETE t_output_port  WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除输入端口t_input_port'
	DELETE t_input_port WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	/*
	print '删除音频输入端口t_audio_input_port'
	DELETE t_audio_input_port WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran
	*/

	/*==============================================删除视频服务器配置信息=======================================*/
	print '删除视频会议用户绑定设备vc_video_conference_user'
	DELETE vc_video_conference_user  WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除轮跳设置t_turn_plan_set'
	DELETE t_turn_plan_set  WHERE VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除转发规则t_event_sender_set'
	DELETE t_event_sender_set WHERE alarm_type <> 7 AND device_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除设备CA证书t_ca_device'
	DELETE t_ca_device WHERE video_server_sn = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除报警联动配置表t_alarm_linkage'
	DELETE t_alarm_linkage WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除报警联动动作定义表t_alarm_linkage_action'
	DELETE t_alarm_linkage_action WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除地图上的设备am_map_position'
	DELETE am_map_position WHERE video_server_sn = @video_server_sn
	if @@ERROR <> 0 rollback tran

	/*
	print '删除地图上的设备t_map_position'
	DELETE t_map_position  WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran
	*/

	print '删除录象计划am_plan_recordl'
	DELETE am_plan_record WHERE video_server_sn = @video_server_sn
	if @@ERROR <> 0 rollback tran

	/*
	print '删除录象参数t_kinescope_param'
	DELETE t_kinescope_param  WHERE video_server_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran
	*/

	print '删除报警预置位联动设置am_alarm_ptz_preset'
	DELETE am_alarm_ptz_preset WHERE video_server_sn = @video_server_sn
	if @@ERROR <> 0 rollback tran

	print '删除报警预置位联动设置am_alarm_action_serials'
	DELETE am_alarm_action_serials WHERE video_server_sn = @video_server_sn
	if @@ERROR <> 0 rollback tran


	/*==========================================删除视频服务器=============================================*/
	print '删除设备树t_tree'
	DELETE t_tree WHERE device_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	DELETE t_tree WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	print '删除角色设备树t_device_role_device'
	DELETE  t_device_role_device WHERE device_guid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	DELETE  t_device_role_device WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	print '删除视频服务器t_video_server'
	--modified by plq 2009.09.10  不从物理上删除
	--DELETE  t_video_server WHERE VideoServGuid = @video_server_sn
	update t_video_server set video_server_id = 0, point_id = 0 where VideoServGuid = @video_server_sn
	if @@ERROR <> 0 rollback tran

	commit tran
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

