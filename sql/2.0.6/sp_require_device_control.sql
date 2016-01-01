if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_require_device_control]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_require_device_control]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/******************************************************************************
 * ��洢����: sp_require_device_control 
 * ����:  �����豸����Ȩ
 * 		  �����������û�Ϊ����Ա�������û�������Ȩ�޿����豸	
 *        �������̣�����豸�Ƿ����������˿��ƣ��������Ƚ������û���Ȩ�ޣ���
 *					���û������û�Ȩ�޸ߵ�����£�������Ȩת�������û�
 * ����:   Zhangtao, 200704
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

--�ж��û��Ƿ�����
if  EXISTS(select user_account from t_online_user where user_account = @user)
	set @IsNoLine  = 1 --����
else 
begin
	set @Result =0     --������, �˳�
	return 
end

--�ж��û����ͣ��Ƿ���Ϊ����Ա
select @USERTYPE = USERTYPE from T_ORG_USER where USERACCOUNT = @user

if @USERTYPE= '01' or @USERTYPE = '02'
	set @IsAdmin = 1

--�ж��û��Ƿ���豸���
if  EXISTS(select ur.USERACCOUNT 
    from t_device_role_device dr,t_user_device_role ur where dr.device_guid = @device
    and ur.USERACCOUNT = @user and  dr.device_role_id = ur.device_role_id and dr.device_type_id = 3)
	set @IsRelationShipDev = 1

if @IsAdmin = 0 and @IsRelationShipDev=0
begin
	set @Result =1     --�û��͸��豸�����, ���߲��ǹ���Ա�����ܿ����豸
	return
end

select @OldUser =user_account from t_online_user where  device_guid=@device
if @OldUser= @user
begin
	set @OldUser = '' --added by zhangtao 20061226
	set @Result =3  --�û�ʱ������룬ֱ�ӷ��سɹ�����ɹ�
end
else
begin
	select @ControlLevelO =CONTROL_LEVEL from T_ORG_USER where USERACCOUNT = @OldUser
	select @ControlLevels =CONTROL_LEVEL from T_ORG_USER where USERACCOUNT = @user
	if @ControlLevelO >= @ControlLevels
	begin
		set @Result =2    --����Ȩ�޵��û����ڿ��Ƹ��豸
	end 
	else
	begin
		Begin TranSaction  trans
			update t_online_user set device_guid = 'null' where user_account=@OldUser  --ȡ�����û��Ŀ���Ȩ
			update t_online_user set device_guid = @device where user_account=@user --���û���ÿ���Ȩ
			set @Result =3  --����ɹ�
		Commit tran trans
	end
end
GO

