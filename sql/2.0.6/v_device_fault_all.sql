if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_device_fault_all]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_device_fault_all]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

---------------------------------------------------------------------------------------------------------------
-- ����: �豸�����й��ϼ�¼����ϸ��Ϣ(������ǰ���Ϻ��Ѿ�����Ĺ���)
-- ����: Zhangtao,200704
---------------------------------------------------------------------------------------------------------------
CREATE VIEW dbo.v_device_fault_all
AS
select 	
  vpd.video_server_name,vpd.point_id,vpd.point_name,vpd.point_addr,vpd.group_code,

	df.video_server_sn,df.data_create_time as fault_time,df.last_report_time,df.fault_type,is_fixed=0,
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
  
	df.video_server_sn,df.data_create_time as fault_time,df.last_report_time,df.fault_type,is_fixed=1,
	is_process,process_user,
	df.guid, 
	
	vpd.group_name,vpd.principal, vpd.teleph, vpd.principal1, vpd.teleph1, vpd.principal2, vpd.teleph2,
  vpd.department_name, vpd.protected_dept_name, vpd.protect_dept_name,
  
	cd.codename as fault_name,
	
	year(df.data_create_time) as year,month(df.data_create_time) as month,day(df.data_create_time) as day
from am_device_fault_his df 
join v_watch_point_device vpd on  df.video_server_sn = vpd.video_server_sn
join t_codediction cd on cd.codetype = 'checktype' and cd.codevalue = df.fault_type 
