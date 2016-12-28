if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dispatch_transmit_for_user]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dispatch_transmit_for_user]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

-----------------------------------------------------------------------------------------------------------
-- ����: sp_dispatch_service_for_user
-- ����: zhangtao, 200703
-- ����: 
--   Ϊ�û��ַ���ת������
--   ��Ҫ���ǵ��������ΰ���:
--    1 �û���ISP������ISP��Ӧ
--    2 ���û�δָ��ISP������£�����ʹ���豸��ISPѰ��ת��
--    3 �����״̬, �Ƿ��ڻ״̬
--    4 ����ĸ�����, ѡ��δ���صķ���  
-- ������
--    20080228 ������ispΪ''ʱ�������Ҳ������������
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.sp_dispatch_transmit_for_user
	/** �û��ʺ� */
	@user_account user_account,
	/** �豸���к� */
	@device_sn video_server_sn,
	/** �����GUID */
	@guid nvarchar(36) output,
	/** �����IP��ַ */
	@ip ip output,
	/** ת�������services,���д�����Ƶ����Ƶ�Ķ˿ں� */
	@services nvarchar(100) output
AS
  SET NOCOUNT ON
  
	declare @isp varchar(20)
	
	select @isp = isp from t_org_user where useraccount = @user_account
	
	/** modified by zhangtao 20071024
	 *  ���˵���ϵ���ڵ�������ߵ����
	 */
	select @guid = sd.service_guid from am_services_device sd join t_services sv on sd.service_guid = sv.guid where sd.device_sn = @device_sn and sd.service_type = 3 and sv.is_live = 1
	
	/** �豸��δ���κη������ */
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
	
	/** �豸�Ѿ��ͷ������ */
	if(@isp is null or @isp = '')
		select @ip = outip,@services = services from t_services where guid = @guid			
	else
		select @ip = ip,@services = services from v_services_isp_live where guid = @guid and isp = @isp
	
	return
GO
