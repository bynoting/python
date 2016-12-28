/* 删除表am_user_services_device*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_user_services_device]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[am_user_services_device]
GO

/*==============================================================*/
/* Table: am_services_device                                    */
/*==============================================================*/
if not exists (select 1 from  sysobjects where  id = object_id('dbo.am_services_device') and   type = 'U')
begin
	create table dbo.am_services_device (
	   guid                 guid                 not null,
	   device_guid          guid                 not null,
	   device_sn		video_server_sn      not null,
	   device_type          device_type_code     not null,
	   service_guid         guid                 not null,
	   service_type         gt_service_type      not null,
	   data_create_user     user_account         null,
	   data_create_time     data_create_time     null,
	   constraint PK_AM_SERVICES_DEVICE primary key  (guid)
	)

	ALTER TABLE [dbo].[am_services_device] ADD 
		CONSTRAINT [DF_am_services_device_data_create_user] DEFAULT (N'_sys_') FOR [data_create_user]

	execute sp_addextendedproperty 'MS_Description', 
	   '反映后台服务和视频服务器的实时对应关系。服务关系一旦拆除，需要从该表中删除对应数据',
	   'user', 'dbo', 'table', 'am_services_device'

	execute sp_addextendedproperty 'MS_Description', 
	   '设备（视频服务器，报警机，接警机）GUID',
	   'user', 'dbo', 'table', 'am_services_device', 'column', 'device_guid'

	create   index idx_am_services_device_device_sn on dbo.am_services_device (
	device_sn ASC
	)

	execute sp_bindefault N'[dbo].[now]', "am_services_device.data_create_time"   
end   


