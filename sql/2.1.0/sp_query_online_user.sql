if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_query_online_user]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_query_online_user]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/*
//Description :查询在线用户列表
//Company :GTAlarm 
//author: 潘龙泉
//Create Date :2006-09-29
//modify Info list:
*/
CREATE PROCEDURE sp_query_online_user
AS
select 
	t_online_user.user_account as useraccount, 
	t_org_user.username, 
	(select codename from t_codediction where codetype='USERTYPE' AND codevalue = t_org_user.usertype) user_type_name, 
	t_online_user.ip,
	case t_org_user.usertype 
		when '05'   then (select isnull(protect_dept_name, '') from t_protectdept where protect_dept_id = t_org_user.userdep)
		when '06'   then (select isnull(protect_dept_name, '') from t_protectdept where protect_dept_id = t_org_user.userdep)
		else (select isnull(department_name, '') from t_department where department_id = t_org_user.userdep)
	end department_name, 	
	t_services.guid, 
	t_services.outip
from 
	t_online_user 
		left join t_org_user on t_org_user.useraccount = t_online_user.user_account
		left join t_services on t_services.guid = t_online_user.messeger_guid
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

