-----------------------------------------------------
-- 1 修改故障表（加入fault_time字段)
-----------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='fault_time' and id = object_id(N'am_device_fault'))
begin
    alter table am_device_fault add fault_time as data_create_time
end
go

-----------------------------------------------------
-- 2 修改历史表（加入fault_time字段)
-----------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='fault_time' and id = object_id(N'am_device_fault_his'))
begin
    alter table am_device_fault_his add fault_time datetime
end
go

update am_device_fault_his set fault_time = last_report_time where fault_time is null
go

-----------------------------------------------------
-- 3 修改视图
-----------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_device_fault_all]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_device_fault_all]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

---------------------------------------------------------------------------------------------------------------
-- 描述: 设备的所有故障记录的详细信息(包括当前故障和已经解决的故障)
-- 作者: Zhangtao,200704
---------------------------------------------------------------------------------------------------------------
CREATE VIEW dbo.v_device_fault_all
AS
select 	
  vpd.video_server_name,vpd.point_id,vpd.point_name,vpd.point_addr,vpd.group_code,

	df.video_server_sn,df.fault_time,df.last_report_time,df.fault_type,is_fixed=0,
	is_process,process_user,
	df.guid, 
	
	vpd.group_name,vpd.principal, vpd.teleph, vpd.principal1, vpd.teleph1, vpd.principal2, vpd.teleph2,
  vpd.department_name, vpd.protected_dept_name, vpd.protect_dept_name,
  
	cd.codename as fault_name,
	
	year(df.data_create_time) as year,month(df.data_create_time) as month,day(df.data_create_time) as day
	
from am_device_fault df 
join v_watch_point_device vpd on  df.video_server_sn = vpd.video_server_sn
join t_codediction cd on cd.codetype = 'checktype' and cd.codevalue = df.fault_type 

union all

select 	
  vpd.video_server_name,vpd.point_id,vpd.point_name,vpd.point_addr,vpd.group_code,
  
	df.video_server_sn,df.fault_time,df.last_report_time,df.fault_type,is_fixed=1,
	is_process,process_user,
	df.guid, 
	
	vpd.group_name,vpd.principal, vpd.teleph, vpd.principal1, vpd.teleph1, vpd.principal2, vpd.teleph2,
  vpd.department_name, vpd.protected_dept_name, vpd.protect_dept_name,
  
	cd.codename as fault_name,
	
	year(df.data_create_time) as year,month(df.data_create_time) as month,day(df.data_create_time) as day
from am_device_fault_his df 
join v_watch_point_device vpd on  df.video_server_sn = vpd.video_server_sn
join t_codediction cd on cd.codetype = 'checktype' and cd.codevalue = df.fault_type 
