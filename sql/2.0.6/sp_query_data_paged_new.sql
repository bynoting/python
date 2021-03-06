if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_data_paged_new]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_data_paged_new]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
//Description :分页存储过程
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2007-04-12
//modify Info list:
*/
CREATE PROCEDURE dbo.sp_query_data_paged_new

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

declare @strSQL   nvarchar(4000)      -- 主语句
declare @strTmp   varchar(110)        -- 临时变量
declare @strOrder varchar(400)        -- 排序类型

--如果@RecordCount传递过来的是0，就执行总数统计
if @RecordCount = 0
	begin
    		if @Where !=''
			set @strSQL = 'select @RecordCount = count(0) from ' + @TableName + ' where ' + @Where
		else
    			set @strSQL = 'select @RecordCount = count(0) from ' + @TableName

		exec sp_executesql @strSQL, N'@RecordCount int output', @RecordCount output
		print @RecordCount
		set @PageCount = CEILING(@RecordCount * 1.0 / @PageSize) 
		print @PageCount
	end  

if @OrderType = 'desc'
	begin
    		set @strTmp = " < (select min"
		set @strOrder = " order by " + @SortFieldName +" desc"
		--如果@OrderType不是0，就执行降序，这句很重要
	end
else
	begin
    		set @strTmp = " > (select max"
    		set @strOrder = " order by " + @SortFieldName +" asc"
	end

if @PageIndex = 0
	set @PageIndex = 1

if @PageIndex = 1
	begin
		if @Where != ''   
			set @strSQL = "select top " + str(@PageSize) +" "+@FieldsName+ "  from " + @TableName + " where " + @Where + " " + @strOrder
		else
			set @strSQL = "select top " + str(@PageSize) +" "+@FieldsName+ "  from "+ @TableName + " "+ @strOrder

		--如果是第一页就执行以上代码，这样会加快执行速度
	end
else
	begin
		--以下代码赋予了@strSQL以真正执行的SQL代码
		set @strSQL = "select top " + str(@PageSize) +" "+@FieldsName+ "  from "
			+ @TableName + " where " + @SortFieldName + "" + @strTmp + "("+ @SortFieldName + ") from (select top " + str((@PageIndex-1)*@PageSize) + " "+ @SortFieldName + " from " + @TableName + "" + @strOrder + ") as tblTmp)"+ @strOrder

		if @Where != ''
    		set @strSQL = "select top " + str(@PageSize) +" "+@FieldsName+ "  from "
			+ @TableName + " where " + @SortFieldName + "" + @strTmp + "("
			+ @SortFieldName + ") from (select top " + str((@PageIndex-1)*@PageSize) + " "
			+ @SortFieldName + " from " + @TableName + " where " + @Where + " "
			+ @strOrder + ") as tblTmp) and " + @Where + " " + @strOrder

	end 

print @strSQL
exec (@strSQL)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

