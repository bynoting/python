------------------------------------------------------------------------------------------------------
-- ɾ��һЩû�õ��ֶ�
------------------------------------------------------------------------------------------------------
if exists( select 1 from dbo.syscolumns s where name ='video_compress_type'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column video_compress_type
end

if exists( select 1 from dbo.syscolumns s where name ='audio_compress_type'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column audio_compress_type
end


if exists( select 1 from dbo.syscolumns s where name ='gateway'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column gateway
end


if exists( select 1 from dbo.syscolumns s where name ='transmit'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column transmit
end

if exists( select 1 from dbo.syscolumns s where name ='transparent_ctrl_port485'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column transparent_ctrl_port485
end


if exists( select 1 from dbo.syscolumns s where name ='transparent_ctrl_port232'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column transparent_ctrl_port232
end


if exists( select 1 from dbo.syscolumns s where name ='partition_mode'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column partition_mode
end

if exists( select 1 from dbo.syscolumns s where name ='image1_channel'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column image1_channel
end

if exists( select 1 from dbo.syscolumns s where name ='image2_channel'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column image2_channel
end

if exists( select 1 from dbo.syscolumns s where name ='image3_channel'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column image3_channel
end

if exists( select 1 from dbo.syscolumns s where name ='image4_channel'
	and id = object_id(N't_video_server'))
begin
	alter table t_video_server drop column image4_channel
end
go

------------------------------------------------------------------------------------------------------
-- �����豸�Ƿ�Ϊ����״̬���ֶ�
------------------------------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='is_testing' and id = object_id(N't_video_server'))
begin
    alter table t_video_server add is_testing bool 
end
go

EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[t_video_server].[is_testing]'
GO

update t_video_server set is_testing = 0 where is_testing is null
go


------------------------------------------------------------------------------------------------------
-- �����豸��Ӧ�����������ֶΣ���������������ݣ�
------------------------------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='video_decoder_type' and id = object_id(N't_video_server'))
begin
	alter table t_video_server add video_decoder_type varchar(4) 
	ALTER TABLE [dbo].[t_video_server] ADD CONSTRAINT [DF_t_video_server_video_decoder_type] DEFAULT ('gt') FOR [video_decoder_type]
end
go

update t_video_server set video_decoder_type = 'gt' where video_decoder_type is null
go

------------------------------------------------------------------------------------------------------
-- �޸�photo_index_file��Ĭ��ֵ
------------------------------------------------------------------------------------------------------
execute sp_bindefault N'dbo.null_string', "t_video_server.photo_index_file"
go

update t_video_server set photo_index_file = '' where photo_index_file is null
go

------------------------------------------------------------------------------------------------------
-- �޸�dev_info�ĳ���
------------------------------------------------------------------------------------------------------
exec spt_modify_column_type 't_video_server','dev_info','nvarchar(80)'

------------------------------------------------------------------------------------------------------
-- ɾ��video_server_id�Ͻ���������
------------------------------------------------------------------------------------------------------
exec spt_drop_index 't_video_server','video_server_id'
go
------------------------------------------------------------------------------------------------------
-- �޸�video_server_id��ȱʡֵ 20071107
------------------------------------------------------------------------------------------------------
execute sp_bindefault N'[dbo].[zero_or_false]', "t_video_server.video_server_id"
go

update t_video_server set video_server_id = 0 where video_server_id is null
go

------------------------------------------------------------------------------------------------------
-- �޸�video_server_id��ȱʡֵ 20071107
------------------------------------------------------------------------------------------------------
execute sp_bindefault N'[dbo].[zero_or_false]', "t_video_server.point_id"
go

update t_video_server set point_id = 0 where point_id is null
go

------------------------------------------------------------------------------------------------------
-- �����޸�state_date�Ĵ�����
-- ���ӵ�ͼ�ã���ʾ״̬��Ϣ��
------------------------------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tg_t_video_server_state_date]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tg_t_video_server_state_date]
GO

CREATE TRIGGER [tg_t_video_server_state_date] ON [dbo].[t_video_server] 
FOR  UPDATE
AS

set nocount on

IF UPDATE (state)
begin
	update t_video_server set state_date = getdate() where VideoServGuid in ( select VideoServGuid from inserted )
end

set nocount off
go
---------------------------------------------------------------------------------
-- �������������ֶ� 200801
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='data_create_time' and id = object_id(N't_video_server'))
begin
	alter table t_video_server add data_create_time datetime 
end
go

EXEC sp_bindefault N'[dbo].[now]', N'[t_video_server].[data_create_time]'
GO

update t_video_server set data_create_time = online_date where data_create_time is null
go







