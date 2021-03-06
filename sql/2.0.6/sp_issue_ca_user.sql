if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_issue_ca_user]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_issue_ca_user]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO



CREATE PROCEDURE dbo.sp_issue_ca_user 
	@user_account  	nvarchar(36),                 --用户帐号
	@card_sn           	nvarchar(64),                 --USB卡的序列号
	@pki_cert          	 	nvarchar(2048),             --证书
	@cert_sn            	char(32),                        --证书序列号
	@valid_begin    	 	datetime,                       --有效期起始时间
	@valid_days       	int,                                 --有效期(天)
	@data_create_user 	nvarchar(36),                 --数据创建者
	@error_msg                     varchar(255) output
AS
	declare @event_id varchar(50)
	declare @is_exists int

	--判断用户是否存在
	if not exists(select useraccount from t_org_user where useraccount = @user_account and userstate = '01')
	begin
		set @error_msg = '用户不存在:  ' + @user_account 
		return 
	end

	--判断用户是否存在有效证书
	if exists(select state from t_ca_user where user_account = @user_account and state = 0)
	begin
		set @error_msg = '用户有效证书已存在:  ' + @user_account 
		return 
	end
	
	begin tran
	--新颁发证书
	insert into t_ca_user(
		user_account,
		card_sn,
		pki_cert,
		cert_sn,
		valid_begin,
		valid_days,
		valid_end,
		state,
		data_create_user)
	values(
		@user_account,
		@card_sn,
		@pki_cert,
		@cert_sn,
		@valid_begin,
		@valid_days,
		dateadd(day,@valid_days,@valid_begin),
		0,
		@data_create_user)
	
	if @@error <> 0
	begin
		rollback tran
		goto exception_process
	end

	--修改用户表t_org_user是否发卡状态
	update t_org_user set orkey='01' where useraccount = @user_account
	if @@error <> 0
	begin
		rollback tran
		goto exception_process
	end

	--写入操作日志
	set @event_id='0011-0001-0001' 
	exec sp_add_handle_log @event_id, @data_create_user,  @user_account, 0, ''
	commit tran

	--根据错误号查询出错误信息
	exception_process:
	select @error_msg = description from master..sysmessages where error = @@error
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

