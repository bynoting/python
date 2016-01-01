if exists (select 1 from  sysobjects where  id = object_id('dbo.t_kinescope_plan') and   type = 'U')
begin  
	drop table dbo.t_kinescope_plan
end
go

if exists (select 1 from  sysobjects where  id = object_id('dbo.t_kinescope_plan_device') and   type = 'U')
begin  
	drop table dbo.t_kinescope_plan_device
end
go


if exists (select 1 from  sysobjects where  id = object_id('dbo.am_record_plan') and   type = 'U')
begin  
	drop table dbo.am_record_plan
end
go



if exists (select 1 from  sysobjects where  id = object_id('dbo.am_record_plan_detail') and   type = 'U')
begin  
	drop table dbo.am_record_plan_detail
end
go


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_plan_record_file]') and OBJECTPROPERTY(id, N'IsView') = 1)
  drop view [dbo].[v_plan_record_file]
GO



