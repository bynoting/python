if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_plan_valid]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[sp_query_plan_valid]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
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
declare @time varchar(8)
declare @weekday int
declare @day int

SET DATEFIRST 1 /*以周一为一周开始*/

set @now = getdate()
set @time = convert(varchar,@now,8)
set @weekday = datepart(weekday,@now)
set @day = day(@now)

-- only once
select guid  from am_plan where is_valid = 1 and task_type = 0 and plan_type = @plan_type
	and end_datetime > @now and begin_datetime < @now
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid)
union all
-- daily 
-- 把开始和结束时间换算到今天进行对比
select guid  from am_plan where is_valid = 1 and task_type = 1 and plan_type = @plan_type
	and @now > dbo.f_replace_time(@now,begin_time) -- 替换开始时间的deate部分
	and @now < dateadd(second,delta_seconds,dbo.f_replace_time(@now,begin_time)) 
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and convert(varchar,begin_time,2) = convert(varchar,@now,2))
union all
-- weekly 
-- 把开始和结束时间换算到本周的对应时间进行对比
select guid from am_plan where is_valid = 1 and task_type = 2 and plan_type = @plan_type
	and @now > dateadd(day,datediff(day,begin_datetime,@now) - @weekday + begin_weekday,begin_datetime) 
	and @now < dateadd(second,delta_seconds,dateadd(day,datediff(day,begin_datetime,@now) - @weekday + begin_weekday,begin_datetime))
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and datediff(day,begin_time,@now) < 7 ) 
union all 
-- monthly
-- 把开始和结束时间换算到本月的对应时间进行对比
select guid  from am_plan where is_valid = 1 and task_type = 3 and plan_type = @plan_type
	and @now > dateadd(day,datediff(day,begin_datetime,@now) - @day + begin_day,begin_datetime) 
	and @now < dateadd(second,delta_seconds,dateadd(day,datediff(day,begin_datetime,@now) - @day + begin_day,begin_datetime))
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and datediff(day,begin_time,@now) < dbo.f_days_of_month(dateadd(day,-(day(@now)),@now)))
GO
