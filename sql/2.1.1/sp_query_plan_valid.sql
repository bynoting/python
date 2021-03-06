/****** 对象: 存储过程 dbo.sp_query_plan_valid    脚本日期: 2010-6-8 16:21:06 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_plan_valid]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_plan_valid]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

/****** 对象: 存储过程 dbo.sp_query_plan_valid    脚本日期: 2010-6-8 16:21:06 ******/
--------------------------------------------------------------------------------------------------------------      
--Name  :  	sp_query_plan_valid                                         
--Function  :  查询当前可执行的计划                                            
--Author:  	zhangtao 
--Date  :  	2008-02-20                    
--Note : 	需要过滤的条件： 
-- 		1 根据不同计划类型和当前时间过滤得到当期可执行的计划        
--		2 过滤当前已经执行的计划
--------------------------------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_query_plan_valid (@plan_type int)
AS

declare @now datetime
declare @weekday int
declare @day int

SET DATEFIRST 7

set @now = getdate()
print(@now)
set @weekday = datepart(weekday,@now)
print(@weekday)
set @day = day(@now)
print(@day)

-- only once
select guid  from am_plan where is_valid = 1 and task_type = 0 and plan_type = @plan_type
	and @now >= begin_datetime  
	and @now <= end_datetime
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid)
union all
-- daily 
-- 把开始和结束时间换算到今天进行对比
select guid  from am_plan where is_valid = 1 and task_type = 1 and plan_type = @plan_type
	and @now >= dbo.f_replace_time(@now, begin_time)
	and @now <= dateadd(second, delta_seconds,  dbo.f_replace_time(@now,begin_time)) 
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid and convert(varchar,begin_time,102) = convert(varchar,@now,102))
union all
-- weekly 
-- 把开始和结束时间换算到本周的对应时间进行对比
select guid from am_plan where is_valid = 1 and task_type = 2 and plan_type = @plan_type
	and begin_weekday = @weekday
	and @now >= dateadd(day, datediff(day,begin_datetime,@now), begin_datetime) 
	and @now <= dateadd(second, delta_seconds, dateadd(day,datediff(day,begin_datetime,@now), begin_datetime))
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and datediff(day,begin_time,@now) < 7 ) 
union all 
-- monthly
-- 把开始和结束时间换算到本月的对应时间进行对比
select guid  from am_plan where is_valid = 1 and task_type = 3 and plan_type = @plan_type
	and begin_day = @day
	and @now >= dateadd(day, datediff(day,begin_datetime,@now), begin_datetime) 
	and @now <= dateadd(second,delta_seconds, dateadd(day, datediff(day,begin_datetime,@now), begin_datetime))
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and datediff(day,begin_time,@now) < dbo.f_days_of_month(dateadd(day,-(day(@now)),@now)))
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

