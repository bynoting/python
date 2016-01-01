--------------------------------------------------------------------------
-- 清除一些不用的临时表
--------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id('tmp_audio_decoder') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table tmp_audio_decoder
GO

if exists (select * from dbo.sysobjects where id = object_id('tmp_audio_encoder') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table tmp_audio_encoder
GO

if exists (select * from dbo.sysobjects where id = object_id('tmp_input_port') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table tmp_input_port
GO

if exists (select * from dbo.sysobjects where id = object_id('tmp_output_port') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table tmp_output_port
GO

if exists (select * from dbo.sysobjects where id = object_id('tmp_serial_port') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table tmp_serial_port
GO

if exists (select * from dbo.sysobjects where id = object_id('tmp_video_encoder') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table tmp_video_encoder
GO


------------------------------------------------------
-- 删除一些没用的表 20080226
-----------------------------------------------------
-- 端子动作 --
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_input_port_action]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_input_port_action

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_inputport_event]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_inputport_event

-- 维修单相关表 --
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_maintain_detail_bill]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_maintain_detail_bill

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_maintain_bill]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_maintain_bill

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_maintance_group_member]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_maintance_group_member

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_maintance_group]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_maintance_group


-- 整改计划相关表 --
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[T_AlterDetailInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table T_AlterDetailInfo

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[T_AlterPlanChangeInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table T_AlterPlanChangeInfo

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[T_AlterPlanSub]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table T_AlterPlanSub

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[T_AlterPlanMain]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table T_AlterPlanMain

-- 移动侦测 --
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_move_measure]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_move_measure


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[T_SHOW_MODE_DEFAULT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table T_SHOW_MODE_DEFAULT

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_web_station]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_web_station


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_device_status]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_device_status


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_group_member]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t_group_member






