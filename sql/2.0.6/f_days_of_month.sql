if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[f_days_of_month]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[f_days_of_month]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


--��һ�����ڣ����㵱���ж�����
CREATE FUNCTION dbo.f_days_of_month(@dt datetime)
RETURNS int
 AS  
BEGIN 
	return 32-day(@dt+(32-day(@dt))) 
END


