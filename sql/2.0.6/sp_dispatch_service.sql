if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dispatch_service]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dispatch_service]
GO

------------------------------------------------------------------------------------------------------------
-- 名称: sp_dispatch_service
-- 作者: zhangtao, 200703
-- 描述: 
--   分发服务,包括消息/网关/录像/FTP/WEB等等
--   需要考虑的因素依次包括:
--   1 用户的ISP与服务的ISP对应
--   2 服务的状态, 是否处于活动状态
--   3 服务的负载量, 选择未过载的服务
--   4 消息服务器和用户的关系必须是一对一，因此需要检查用户和服务是否已经关联(2007-05)
------------------------------------------------------------------------------------------------------------
create PROCEDURE dbo.sp_dispatch_service
	/** 用户帐号 */
	@user_account user_account,
	/** 服务类型,参见BizDefinition.BackEndServiceType*/
	@service_type nvarchar(10),
	/** 服务的GUID */
	@service_guid guid output,
	/** 服务的对内服务的IP地址 */
	@ip ip output,
	/** 服务的对外服务的IP地址(如果配置了ISP,则是对应用户ISP地址) */
	@out_ip ip output,
	/** 服务的端口*/
	@port nvarchar(4) output,
	/** 服务的services*/
	@services nvarchar(100) output
AS
  SET NOCOUNT ON
  
	declare @isp varchar(20)	
	select @isp = isp from t_org_user where useraccount = @user_account
	
	if (@service_type = 'messeger')
      select @service_guid = messeger_guid  from t_online_user where user_account = @user_account
      
	/** 用户已经和服务关联 */
	if (@service_guid is not null)
	begin
			select @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where guid = @service_guid
			return
	end
	
	/** 用户还未和服务关联 */
	if(@isp = '' or @isp is null)
		select top 1 @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where type=@service_type and is_live = 1 and live_clients < max_clients order by newid()
	else
		select top 1 @service_guid = guid,@out_ip = ip,@ip=null,@port=port,@services = services from v_services_isp_live where isp = @isp and type=@service_type and live_clients < max_clients order by newid()

	/** 通过ISP查不到时,还得查普通的 */
	if (@service_guid is null)
		select top 1 @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where type=@service_type and is_live = 1 and live_clients < max_clients order by newid()
	RETURN
