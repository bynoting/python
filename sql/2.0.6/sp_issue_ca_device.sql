if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_issue_ca_device]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_issue_ca_device]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE dbo.sp_issue_ca_device
	@video_server_sn   char(16),                    --视频服务器序列号
	@pki_cert          varchar(2048),               -- 设备证书(PEM格式)
	@zip_cert_key      varbinary(4096),             --将密钥和证书通过Zip压缩后的数据
	@cert_sn           char(32),                    --证书序列号
	@valid_begin       datetime,                    --有效期起始时间
	@valid_days        int,                         --有效期(天)
	@data_create_user  nvarchar(36),                --数据创建者
	@error_msg         varchar(255) output
AS
	declare @event_id varchar(50)
	declare @valid_end datetime
	
	set @valid_end = dateadd(day,@valid_days,@valid_begin)

	--判断设备是否存在
	if not exists(select state from t_video_server where videoservguid = @video_server_sn and video_server_id >= 1)
	begin
		set @error_msg = '设备不存在: ' + @video_server_sn
		return 
	end

	--判断设备是否存在有效证书
	if exists(select guid from t_ca_device where video_server_sn = @video_server_sn and state = 0)
	begin
		set @error_msg = '设备有效证书已经存在: ' + @video_server_sn
		return 
	end
	
	--新颁发证书
	insert into t_ca_device(
		video_server_sn,
		pki_cert,
		zip_cert_key,
		cert_sn,
		valid_begin,
		valid_days,
		valid_end,
		state,
		data_create_user)
	values(
		@video_server_sn,
		@pki_cert,
		@zip_cert_key,
		@cert_sn,
		@valid_begin,
		@valid_days,
		@valid_end,
		0,
		@data_create_user)

	--写入操作日志
	set @event_id='0011-0001-0001' 
	exec sp_add_handle_log @event_id, @data_create_user,  @video_server_sn, 0, ''
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

