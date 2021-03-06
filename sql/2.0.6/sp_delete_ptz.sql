if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_delete_ptz]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_delete_ptz]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :删除云台
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2008-02-29
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_delete_ptz
(
	@guid          		char(36),
	@tree_id                   	int
)
AS
	declare @ptz_id int
	declare @lens_id int

	-- 获取云台相关信息
	SELECT @ptz_id = ptz_id,  @lens_id = lens_id FROM t_ptz  WHERE guid = @guid
	if @ptz_id is null   return 

	begin tran 

	-- '删除云台预置位t_advance_position'
	DELETE t_advance_position WHERE ptz_id = @ptz_id
	if @@ERROR <> 0 rollback tran

	-- '删除云台辅助位t_assistant_device'
	DELETE t_assistant_device WHERE ptz_id = @ptz_id
	if @@ERROR <> 0 rollback tran

	-- '删除云台t_tree'
	DELETE t_tree WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	-- '删除云台t_device_role_device'
	DELETE t_device_role_device WHERE tree_id = @tree_id
	if @@ERROR <> 0 rollback tran

	-- '删除云台t_ptz'
	DELETE t_ptz WHERE guid = @guid
	if @@ERROR <> 0 rollback tran

	-- '更新云台对应的摄像头状态t_lens'
	UPDATE t_lens SET is_use = 0 where lens_id = @lens_id
	if @@ERROR <> 0 rollback tran

	commit tran
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

