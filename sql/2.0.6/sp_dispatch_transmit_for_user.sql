if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dispatch_transmit_for_user]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dispatch_transmit_for_user]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

-----------------------------------------------------------------------------------------------------------
-- 名称: sp_dispatch_service_for_user
-- 作者: zhangtao, 200703
-- 描述: 
--   为用户分发流转发服务
--   需要考虑的因素依次包括:
--    1 用户的ISP与服务的ISP对应
--    2 在用户未指定ISP的情况下，考虑使用设备的ISP寻找转发
--    3 服务的状态, 是否处于活动状态
--    4 服务的负载量, 选择未过载的服务  
-- 修正：
--    20080228 修正由isp为''时带来的找不到服务的问题
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.sp_dispatch_transmit_for_user
	/** 用户帐号 */
	@user_account user_account,
	/** 设备序列号 */
	@device_sn video_server_sn,
	/** 服务的GUID */
	@guid nvarchar(36) output,
	/** 服务的IP地址 */
	@ip ip output,
	/** 转发服务的services,其中带有视频和音频的端口号 */
	@services nvarchar(100) output
AS
  SET NOCOUNT ON
  
	declare @isp varchar(20)
	
	select @isp = isp from t_org_user where useraccount = @user_account
	
	/** modified by zhangtao 20071024
	 *  过滤掉关系存在但服务掉线的情况
	 */
	select @guid = sd.service_guid from am_services_device sd join t_services sv on sd.service_guid = sv.guid where sd.device_sn = @device_sn and sd.service_type = 3 and sv.is_live = 1
	
	/** 设备还未和任何服务关联 */
	if( @guid is null)
	begin
		if(@isp is null or @isp = '')
			select @isp = isp from t_video_server where VideoServGuid = @device_sn

		if(@isp is null or @isp = '')
			select top 1 @guid = guid,@ip = outip,@services = services from t_services where type='transmit' and is_live = 1 and live_clients < max_clients order by newid()
		else
			select top 1 @guid = guid,@ip = ip,@services = services from v_services_isp_live where isp = @isp and type='transmit' and live_clients < max_clients order by newid()		
		return
	end
	
	/** 设备已经和服务关联 */
	if(@isp is null or @isp = '')
		select @ip = outip,@services = services from t_services where guid = @guid			
	else
		select @ip = ip,@services = services from v_services_isp_live where guid = @guid and isp = @isp
	
	return
GO
