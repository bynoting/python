if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_am_notice_state_update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_am_notice_state_update]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
/*
//Description :分析公告是否过期
//Company :GTAlarm 
//author: 胡云丰
//Create Date :2008-10-21
*/

CREATE PROCEDURE dbo.sp_am_notice_state_update AS

	DECLARE @now DATETIME
	SET @now = getdate()
	print @now

	UPDATE am_notice SET notice_state=2 where notice_state=1 and  datetime_end<@now
GO

-- 2008-10-28/17:38 上生成的脚本
-- 由: gtalarm
-- 服务器: 192.168.1.41

BEGIN TRANSACTION            
  DECLARE @JobID BINARY(16)  
  DECLARE @ReturnCode INT    
  SELECT @ReturnCode = 0     
IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'Database Maintenance') < 1 
  EXECUTE msdb.dbo.sp_add_category @name = N'Database Maintenance'

  -- 删除同名的警报（如果有的话）。
  SELECT @JobID = job_id     
  FROM   msdb.dbo.sysjobs    
  WHERE (name = N'am_notice_state_update')       
  IF (@JobID IS NOT NULL)    
  BEGIN  
  -- 检查此作业是否为多重服务器作业  
  IF (EXISTS (SELECT  * 
              FROM    msdb.dbo.sysjobservers 
              WHERE   (job_id = @JobID) AND (server_id <> 0))) 
  BEGIN 
    -- 已经存在，因而终止脚本 
    RAISERROR (N'无法导入作业“am_notice_state_update”，因为已经有相同名称的多重服务器作业。', 16, 1) 
    GOTO QuitWithRollback  
  END 
  ELSE 
    -- 删除［本地］作业 
    EXECUTE msdb.dbo.sp_delete_job @job_name = N'am_notice_state_update' 
    SELECT @JobID = NULL
  END 

BEGIN 

  -- 添加作业
  EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , @job_name = N'am_notice_state_update', @owner_login_name = N'gtalarm', @description = N'根据日期更新公告状态', @category_name = N'Database Maintenance', @enabled = 1, @notify_level_email = 0, @notify_level_page = 0, @notify_level_netsend = 0, @notify_level_eventlog = 2, @delete_level= 0
  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- 添加作业步骤
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'update_notice_state', @command = N'EXECUTE   sp_am_notice_state_update', @database_name = N'gtalarm', @server = N'', @database_user_name = N'', @subsystem = N'TSQL', @cmdexec_success_code = 0, @flags = 4, @retry_attempts = 5, @retry_interval = 3, @output_file_name = N'', @on_success_step_id = 0, @on_success_action = 1, @on_fail_step_id = 0, @on_fail_action = 2
  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
  EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- 添加作业调度
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'am_notice_state_update_schedule', @enabled = 1, @freq_type = 4, @active_start_date = 19900101, @active_start_time = 0, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_end_date = 99991231, @active_end_time = 235959
  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- 添加目标服务器
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)' 
  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

END
COMMIT TRANSACTION          
GOTO   EndSave              
QuitWithRollback:
  IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 
EndSave: 


