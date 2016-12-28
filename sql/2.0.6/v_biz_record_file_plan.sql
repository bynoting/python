if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_biz_record_file_plan]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_biz_record_file_plan]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

------------------------------------------------------------------------------------
-- 描述：计划录像任务产生的录像文件
-- 作者：zhangtao, 20080310
-- 备注：现在使用video_server_sn来找设备，将来用device_guid
------------------------------------------------------------------------------------
CREATE VIEW dbo.v_biz_record_file_plan
AS
SELECT 
	dbo.v_biz_record_file.biz_guid,
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
	dbo.v_plan_record_log.plan_guid,
	dbo.v_plan_record_log.plan_id, 
	dbo.v_plan_record_log.plan_name,
	dbo.v_plan_record_log.plan_type, 
	dbo.v_plan_record_log.task_type,
	dbo.v_plan_record_log.begin_datetime,
	dbo.v_plan_record_log.end_datetime, 
	dbo.v_plan_record_log.guid,
	dbo.v_plan_record_log.video_server_sn, 
	dbo.v_plan_record_log.video_channel_guid,
	dbo.v_plan_record_log.log_state,
	dbo.v_plan_record_log.service_guid, 
	dbo.v_plan_record_log.log_begin_time,
	dbo.v_plan_record_log.log_end_time, 
	dbo.v_plan_record_log.log_message
FROM dbo.v_biz_record_file 
	inner join dbo.v_plan_record_log on dbo.v_plan_record_log.log_guid = dbo.v_biz_record_file.biz_guid
	where dbo.v_biz_record_file.biz_type = 2 /* biz_type 为 2 表示 计划任务业务 */
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

