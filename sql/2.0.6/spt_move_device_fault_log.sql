if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_move_device_fault_log]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_move_device_fault_log]
GO

--------------------------------------------------------------------------------------------------------------------
-- ����: ��APP2.0.6��ǰ�����ݿ��е��豸���ϱ�����ݵ����±�
-- ע��: ���ڸñ�����̫��,��������. �ο����Խ��: �����PC����, 100�������ݴ�Լ��ȥ���Сʱ
-- ��ʾ: ���ڴ���̫����ԭ�����ݽǶ�, �뿼�Ǵ�ԭ����ɾ������,���������һ��ʱ��Ĺ��ϼ�¼
--------------------------------------------------------------------------------------------------------------------
create procedure dbo.spt_move_device_fault_log 
as
declare @video_server_sn char (16)
declare @report_time datetime
declare @type varchar(4)
declare @guid guid
declare @id int

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[am_device_fault_log]') )
begin
	print 'error: am_device_fault_log is not exists'
	return
end	

while 1 = 1
begin
	set @id = null
	select top 1 @id = id,@video_server_sn = video_server_sn,@type = fault_type,@report_time=data_create_time from am_device_fault_log order by id asc

	if @id is null
		break
	
	print @id

	if @type = '999'	
	begin 
		print 'reset: ' + @video_server_sn  
		/**���Ѿ��ָ��Ĺ���������ʷ����*/
		insert into am_device_fault_his select * from am_device_fault where video_server_sn = @video_server_sn
		if @@rowcount > 0
			delete from am_device_fault where video_server_sn = @video_server_sn
	end 
	else
	begin
		/** ������ͬ�豸�����Ƿ����, ���������±���ʱ��ͱ������,��������¹��ϼ�¼*/
		set @guid = null
		select @guid = guid  from am_device_fault where video_server_sn = @video_server_sn and fault_type = @type
		
		if @guid is null
			insert into am_device_fault (video_server_sn,fault_type,last_report_time,data_create_time) values(@video_server_sn,@type,@report_time,@report_time)
		else
			update am_device_fault set report_count = report_count + 1,last_report_time=@report_time  where guid = @guid
	end

	delete am_device_fault_log where id = @id
end

go
