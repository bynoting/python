if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_plan_valid]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[sp_query_plan_valid]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
--------------------------------------------------------------------------------------------------------------      
--Name  :  	sp_query_plan_valid                                         
--Function  :  ��ѯ��ǰ��ִ�еļƻ�                                            
--Author:  	zhangtao 
--Date  :  	2008-02-20                    
--Note : 	��Ҫ���˵������� 
-- 		1 ���ݲ�ͬ�ƻ����ͺ͵�ǰʱ����˵õ����ڿ�ִ�еļƻ�        
--		2 ���˵�ǰ�Ѿ�ִ�еļƻ�
--------------------------------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_query_plan_valid (@plan_type int)
AS

declare @now datetime
declare @time varchar(8)
declare @weekday int
declare @day int

SET DATEFIRST 1 /*����һΪһ�ܿ�ʼ*/

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
-- �ѿ�ʼ�ͽ���ʱ�任�㵽������жԱ�
select guid  from am_plan where is_valid = 1 and task_type = 1 and plan_type = @plan_type
	and @now > dbo.f_replace_time(@now,begin_time) -- �滻��ʼʱ���deate����
	and @now < dateadd(second,delta_seconds,dbo.f_replace_time(@now,begin_time)) 
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and convert(varchar,begin_time,2) = convert(varchar,@now,2))
union all
-- weekly 
-- �ѿ�ʼ�ͽ���ʱ�任�㵽���ܵĶ�Ӧʱ����жԱ�
select guid from am_plan where is_valid = 1 and task_type = 2 and plan_type = @plan_type
	and @now > dateadd(day,datediff(day,begin_datetime,@now) - @weekday + begin_weekday,begin_datetime) 
	and @now < dateadd(second,delta_seconds,dateadd(day,datediff(day,begin_datetime,@now) - @weekday + begin_weekday,begin_datetime))
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and datediff(day,begin_time,@now) < 7 ) 
union all 
-- monthly
-- �ѿ�ʼ�ͽ���ʱ�任�㵽���µĶ�Ӧʱ����жԱ�
select guid  from am_plan where is_valid = 1 and task_type = 3 and plan_type = @plan_type
	and @now > dateadd(day,datediff(day,begin_datetime,@now) - @day + begin_day,begin_datetime) 
	and @now < dateadd(second,delta_seconds,dateadd(day,datediff(day,begin_datetime,@now) - @day + begin_day,begin_datetime))
	and not exists(select guid from am_plan_log where plan_guid = am_plan.guid
		and datediff(day,begin_time,@now) < dbo.f_days_of_month(dateadd(day,-(day(@now)),@now)))
GO
