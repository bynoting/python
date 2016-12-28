if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_modify_column_type]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_modify_column_type]
GO

/******************************************************************************
 * ������洢����: spt_modify_column_type 
 * ����:    �����ݱ��е��ֶθ�ΪԤ����ı�׼��������
 * ����:   Zhangtao, 200704
 * �޸ģ�  200705 ���ƶ�Ψһ�����Ĵ���(Ψһ������һ��Լ����������Create Index����)
 ******************************************************************************/
create procedure dbo.spt_modify_column_type
	@table  varchar(50),
	@column varchar(50),
	@type   varchar(30)
as
    /** �������Ϊ����,��ʱ��ɾ������ */
    declare @constraint_name varchar(100)
    declare @is_primary int

    select  
      @constraint_name = constraint_name,
      @is_primary = objectproperty(object_id(constraint_schema + '.' + constraint_name),'IsPrimaryKey')
      from INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
      where table_name = @table and column_name = @column 
      
    /** �������Ϊ����,��ʱ��ɾ������ */
    declare @indexname varchar(100)
    declare @is_unique int
    declare @sql_unique varchar(20)
    declare @sql_clustered varchar(20)
    
    select 
      @indexname = a.name, 
      @is_unique = INDEXPROPERTY(a.id,a.name,'IsUnique'),
      @sql_unique = CASE WHEN INDEXPROPERTY(a.id,a.name,'IsUnique') = 1 THEN ' UNIQUE ' ELSE ' ' END,
      @sql_clustered = CASE WHEN INDEXPROPERTY(a.id,a.name,'IsClustered') = 1 THEN ' CLUSTERED ' ELSE ' NONCLUSTERED ' END
      from sysindexes a join sysindexkeys b on a.id=b.id and a.indid=b.indid
      join sysobjects c on b.id=c.id and c.xtype='U' and  c.name<>'dtproperties'
      join syscolumns d on b.id=d.id and b.colid=d.colid
      where a.id = object_id(@table) 
          and d.name = @column
          and  INDEXPROPERTY(a.id,a.name,'IsStatistics') = 0
          and  INDEXPROPERTY(a.id,a.name,'IsAutoStatistics') = 0
   
    print @table + '.' + @column
    print '@constraint_name =  ' + isnull(@constraint_name,'')
    print '@indexname = '  +  isnull(@indexname,'')
    print '@is_unique = ' +  isnull(str(@is_unique),'0')
    print '@is_primary = ' +isnull( str(@is_primary),'0')

    if @constraint_name is not null
    begin
	exec('alter table ' + @table + ' drop constraint '+ @constraint_name)    
    end
    else
    begin
	if @indexname is not null 
	    exec('DROP INDEX ' + @table + '.' + @indexname)
    end

    /** �޸��������� */
    exec('alter table ' + @table + ' alter column ' + @column + ' ' + @type)

    /** �ָ����� */
    if @is_primary = 1 
    begin
      exec('ALTER TABLE ' + @table + ' WITH NOCHECK ADD PRIMARY KEY  CLUSTERED ( ' + @column + ')  ON [PRIMARY] ') 
      return
    end

    if @constraint_name is not null 
    begin
       exec('ALTER TABLE ' +  @table + ' ADD CONSTRAINT ' + @constraint_name + @sql_unique + @sql_clustered + '(' + @column + ')')
	return
    end
    
    /** �ָ����� */    
    if @indexname is not null
    begin
      exec('CREATE ' + @sql_unique + @sql_clustered  +' INDEX ' + @indexname + ' ON ' + @table + '(' + @column + ')')
    end
GO

	
