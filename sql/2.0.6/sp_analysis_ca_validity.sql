if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_analysis_ca_validity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_analysis_ca_validity]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
//Description :分析CA证书是否过期
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-12-20
//modify Info list:
//     modified by zhangtao 20061228 
*/

CREATE PROCEDURE dbo.sp_analysis_ca_validity AS

	DECLARE @now DATETIME
	SET @now = getdate()
	print @now

	UPDATE t_ca_device SET state = 1 WHERE valid_end < @now

	UPDATE t_ca_user SET state = 1 WHERE valid_end < @now

	UPDATE t_org_user SET orkey ='03' WHERE exists(SELECT user_account FROM  t_ca_user WHERE state = 1 and user_account = t_org_user.useraccount)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

