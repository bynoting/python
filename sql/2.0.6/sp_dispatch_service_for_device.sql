if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dispatch_service_for_device]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
begin
    drop procedure [dbo].[sp_dispatch_service_for_device]
end
GO

------------------------------------------------------------------------------------------------------------
-- 名称: sp_dispatch_service_for_device
-- 作者: zhangtao, 200711
-- 备注：目前只用在升级设备驱动时找FTP的地址
------------------------------------------------------------------------------------------------------------
create PROCEDURE dbo.sp_dispatch_service_for_device
@device_sn video_server_sn,
/* 服务类型,参见BizDefinition.BackEndServiceType */
@service_type nvarchar(10),
/* 服务的GUID */
@service_guid guid output,
/* 服务的对内服务的IP地址 */
@ip ip output,
/* 服务的对外服务的IP地址(如果配置了ISP,则是对应用户ISP地址) */
@out_ip ip output,
/* 服务的端口 */
@port nvarchar(4) output,
/* 服务的services */
@services nvarchar(100) output
AS
  SET NOCOUNT ON
	declare @isp varchar(20)	
	select @isp = isp from t_video_server where VideoServGuid = @device_sn
	/* 用户还未和服务关联 */
	if(@isp is null or @isp = '')
	begin
	    select top 1 @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where type=@service_type and is_live = 1 and live_clients < max_clients order by newid()
	end
	else
	begin
	    select top 1 @service_guid = guid,@out_ip = ip,@ip=null,@port=port,@services = services from v_services_isp_live where isp = @isp and type=@service_type and live_clients < max_clients order by newid()
	end

	/* 通过ISP查不到时,还得查普通的 */
	if (@service_guid is null)
		select top 1 @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where type=@service_type and is_live = 1 and live_clients < max_clients order by newid()
	RETURN
