if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_id_to_guid]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_id_to_guid]
GO

----------------------------------------------------------------------------------------------------------------------
-- 工具类存储过程: spt_id_to_guid
-- 描述: 将以ID为主键的表更改为以GUID为主键
-- 作者: zhangtao,20080430
----------------------------------------------------------------------------------------------------------------------
CREATE procedure dbo.spt_id_to_guid
	@table  varchar(50)
as
    declare @constraint_name varchar(100)
    declare @is_primary int
    
    /** 检查Guid是否已经存在 */
    select  @constraint_name = constraint_name
      from INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
      where table_name = @table and column_name = 'guid'  and objectproperty(object_id(constraint_schema + '.' + constraint_name),'IsPrimaryKey') = 1
      
    if @constraint_name is not null
    begin
      print 'guid exists already'
      return
    end
      
    select @constraint_name = constraint_name,
      @is_primary = objectproperty(object_id(constraint_schema + '.' + constraint_name),'IsPrimaryKey')
      from INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
      where table_name = @table and column_name = 'id'  and objectproperty(object_id(constraint_schema + '.' + constraint_name),'IsPrimaryKey') = 1
      
    if @is_primary = 1
    begin
        print 'drop ' + @constraint_name
        exec('alter table ' + @table + ' drop constraint '+ @constraint_name)    
    end
    
    if @is_primary is not null
    begin
      print('drop id')
      exec('alter table ' + @table + ' drop column id')
    end
    
    print('add guid')

    exec('alter table ' + @table + ' add guid guid')
    
    exec('update ' + @table +  ' set guid = newid() where guid is null')
    
    exec dbo.spt_modify_column_type @table,'guid', 'guid not null'
    
    exec('alter table '+ @table + ' add constraint PK_' +  @table + ' primary key (guid)')
GO
