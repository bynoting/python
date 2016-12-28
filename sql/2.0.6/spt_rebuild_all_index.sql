if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spt_rebuild_all_index]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spt_rebuild_all_index]
GO

----------------------------------------------------------------------------------------------------------------------
-- 工具类存储过程: spt_rebuild_all_index
-- 描述: 重建所有索引
-- 作者: zhangtao,200803
----------------------------------------------------------------------------------------------------------------------
CREATE procedure dbo.spt_rebuild_all_index
as

DECLARE @TableName varchar(255)

DECLARE TableCursor CURSOR FOR
SELECT table_name FROM information_schema.tables
WHERE table_type = 'base table'

OPEN TableCursor

FETCH NEXT FROM TableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
DBCC DBREINDEX(@TableName,' ',90)
FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor

DEALLOCATE TableCursor