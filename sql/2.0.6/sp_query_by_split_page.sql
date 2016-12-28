if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_by_split_page]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_by_split_page]
GO
-------------------------------------------------------------------------------------------------------
--存储过程: sp_query_by_split_page
--描述:     分页查询数据
--作者:     zhangtao, 200801
-------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[sp_query_by_split_page]
(
    @SelectCommandText nvarchar(4000), /* 要执行的查询命令*/
    @CurrentPageIndex int = 0,  /* 当前页的索引，从 0 开始*/
    @PageSize int = 20,  /* 每页的记录数*/
    @RowCount int = 0 out, /* 总的记录数*/
    @PageCount int = 0 out /* 总的页数*/
)
AS

SET NOCOUNT ON

DECLARE @p1 int

SET @CurrentPageIndex = @CurrentPageIndex + 1

EXEC    sp_cursoropen @p1 output, @SelectCommandText, @scrollopt = 1, @ccopt = 1, @RowCount = @RowCount output;

SELECT @PageCount = ceiling(1.0 * @RowCount / @PageSize);
SELECT @CurrentPageIndex = (@CurrentPageIndex - 1) * @PageSize + 1

EXEC    sp_cursorfetch @p1,16, @CurrentPageIndex, @PageSize;
EXEC    sp_cursorclose @p1
GO
