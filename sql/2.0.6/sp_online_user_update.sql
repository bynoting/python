if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_online_user_update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_online_user_update]
GO
-------------------------------------------------------------------------------------------------------------------------
-- 名称: sp_online_user
-- 作者: zhangtao, 20070325
-- 描述: 处理用户上线下线,涉及消息服务器和转发服务器两种服务器触发了用户上线下线的事件
-------------------------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[sp_online_user_update] 
	/**调用者(消息服务器或转发服务器)GUID*/
    @invoker_guid char(36),
    /**调用者类型(3: 转发; 5: 消息),参见APP的BizDefinition.BackEndServiceType*/
    @invoker_type int,  
    /**用户帐号*/   
    @user_account user_account,
    /**用户IP地址, 可为空字符串*/
    @user_ip      ip,      
    /**0: 掉线; 1:上线*/
    @is_live      bool    
as

/** 更新服务器的活动用户数 */
declare @delta int
if (@is_live = 1)
    set @delta = 1
else
    set @delta = -1

update t_services set live_clients = live_clients + @delta where guid = @invoker_guid

/** 消息服务器触发(添加或删除在线记录) */
if (@invoker_type = 5) 
begin
	if(@is_live = 1)
	begin
		/** todo: 考虑添加登录记录是否必要 */
		/** 添加登录记录 */
		declare @login_id int
		insert into t_login_log (user_name,login_ip,login_state) values (@user_account,@user_ip,3) select @login_id = @@IDENTITY;

		/** 向在线用户表中插入新行 */
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

/** 转发服务器触发(更新用户对应的转发服务器) */
if(@invoker_type = 3)
    begin
	if (@is_live = 0)
	    set @invoker_guid = null
	update t_online_user set transmit_guid = @invoker_guid where user_account = @user_account
    end
GO
