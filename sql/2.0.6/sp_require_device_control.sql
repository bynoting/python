if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_require_device_control]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_require_device_control]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/******************************************************************************
 * 类存储过程: sp_require_device_control 
 * 描述:  申请设备控制权
 * 		  申请条件：用户为管理员，或者用户被赋予权限控制设备	
 *        申请流程：检查设备是否正被其他人控制，如果有则比较两个用户的权限，在
 *					新用户比老用户权限高的情况下，将控制权转交给新用户
 * 作者:   Zhangtao, 200704
 ******************************************************************************/
CREATE   PROCEDURE dbo.sp_require_device_control(
	@user varchar(32),
	@device video_server_sn, 
	@OldUser Varchar(32) OutPut,
	@Result int output)
AS

DECLARE @USERTYPE varchar(6),@IsNoLine bit,@IsAdmin bit,@IsRelationShipDev bit,
	@ControlLevelO int,@ControlLevels int

set @IsNoLine =0
set @IsAdmin = 0
set @IsRelationShipDev = 0

--判断用户是否在线
if  EXISTS(select user_account from t_online_user where user_account = @user)
	set @IsNoLine  = 1 --在线
else 
begin
	set @Result =0     --不在线, 退出
	return 
end

--判断用户类型，是否能为管理员
select @USERTYPE = USERTYPE from T_ORG_USER where USERACCOUNT = @user

if @USERTYPE= '01' or @USERTYPE = '02'
	set @IsAdmin = 1

--判断用户是否和设备相关
if  EXISTS(select ur.USERACCOUNT 
    from t_device_role_device dr,t_user_device_role ur where dr.device_guid = @device
    and ur.USERACCOUNT = @user and  dr.device_role_id = ur.device_role_id and dr.device_type_id = 3)
	set @IsRelationShipDev = 1

if @IsAdmin = 0 and @IsRelationShipDev=0
begin
	set @Result =1     --用户和该设备不相关, 或者不是管理员，不能控制设备
	return
end

select @OldUser =user_account from t_online_user where  device_guid=@device
if @OldUser= @user
begin
	set @OldUser = '' --added by zhangtao 20061226
	set @Result =3  --用户时多次申请，直接返回成功申请成功
end
else
begin
	select @ControlLevelO =CONTROL_LEVEL from T_ORG_USER where USERACCOUNT = @OldUser
	select @ControlLevels =CONTROL_LEVEL from T_ORG_USER where USERACCOUNT = @user
	if @ControlLevelO >= @ControlLevels
	begin
		set @Result =2    --更高权限的用户正在控制该设备
	end 
	else
	begin
		Begin TranSaction  trans
			update t_online_user set device_guid = 'null' where user_account=@OldUser  --取消老用户的控制权
			update t_online_user set device_guid = @device where user_account=@user --新用户获得控制权
			set @Result =3  --申请成功
		Commit tran trans
	end
end
GO

