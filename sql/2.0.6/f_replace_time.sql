if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[f_replace_time]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[f_replace_time]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

-------------------------------------------------------    
--Name  :  f_replace_time                                         
--Notes  : 替换传入日期的时间部分                                           
--Author:  zhangtao 
--Date  :  2008-02-20                             
-------------------------------------------------------
CREATE FUNCTION dbo.f_replace_time (@datetime datetime,@time_str nvarchar(8))  
RETURNS datetime  AS  
BEGIN 
	return  convert(datetime,convert(varchar,@datetime,101) + ' ' + @time_str)
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

