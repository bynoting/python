if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_user]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_user]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE VIEW dbo.v_user
AS
 select USERACCOUNT as user_account,USERAREAR, USERCALLING, USERDEP, USERDEPADDRESS, 
			USERDEPPHONE, USERDISID, USEREMAIL, USERFAX, 
			USERLASTLOGIN, USERMODBILE, USERNAME, USERPERSONID, 
			USERPOSTCODE, USERPWD, USERSTATE, USERTYPE, CONTROL_LEVEL, 
			(select codename from t_codediction where codetype='USERTYPE' and codevalue = usertype) user_type_name, 
			(select codename from t_codediction where codetype='AREACODE' and codevalue = userarear) user_arear_name, 
			(select codename from t_codediction where codetype='TRADECODE' and codevalue = usercalling) user_calling_name, 
			user_dept_name =
				case usertype 
					when '05' then (select protect_dept_name from t_protectdept where protect_dept_id = userdep)
					when '06' then (select protect_dept_name from t_protectdept where protect_dept_id = userdep) 
					else (select department_name from t_department where department_id = userdep) 				end, 
			ORKEY, isp, view_channels 
	from t_org_user where USERSTATE = '01'