----------------------------------------------------------------------------------------------------
-- ������t_protocal_command���Լ�����ص���ͼ��ҳ������
----------------------------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_dev_protocal_command]') 
	and OBJECTPROPERTY(id, N'IsView') = 1)
	drop view v_dev_protocal_command
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_protocal_command]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_protocal_command]
GO


delete from T_UI_MENU where PAGEID='80'
delete from T_UI_PAGE where PAGEID='80'

