if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_plan_record_log]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_plan_record_log]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

------------------------------------------------------------------------------------
-- 描述：计划录像执行情况的详细信息
-- 作者：zhangtao, 20080226
-- 备注：没有执行记录的计划不被列出 
------------------------------------------------------------------------------------
CREATE VIEW dbo.v_plan_record_log
AS
SELECT 
    dbo.am_plan.guid as plan_guid,
		dbo.am_plan.id as plan_id,
		dbo.am_plan.name as plan_name,
		dbo.am_plan.plan_type, 
		dbo.am_plan.task_type,
		dbo.am_plan.is_valid,
		dbo.am_plan.begin_datetime, 
		dbo.am_plan.end_datetime,
		dbo.am_plan_record.guid,
		dbo.am_plan_record.record_type, 
		dbo.am_plan_record.video_server_sn,
		dbo.am_plan_record.video_channel_guid, 
		dbo.am_plan_record.data_create_user,
		dbo.am_plan_record.data_create_time,
		dbo.am_plan_log.guid as log_guid,
		dbo.am_plan_log.state as log_state, 
		dbo.am_plan_log.service_guid,
		dbo.am_plan_log.begin_time as log_begin_time, 
		dbo.am_plan_log.end_time as log_end_time,
		dbo.am_plan_log.message as log_message
FROM dbo.am_plan 
    INNER JOIN dbo.am_plan_record ON dbo.am_plan_record.plan_guid = dbo.am_plan.guid 
    INNER JOIN dbo.am_plan_log 	ON dbo.am_plan_log.plan_x_guid  = dbo.am_plan_record.guid

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

