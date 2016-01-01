if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_plan_task_timeout]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_plan_task_timeout]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

------------------------------------------------------------------------------------
-- 描述： 正在执行的且超时的计划任务
-- 作者：zhangtao, 20080226
------------------------------------------------------------------------------------
CREATE VIEW dbo.v_plan_task_timeout
AS
SELECT *
FROM dbo.am_plan_log
WHERE (state = 1) AND (begin_time <
          (SELECT dateadd(second, - delta_seconds, getdate())
         FROM am_plan
         WHERE guid = am_plan_log.plan_guid))


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO