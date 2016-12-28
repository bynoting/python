/* 删除无用的地图表 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_map_position]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_map_position]
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_device_role_map]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_device_role_map]

go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[t_map]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[t_map]

go