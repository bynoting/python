if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_show_big_tables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_show_big_tables]
GO

----------------------------------------------------------------------------------------------------------------------
-- 工具类存储过程: spt_show_big_tables
-- 描述: 显示数据量前10名的大表
-- 作者: zhangtao,200704
----------------------------------------------------------------------------------------------------------------------
CREATE procedure dbo.spt_show_big_tables
as
	DECLARE @tableName varchar(100)
	DECLARE @rowCount  int

	/** 列出数据量前10名的表 */
	SELECT top 10
	    [TableName] = so.name, 
	    [RowCount] = MAX(si.rows) 
	FROM 
	    sysobjects so, 
	    sysindexes si 
	WHERE 
	    so.xtype = 'U' AND si.id = OBJECT_ID(so.name) 
	GROUP BY 
	    so.name 
	ORDER BY 
	    2 DESC
	    
	/** 打印前10名中数据行数超过1万条的表的占用的空间 */
	DECLARE table_cursor CURSOR FOR 
		SELECT  top 10
			[TableName] = so.name, 
			[RowCount] = MAX(si.rows) 
		FROM 
			sysobjects so, 
			sysindexes si 
		WHERE 
			so.xtype = 'U' AND si.id = OBJECT_ID(so.name) 
		GROUP BY 
			so.name 
		ORDER BY 
			2 DESC
		
	OPEN     table_cursor
	FETCH NEXT FROM table_cursor INTO @tableName,@rowCount
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		if @rowCount > 10000
			exec sp_spaceused @tableName
	   FETCH NEXT FROM table_cursor INTO @tableName,@rowCount
	END
	
	CLOSE table_cursor
	DEALLOCATE table_cursor
GO
