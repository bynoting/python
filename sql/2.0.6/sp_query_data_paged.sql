if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_data_paged]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_data_paged]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
//Description :查询分页
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-08-17
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_query_data_paged
	@TableName   		varchar(255),       			-- 表名
	@FieldsName   		varchar(1000) = '*',  			-- 需要返回的列 
	@SortFieldName 	varchar(255)='',     			-- 排序的字段名
	@PageSize   		int = 10,          				-- 页尺寸
	@PageIndex 		int = 1,           				-- 页码
	@OrderType 		varchar(4),  				-- 设置排序类型 desc:降序  asc:升序
	@Where  		varchar(2000) = '' , 			-- 查询条件 (注意: 不要加 where)
	@RecordCount		int output, 				-- 记录数
	@PageCount		int output 				-- 页数
AS
DECLARE @SQLSTR NVARCHAR(4000)
if @PageCount = 0
begin
	set @SQLSTR = 'SELECT @RecordCount = COUNT(0) FROM ' + @TableName + @Where
	--print @SQLSTR
	exec sp_executesql @SQLSTR, N'@RecordCount int output', @RecordCount output
	--print @RecordCount
	set @PageCount = CEILING(@RecordCount * 1.0 / @PageSize) 
	--print @PageCount
end

if @PageIndex > @PageCount return
--第1页
IF @PageIndex = 0 or @PageIndex = 1 or @PageCount <= 1
	SET @SQLSTR ='SELECT TOP '+ STR( @PageSize ) + ' ' +  @FieldsName + ' FROM ' + @TableName + @Where  + ' ORDER BY ' + @SortFieldName + '  DESC'
--最后一页
ELSE IF @PageIndex = @PageCount 
	SET @SQLSTR =	' SELECT ' +  @FieldsName + ' FROM ' +
				'( SELECT TOP '+STR( @RecordCount - @PageSize * (@PageIndex -1) )+ ' ' + @FieldsName + '  FROM ' + @TableName + @Where + '  ORDER BY ' + @SortFieldName + '  ASC ) tempTable  ' +
				' ORDER BY ' + @SortFieldName + ' DESC'
--中间页
ELSE 
	SET @SQLSTR =' SELECT TOP '+STR( @PageSize )+ ' ' + @FieldsName +  '  FROM ' +
				'( SELECT TOP '+STR( @RecordCount - @PageSize * (@PageIndex -1)  )+ ' ' + @FieldsName + '  FROM ' +  @TableName +  @Where + '  ORDER BY ' + @SortFieldName + '  ASC ) tempTable  ' +
				' ORDER BY ' + @SortFieldName + ' DESC'
print @SQLSTR
--EXEC (@SQLSTR)
exec sp_executesql @SQLSTR
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

