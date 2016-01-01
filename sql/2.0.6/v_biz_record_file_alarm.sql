if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_biz_record_file_alarm]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_biz_record_file_alarm]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

---------------------------------------------------
-- 描述： 由报警产生的录像文件视图
-- 作者： zhangtao, 20080310
---------------------------------------------------
CREATE VIEW dbo.v_biz_record_file_alarm
AS
SELECT 
dbo.v_biz_record_file.biz_guid,
dbo.v_biz_record_file.biz_type,
dbo.v_biz_record_file.record_type,
dbo.v_biz_record_file.record_state, 
dbo.v_biz_record_file.message,
dbo.v_biz_record_file.file_path, 
dbo.v_biz_record_file.file_guid,
dbo.v_biz_record_file.name, 
dbo.v_biz_record_file.begin_time,
dbo.v_biz_record_file.width, 
dbo.v_biz_record_file.height,
dbo.v_biz_record_file.video_format, 
dbo.v_biz_record_file.is_has_audio,
dbo.v_biz_record_file.is_valid, 
dbo.v_biz_record_file.duration_s,
dbo.v_biz_record_file.size_k, 
dbo.v_biz_record_file.data_create_user, 
dbo.v_biz_record_file.data_create_time,
dbo.t_alarm_log.id as alarm_id,
dbo.t_alarm_log.point_name, 
dbo.t_alarm_log.point_addr,
dbo.t_alarm_log.alarm_time, 
dbo.t_alarm_log.receiver_name,
dbo.t_alarm_log.alarm_class as alarm_level,
dbo.t_alarm_log.state as alarm_state, 
dbo.t_alarm_log.process_comment,
dbo.t_alarm_log.reset_invoker, 
dbo.t_alarm_log.reset_time,
dbo.t_alarm_log.device_guid as video_server_sn, 
dbo.t_alarm_log.device_name,
dbo.t_alarm_log.comment as alarm_comment, 
dbo.t_alarm_log.alarm_type,
dbo.t_alarm_log.device_alarm_time, 
dbo.t_alarm_log.relieve_invoker, 
dbo.t_alarm_log.relieve_time
FROM dbo.t_alarm_log 
  inner join dbo.v_biz_record_file on dbo.v_biz_record_file.biz_guid = dbo.t_alarm_log.guid
  where dbo.v_biz_record_file.biz_type = 1 /* biz_type 为 1 表示 报警业务 */


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

