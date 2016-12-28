--------------------------------------------------------------------------
-- 将所有设备Guid的数据类型统一为自定义数据类型
--------------------------------------------------------------------------
exec spt_modify_column_type 't_video_server','VideoServGuid','video_server_sn'

exec spt_modify_column_type 't_audio_encoder','VideoServGuid','video_server_sn'
exec spt_modify_column_type 't_audio_encoder','AudioEncoderGuid',' nvarchar(36)'

exec spt_modify_column_type 't_audio_decoder','AudioDecoderGuid',' nvarchar(36)'
exec spt_modify_column_type 't_audio_decoder','VideoServGuid','video_server_sn'

exec spt_modify_column_type 't_audio_input_port','VideoServGuid','video_server_sn'
exec spt_modify_column_type 't_audio_input_port','AudioInputPortGuid',' nvarchar(36)'

exec spt_modify_column_type 't_input_port','VideoServGuid','video_server_sn'
exec spt_modify_column_type 't_input_port','DiGuid',' nvarchar(36)'

exec spt_modify_column_type 't_output_port','VideoServGuid','video_server_sn'
exec spt_modify_column_type 't_output_port','DoGuid',' nvarchar(36)'

exec spt_modify_column_type 't_serial_port','VideoServGuid','video_server_sn'
exec spt_modify_column_type 't_serial_port','SerialGuid',' nvarchar(36)'

exec spt_modify_column_type 't_turn_plan_set','VideoServGuid','video_server_sn'

--exec spt_modify_column_type 't_video_encoder','VideoServGuid','video_server_sn'
--exec spt_modify_column_type 't_video_encoder','VideoEncoderGuid',' nvarchar(36)'

exec spt_modify_column_type 't_video_input_port','VideoServGuid','video_server_sn'
exec spt_modify_column_type 't_video_input_port','VideoInputPortGuid',' nvarchar(36)'

exec spt_modify_column_type 't_matrix_outputport','video_server_guid','video_server_sn'

exec spt_modify_column_type 't_alarm_linkage','video_server_guid','video_server_sn'
exec spt_modify_column_type 't_alarm_linkage_action','video_server_guid','video_server_sn'
exec spt_modify_column_type 't_kinescope_param','video_server_guid','video_server_sn'
exec spt_modify_column_type 't_lens','video_server_guid','video_server_sn'

exec spt_modify_column_type 't_matrix','video_server_guid','video_server_sn'
exec spt_modify_column_type 't_ptz','video_server_guid','video_server_sn'
exec spt_modify_column_type 'vc_video_conference_user','video_server_guid','video_server_sn'
--exec spt_modify_column_type 't_map_position','video_server_guid','video_server_sn'
exec spt_modify_column_type 't_matrix_outputport','video_server_guid','video_server_sn'

exec spt_modify_column_type 'T_InspectLog','DeviceID','video_server_sn'

exec spt_modify_column_type 't_alarm_log','device_guid','video_server_sn'
exec spt_modify_column_type 'T_event_sender_set','device_guid',' nvarchar(16)'
exec spt_modify_column_type 't_device_role_device','device_guid',' nvarchar(36)'
exec spt_modify_column_type 't_lens','device_guid',' nvarchar(36)'

exec spt_modify_column_type 't_online_user','device_guid','video_server_sn null'

exec spt_modify_column_type 't_ptz','device_guid',' nvarchar(36)'
exec spt_modify_column_type 't_tree','device_guid',' nvarchar(36)'

exec spt_modify_column_type 't_photo','device_guid','video_server_sn'





