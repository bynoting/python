if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_online_user_update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_online_user_update]
GO
-------------------------------------------------------------------------------------------------------------------------
-- ����: sp_online_user
-- ����: zhangtao, 20070325
-- ����: �����û���������,�漰��Ϣ��������ת�����������ַ������������û��������ߵ��¼�
-------------------------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[sp_online_user_update] 
	/**������(��Ϣ��������ת��������)GUID*/
    @invoker_guid char(36),
    /**����������(3: ת��; 5: ��Ϣ),�μ�APP��BizDefinition.BackEndServiceType*/
    @invoker_type int,  
    /**�û��ʺ�*/   
    @user_account user_account,
    /**�û�IP��ַ, ��Ϊ���ַ���*/
    @user_ip      ip,      
    /**0: ����; 1:����*/
    @is_live      bool    
as

/** ���·������Ļ�û��� */
declare @delta int
if (@is_live = 1)
    set @delta = 1
else
    set @delta = -1

update t_services set live_clients = live_clients + @delta where guid = @invoker_guid

/** ��Ϣ����������(��ӻ�ɾ�����߼�¼) */
if (@invoker_type = 5) 
begin
	if(@is_live = 1)
	begin
		/** todo: ������ӵ�¼��¼�Ƿ��Ҫ */
		/** ��ӵ�¼��¼ */
		declare @login_id int
		insert into t_login_log (user_name,login_ip,login_state) values (@user_account,@user_ip,3) select @login_id = @@IDENTITY;

		/** �������û����в������� */
		delete t_online_user where user_account = @user_account
		insert into t_online_user (user_account,ip,messeger_guid,login_id) values (@user_account,@user_ip,@invoker_guid,@login_id)
		return
	end
	else
	begin
      update t_login_log set exit_time = getdate() where log_id = (select login_id from t_online_user where user_account = @user_account)
	    delete t_online_user where user_account = @user_account
      return
  end
end

/** ת������������(�����û���Ӧ��ת��������) */
if(@invoker_type = 3)
    begin
	if (@is_live = 0)
	    set @invoker_guid = null
	update t_online_user set transmit_guid = @invoker_guid where user_account = @user_account
    end
GO
