--delete objects unuseless--
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_useraccount_map]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_useraccount_map]
GO