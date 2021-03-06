if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_without_ca_user]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_without_ca_user]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.sp_query_without_ca_user
	@user_account nvarchar(36) 
AS
	SELECT 
		useraccount,--用户帐号
		username,--用户姓名
		unit_name = --单位名称
		case usertype 
			when '05' then (select protect_dept_name from t_protectdept where protect_dept_id = userdep) 
			when '06' then (select protect_dept_name from t_protectdept where protect_dept_id = userdep) 
			else (select department_name from t_department where department_id = userdep) 
		end, 
		'' as dept_name,--部门名称
		isnull(state, 2) state --状态
	FROM 
		t_org_user left join t_ca_user on t_ca_user.user_account = t_org_user.useraccount
	WHERE
		userstate = '01' 
		AND not exists(select state from t_ca_user where state = 0  and user_account = t_org_user.useraccount)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

