IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'dbo.sp_tree') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP procedure [dbo].[sp_tree]
GO

/*************************************************************************
 * 工具类存储过程: sp_tree
 * 描述: 树结构数据访问
 * 作者: zhangtao,200803
 ************************************************************************/
create procedure dbo.sp_tree
(
	@table nvarchar(30), 	/* 表名 */
	@operation_type int,	/* 操作类型 1: 查询; 2: 添加; 3:删除; 4: 更新; 5: 移动; 5: 拷贝 */
	@tree_id int out,	/* 节点ID*/
	@parent_tree_id int,	/* 父节点ID*/
	@name chinese_name,	/* 名称 */
	@level_code nvarchar(50) out/* 层次码 */
)
as

declare @sql nvarchar(200)

--操作：查询子节点
--参数: 	@table , @tree_id
--返回： 数据集
if(@operation_type = 1)
begin
	select @sql = 'select tree_id,parent_tree_id,name,level_code from ' + @table + ' where parent_tree_id = ' + ltrim(str(@tree_id))
	exec dbo.sp_executesql @sql
	return 
end

set nocount on

--操作：添加
--参数: 	@table , @parent_tree_id, @name
--返回: @level_code, @tree_id
--备注：如果@parent_tree_id为-1，表示插入根节点
if(@operation_type = 2)
begin
	-- 取父节点的层次码
	if @parent_tree_id <> -1 
	begin
		select @sql = 'select @level_code = level_code from ' + @table + ' where tree_id = ' + ltrim(str(@parent_tree_id))
		exec dbo.sp_executesql @sql,N'@level_code nvarchar(50) out', @level_code out

		if (@level_code is null  or @level_code = '')
		begin
			select '找不到父节点'
			return 
		end
	end
    
	declare @guid varchar(36)
	select @guid = newid()
  
	-- 插入数据
	select @sql = 'insert into ' + @table + ' (guid,parent_tree_id,name) values (''' + @guid + ''',' + ltrim(str(@parent_tree_id)) + ',''' + @name + ''')'
	exec dbo.sp_executesql @sql

	-- 更新新插入节点的层次码
	select @sql = 'select @tree_id = tree_id from ' + @table + ' where guid = ''' + @guid + ''''
	exec dbo.sp_executesql @sql,N'@tree_id int out', @tree_id out

	select @level_code = @level_code + replace(str(@tree_id, 5), space(1), '0')
	
	select @sql = 'update ' + @table + ' set level_code=''' + @level_code + ''' where guid = ''' + @guid + ''''
	exec dbo.sp_executesql @sql
	return 
end

--操作：	删除
--参数: 	@table , @level_code
if(@operation_type = 3) 
begin
	select @sql = 'delete ' + @table + ' where level_code like ''' + @level_code + '%'''
	exec dbo.sp_executesql @sql
	return 
end

--操作：修改
--参数: 	@table , @tree_id, @name
if(@operation_type = 4) 
begin
	select @sql = 'update ' + @table + ' set name=''' + @name + ''' where tree_id=' + ltrim(str(@tree_id))
	exec dbo.sp_executesql @sql
	return 
end

--操作：移动
--参数: 	@table , @tree_id, @level_code(新的父节点的层次码)
if(@operation_type = 5) 
begin
	declare @old_leve_code varchar(50)

	-- 取原父节点的层次码
	select @sql = 'select @level_code = level_code from ' + @table + ' where tree_id = ' + ltrim(str(@tree_id))
	exec dbo.sp_executesql @sql,N'@level_code nvarchar(50) out', @old_leve_code out

	if @level_code is null /* 本节点为根节点, 无父节点 */
		select @level_code = '' 

	select @level_code = @level_code + replace(str(@tree_id, 5), space(1), '0')
	select @sql = 'update ' + @table + 
		' set level_code=replace(level_code,''' + @old_leve_code + ''', ''' + @level_code + ''') where level_code like ''' + @old_leve_code + '%'''
	exec dbo.sp_executesql @sql
	return 
end

GO
