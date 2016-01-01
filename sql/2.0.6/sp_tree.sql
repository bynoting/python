IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'dbo.sp_tree') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP procedure [dbo].[sp_tree]
GO

/*************************************************************************
 * ������洢����: sp_tree
 * ����: ���ṹ���ݷ���
 * ����: zhangtao,200803
 ************************************************************************/
create procedure dbo.sp_tree
(
	@table nvarchar(30), 	/* ���� */
	@operation_type int,	/* �������� 1: ��ѯ; 2: ���; 3:ɾ��; 4: ����; 5: �ƶ�; 5: ���� */
	@tree_id int out,	/* �ڵ�ID*/
	@parent_tree_id int,	/* ���ڵ�ID*/
	@name chinese_name,	/* ���� */
	@level_code nvarchar(50) out/* ����� */
)
as

declare @sql nvarchar(200)

--��������ѯ�ӽڵ�
--����: 	@table , @tree_id
--���أ� ���ݼ�
if(@operation_type = 1)
begin
	select @sql = 'select tree_id,parent_tree_id,name,level_code from ' + @table + ' where parent_tree_id = ' + ltrim(str(@tree_id))
	exec dbo.sp_executesql @sql
	return 
end

set nocount on

--���������
--����: 	@table , @parent_tree_id, @name
--����: @level_code, @tree_id
--��ע�����@parent_tree_idΪ-1����ʾ������ڵ�
if(@operation_type = 2)
begin
	-- ȡ���ڵ�Ĳ����
	if @parent_tree_id <> -1 
	begin
		select @sql = 'select @level_code = level_code from ' + @table + ' where tree_id = ' + ltrim(str(@parent_tree_id))
		exec dbo.sp_executesql @sql,N'@level_code nvarchar(50) out', @level_code out

		if (@level_code is null  or @level_code = '')
		begin
			select '�Ҳ������ڵ�'
			return 
		end
	end
    
	declare @guid varchar(36)
	select @guid = newid()
  
	-- ��������
	select @sql = 'insert into ' + @table + ' (guid,parent_tree_id,name) values (''' + @guid + ''',' + ltrim(str(@parent_tree_id)) + ',''' + @name + ''')'
	exec dbo.sp_executesql @sql

	-- �����²���ڵ�Ĳ����
	select @sql = 'select @tree_id = tree_id from ' + @table + ' where guid = ''' + @guid + ''''
	exec dbo.sp_executesql @sql,N'@tree_id int out', @tree_id out

	select @level_code = @level_code + replace(str(@tree_id, 5), space(1), '0')
	
	select @sql = 'update ' + @table + ' set level_code=''' + @level_code + ''' where guid = ''' + @guid + ''''
	exec dbo.sp_executesql @sql
	return 
end

--������	ɾ��
--����: 	@table , @level_code
if(@operation_type = 3) 
begin
	select @sql = 'delete ' + @table + ' where level_code like ''' + @level_code + '%'''
	exec dbo.sp_executesql @sql
	return 
end

--�������޸�
--����: 	@table , @tree_id, @name
if(@operation_type = 4) 
begin
	select @sql = 'update ' + @table + ' set name=''' + @name + ''' where tree_id=' + ltrim(str(@tree_id))
	exec dbo.sp_executesql @sql
	return 
end

--�������ƶ�
--����: 	@table , @tree_id, @level_code(�µĸ��ڵ�Ĳ����)
if(@operation_type = 5) 
begin
	declare @old_leve_code varchar(50)

	-- ȡԭ���ڵ�Ĳ����
	select @sql = 'select @level_code = level_code from ' + @table + ' where tree_id = ' + ltrim(str(@tree_id))
	exec dbo.sp_executesql @sql,N'@level_code nvarchar(50) out', @old_leve_code out

	if @level_code is null /* ���ڵ�Ϊ���ڵ�, �޸��ڵ� */
		select @level_code = '' 

	select @level_code = @level_code + replace(str(@tree_id, 5), space(1), '0')
	select @sql = 'update ' + @table + 
		' set level_code=replace(level_code,''' + @old_leve_code + ''', ''' + @level_code + ''') where level_code like ''' + @old_leve_code + '%'''
	exec dbo.sp_executesql @sql
	return 
end

GO
