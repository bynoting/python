if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_analysis_data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_analysis_data]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
//Description :分析整理数据
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-12-25
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_analysis_data AS
	--删除云台t_ptz
	print '删除云台t_ptz'
	DELETE t_ptz WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_ptz.video_server_guid)
	DELETE t_tree WHERE device_type_id = 6  and not exists(SELECT GUID FROM t_ptz WHERE GUID = t_tree.device_guid)
	DELETE t_ptz WHERE not exists(SELECT tree_id FROM t_tree WHERE device_type_id = 6 and device_guid = t_ptz.GUID)

	--删除云台预置位t_advance_position
	print '删除云台预置位t_advance_position'
	DELETE t_advance_position WHERE not exists(SELECT ptz_id FROM t_ptz WHERE ptz_id = t_advance_position.ptz_id)

	--删除云台辅助位t_assistant_device
	print '删除云台辅助位t_assistant_device'
	DELETE t_assistant_device WHERE not exists(SELECT ptz_id FROM t_ptz WHERE ptz_id = t_assistant_device.ptz_id)

	--删除摄像头t_lens
	print '删除摄像头t_lens'
	DELETE t_lens WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_lens.video_server_guid)
	DELETE t_tree WHERE device_type_id = 5  and not exists(SELECT GUID FROM t_lens WHERE GUID = t_tree.device_guid)
	DELETE t_lens WHERE not exists(SELECT tree_id FROM t_tree WHERE device_type_id = 5 and device_guid = t_lens.GUID)

	--删除矩阵t_matrix
	print '删除矩阵t_matrix'
	DELETE t_matrix WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_matrix.video_server_guid)
	DELETE t_tree WHERE device_type_id = 4  and not exists(SELECT GUID FROM t_matrix WHERE GUID = t_tree.device_guid)
	DELETE t_matrix WHERE not exists(SELECT tree_id FROM t_tree WHERE device_type_id = 4 and device_guid = t_matrix.GUID)

	--删除矩阵输入端口t_matrix_inputport
	print '删除矩阵输入端口t_matrix_inputport'
	DELETE t_matrix_inputport WHERE not exists(SELECT matrix_id FROM t_matrix WHERE matrix_id = t_matrix_inputport.matrix_id)

	--删除矩阵输出端口t_matrix_outputport
	print '删除矩阵输出端口t_matrix_outputport'
	DELETE t_matrix_outputport WHERE not exists(SELECT matrix_id FROM t_matrix WHERE matrix_id = t_matrix_outputport.matrix_id)

	--删除矩阵串口t_matrix_serialport
	print '删除矩阵串口t_matrix_serialport'
	DELETE t_matrix_serialport WHERE not exists(SELECT matrix_id FROM t_matrix WHERE matrix_id = t_matrix_serialport.matrix_id)

	--删除设备树t_tree
	print '删除设备树t_tree'
	DELETE t_tree WHERE device_type_id = 3  and not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_tree.device_guid)

	--删除角色设备树t_device_role_device
	print '删除角色设备树t_device_role_device'
	DELETE  t_device_role_device WHERE not exists(SELECT tree_id FROM  t_tree WHERE tree_id = t_device_role_device.tree_id)

	--删除视频会议用户绑定设备vc_video_conference_user
	print '删除视频会议用户绑定设备vc_video_conference_user'
	DELETE vc_video_conference_user  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = ltrim(rtrim(vc_video_conference_user.video_server_guid)))

	--删除视频输入端口t_video_input_port
	print '删除视频输入端口t_video_input_port'
	DELETE t_video_input_port WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_video_input_port.VideoServGuid)

  	--删除视频编码器t_video_encoder
	print '删除视频编码器t_video_encoder'
	DELETE t_video_encoder WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_video_encoder.VideoServGuid)

  	--删除轮跳设置t_turn_plan_set
	print '删除轮跳设置t_turn_plan_set'
	DELETE t_turn_plan_set  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = ltrim(rtrim(t_turn_plan_set.VideoServGuid)))

  	--删除串口t_serial_port
	print '删除串口t_serial_port'
	DELETE t_serial_port  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_serial_port.VideoServGuid)

  	--删除输出端口t_output_port
	print '删除输出端口t_output_port'
	DELETE t_output_port  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_output_port.VideoServGuid)

  	--删除地图上的设备t_map_position
	print '删除地图上的设备t_map_position'
	DELETE t_map_position  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_map_position.video_server_guid)

	--删除录象计划t_kinescope_plan
	print '删除录象计划t_kinescope_plan'
	DELETE t_kinescope_plan WHERE not exists(SELECT state FROM t_video_server WHERE video_server_id  = t_kinescope_plan.video_server_id)

  	--删除录象参数t_kinescope_param
	print '删除录象参数t_kinescope_param'
	DELETE t_kinescope_param  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_kinescope_param.video_server_guid)

	--删除输入端口事件t_inputport_event
	print '删除输入端口事件t_inputport_event'
	DELETE t_inputport_event  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_inputport_event.VideoServerGuid)

	--删除输入端口操作t_input_port_action
	print '删除输入端口操作t_input_port_action'
	DELETE t_input_port_action  WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_input_port_action.video_server_guid)

	--删除输入端口t_input_port
	print '删除输入端口t_input_port'
	DELETE t_input_port WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_input_port.VideoServGuid)

	--删除转发规则t_event_sender_set
	print '删除转发规则t_event_sender_set'
	DELETE t_event_sender_set WHERE alarm_type <> 7 AND not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_event_sender_set.device_guid)

	--删除设备CA证书t_ca_device
	--print '删除设备CA证书t_ca_device'
	--DELETE t_ca_device WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_ca_device.video_server_sn)

	--删除音频输入端口t_audio_input_port
	print '删除音频输入端口t_audio_input_port'
	DELETE t_audio_input_port WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_audio_input_port.VideoServGuid)

	--删除音频编码器t_audio_encoder
	print '删除音频编码器t_audio_encoder'
	DELETE t_audio_encoder WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_audio_encoder.VideoServGuid)

	--删除音频解码器t_audio_decoder
	print '删除音频解码器t_audio_decoder'
	DELETE t_audio_decoder WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_audio_decoder.VideoServGuid)

	--删除报警联动动作定义表t_alarm_linkage_action
	print '删除报警联动动作定义表t_alarm_linkage_action'
	DELETE t_alarm_linkage_action WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = ltrim(rtrim(t_alarm_linkage_action.video_server_guid)))

	--删除报警联动配置表t_alarm_linkage
	print '删除报警联动配置表t_alarm_linkage'
	DELETE t_alarm_linkage WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = ltrim(rtrim(t_alarm_linkage.video_server_guid)))

	--删除设备上下线日志表DEVICEONLINELOG
	print '删除设备上下线日志表DEVICEONLINELOG'
	DELETE  DEVICEONLINELOG WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = DEVICEONLINELOG.Guid)

	--删除报警日志表
	--print '删除报警日志表'
	--DELETE t_alarm_log WHERE  not exists(SELECT state FROM t_video_server WHERE VideoServGuid = ltrim(rtrim(t_alarm_log.device_guid)))

	--删除报警转发日志表
	--print '删除报警转发日志表'
	--DELETE t_alarm_transmit_log WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = t_alarm_transmit_log.video_server_sn)

	--删除报警录象日志表
	--print '删除报警录象日志表'
	--DELETE t_alarm_kinescope_log WHERE not exists(SELECT id FROM t_alarm_log WHERE id = t_alarm_kinescope_log.alarmId)

	--删除报警预置位联动设置
	print '删除报警预置位联动设置'
	DELETE am_alarm_ptz_preset WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = am_alarm_ptz_preset.video_server_sn)
	DELETE am_alarm_action_serials WHERE not exists(SELECT state FROM t_video_server WHERE VideoServGuid = am_alarm_action_serials.video_server_sn)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

