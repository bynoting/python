if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dispatch_service]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dispatch_service]
GO

------------------------------------------------------------------------------------------------------------
-- ����: sp_dispatch_service
-- ����: zhangtao, 200703
-- ����: 
--   �ַ�����,������Ϣ/����/¼��/FTP/WEB�ȵ�
--   ��Ҫ���ǵ��������ΰ���:
--   1 �û���ISP������ISP��Ӧ
--   2 �����״̬, �Ƿ��ڻ״̬
--   3 ����ĸ�����, ѡ��δ���صķ���
--   4 ��Ϣ���������û��Ĺ�ϵ������һ��һ�������Ҫ����û��ͷ����Ƿ��Ѿ�����(2007-05)
------------------------------------------------------------------------------------------------------------
create PROCEDURE dbo.sp_dispatch_service
	/** �û��ʺ� */
	@user_account user_account,
	/** ��������,�μ�BizDefinition.BackEndServiceType*/
	@service_type nvarchar(10),
	/** �����GUID */
	@service_guid guid output,
	/** ����Ķ��ڷ����IP��ַ */
	@ip ip output,
	/** ����Ķ�������IP��ַ(���������ISP,���Ƕ�Ӧ�û�ISP��ַ) */
	@out_ip ip output,
	/** ����Ķ˿�*/
	@port nvarchar(4) output,
	/** �����services*/
	@services nvarchar(100) output
AS
  SET NOCOUNT ON
  
	declare @isp varchar(20)	
	select @isp = isp from t_org_user where useraccount = @user_account
	
	if (@service_type = 'messeger')
      select @service_guid = messeger_guid  from t_online_user where user_account = @user_account
      
	/** �û��Ѿ��ͷ������ */
	if (@service_guid is not null)
	begin
			select @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where guid = @service_guid
			return
	end
	
	/** �û���δ�ͷ������ */
	if(@isp = '' or @isp is null)
		select top 1 @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where type=@service_type and is_live = 1 and live_clients < max_clients order by newid()
	else
		select top 1 @service_guid = guid,@out_ip = ip,@ip=null,@port=port,@services = services from v_services_isp_live where isp = @isp and type=@service_type and live_clients < max_clients order by newid()

	/** ͨ��ISP�鲻��ʱ,���ò���ͨ�� */
	if (@service_guid is null)
		select top 1 @service_guid = guid,@out_ip = outip,@ip=ip,@port=port,@services = services from t_services where type=@service_type and is_live = 1 and live_clients < max_clients order by newid()
	RETURN
