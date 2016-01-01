if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_drop_index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_drop_index]
GO

----------------------------------------------------------------------------------------------------------------------
-- 工具类存储过程: spt_drop_index
-- 描述: 删除索引
-- 作者: zhangtao,200803
----------------------------------------------------------------------------------------------------------------------
CREATE procedure dbo.spt_drop_index
  @table		nvarchar(40), /*表名*/
  @column	nvarchar(40) /*字段名*/
as
declare @indexname varchar(100)  

select 
      @indexname = a.name
      from sysindexes a join sysindexkeys b on a.id=b.id and a.indid=b.indid
      join sysobjects c on b.id=c.id and c.xtype='U' and  c.name<>'dtproperties'
      join syscolumns d on b.id=d.id and b.colid=d.colid
      where a.id = object_id(@table) 
          and d.name = @column
          and  INDEXPROPERTY(a.id,a.name,'IsStatistics') = 0
          and  INDEXPROPERTY(a.id,a.name,'IsAutoStatistics') = 0

if @indexname is not null 
 exec('DROP INDEX ' + @table + '.' + @indexname)

