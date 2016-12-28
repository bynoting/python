if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_device_fault_insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_device_fault_insert]
GO

----------------------------------------------------------------------------------------------------------------------------
--�洢����: sp_device_fault_insert
--����:     ���豸���ϱ��м�����ϼ�¼,���Ҫ�����ǰ������@fault_type_array���ջ�'999'
--����:     zhangtao, 200704
--�޸�:     ���ع����������µĹ������� zhangtao 200811
----------------------------------------------------------------------------------------------------------------------------
CREATE   PROCEDURE dbo.sp_device_fault_insert(
	/** �豸���к� */
	@video_server_sn char (16), 
	/** �������͵��б�,��'|'�ָ�, ��ʽ��: 001|021|018 */
	@fault_type_array varchar (300),
	/** �¹�������б���'|'�ָ�, ��ʽ��: 001|021|018 */
	@fault_type_new  varchar(300) out
    )
AS
	declare @report_time datetime
	declare @strlist varchar(50),@pos int, @delim char, @type varchar(50)
	declare @guid guid
		
	set @report_time = getdate()
	set @strlist = replace(@fault_type_array,'999','')
	set @delim = '|' 
	set @fault_type_new = ''
	
	begin tran t1
	while ((len(@strlist) > 0) and (@strlist <> ''))
	begin
		--�ӹ������ʹ��н��������������� 
		set @pos = charindex(@delim, @strlist)
	
		if @pos > 0
		begin
			set @type = substring(@strlist, 1, @pos-1)
			set @strlist = ltrim(substring(@strlist,charindex(@delim, @strlist)+1, 8000))
		end
		else
		begin
			set @type = @strlist
			set @strlist = ''
		end
		if @type = '' continue

		-- ������ͬ�豸�����Ƿ����, ���������±���ʱ��ͱ������,��������¹��ϼ�¼
		set @guid = null
		select @guid = guid  from am_device_fault where video_server_sn = @video_server_sn and fault_type = @type
		
		if @guid is null
		begin
			insert into am_device_fault (video_server_sn,fault_type,last_report_time) values(@video_server_sn,@type,@report_time)
			set @fault_type_new = @fault_type_new + '|' + @type
		end
		else
		begin
			update am_device_fault set report_count = report_count + 1,last_report_time=@report_time  where guid = @guid
		end
	end

	--���Ѿ��ָ��Ĺ���������ʷ����
	insert into am_device_fault_his  select * from am_device_fault where video_server_sn = @video_server_sn and last_report_time <> @report_time
	delete from am_device_fault where video_server_sn = @video_server_sn and last_report_time <> @report_time
	commit tran t1
GO
