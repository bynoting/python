if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_by_split_page]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_by_split_page]
GO
-------------------------------------------------------------------------------------------------------
--�洢����: sp_query_by_split_page
--����:     ��ҳ��ѯ����
--����:     zhangtao, 200801
-------------------------------------------------------------------------------------------------------
CREATE procedure [dbo].[sp_query_by_split_page]
(
    @SelectCommandText nvarchar(4000), /* Ҫִ�еĲ�ѯ����*/
    @CurrentPageIndex int = 0,  /* ��ǰҳ���������� 0 ��ʼ*/
    @PageSize int = 20,  /* ÿҳ�ļ�¼��*/
    @RowCount int = 0 out, /* �ܵļ�¼��*/
    @PageCount int = 0 out /* �ܵ�ҳ��*/
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
