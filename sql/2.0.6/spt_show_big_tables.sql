if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_show_big_tables]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_show_big_tables]
GO

----------------------------------------------------------------------------------------------------------------------
-- ������洢����: spt_show_big_tables
-- ����: ��ʾ������ǰ10���Ĵ��
-- ����: zhangtao,200704
----------------------------------------------------------------------------------------------------------------------
CREATE procedure dbo.spt_show_big_tables
as
	DECLARE @tableName varchar(100)
	DECLARE @rowCount  int

	/** �г�������ǰ10���ı� */
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
	    
	/** ��ӡǰ10����������������1�����ı��ռ�õĿռ� */
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
