if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_manage_gateway]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_manage_gateway]
GO

----------------------------------------------------------------------------------------------------------
--�洢����: sp_manage_gateway
--����:    zhangtao,200704
--˵��:   ��APP����Ҫ��������, ��ȡ���غ��豸��Ϣ�Ķ�����ݿ��ѯ�Ͳ���������һ��
----------------------------------------------------------------------------------------------------------
create PROCEDURE dbo.sp_manage_gateway (
	/** �豸���к� */
	@a_device_guid varchar(16),
	/** ���صĴ�����Ϣ,���Ϊ�ձ�ʾ�ɹ� */
	@a_error varchar(40) output
)
AS
declare @device_cmd_port varchar(10)
declare @device_protocal_version varchar(20)
declare @device_ip varchar(20)
declare @device_state int
declare @video_decoder_type varchar(4)
declare @gateway_ip varchar(20)
declare @gateway_port varchar(4)

select @device_cmd_port = cmd_port, @device_protocal_version = ProtocolVersion,@device_state = state,@device_ip=ip_address,@video_decoder_type = video_decoder_type
  from t_video_server where VideoServGuid = @a_device_guid

if @device_state is null 
begin
	set @a_error = '�豸������'
	return
end

if @device_state <> 6
begin
  set @a_error = '�豸������'
  return 
end

/** ��ѯ���豸���������ص�ַ��IP(�μ�BizDefinition.BackEndServiceType,���ط�������ֵΪ 2 */
select @gateway_ip = b.ip, @gateway_port = b.port from t_services b join am_services_device a on a.service_guid = b.guid
	 where a.device_sn = @a_device_guid and a.service_type = 2 and b.is_live = 1

if @gateway_ip is null  or @gateway_ip = ''
begin
  set @a_error = '�Ҳ�������'
  
  /** �޸��豸��״̬Ϊ������ */
  update t_video_server set state = 8 where VideoServGuid = @a_device_guid
  return 
end

 select @device_cmd_port as device_cmd_port, @device_protocal_version as device_protocal_version,@device_ip as device_ip,@device_state as device_state, @gateway_ip as gateway_ip,@gateway_port as gateway_port,@video_decoder_type as video_decoder_type
GO
