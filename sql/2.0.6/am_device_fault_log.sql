/** drop sp_analyse_am_device_fault_log */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_analyse_am_device_fault_log]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_analyse_am_device_fault_log]
GO

/** drop  am_device_fault_log */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_device_fault_log]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_device_fault_log]
GO
