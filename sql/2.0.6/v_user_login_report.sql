if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_user_login_report]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_user_login_report]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.v_user_login_report
AS
SELECT log_id, login_time, exit_time, login_ip, user_name, login_state,
          (SELECT codename
         FROM t_codediction
         WHERE codetype = 'HANDLESTATE' AND codevalue = convert(varchar, login_state))
      AS login_stateName, remark
FROM dbo.t_login_log



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

