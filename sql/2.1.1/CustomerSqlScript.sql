if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[gv_zone_customer_map]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[gv_zone_customer_map]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[gv_zone_info]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[gv_zone_info]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MisCustomer]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MisCustomer]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MisCustomerZone]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MisCustomerZone]
GO

CREATE TABLE [dbo].[MisCustomer] (
	[Guid] [uniqueidentifier] NOT NULL ,
	[DataCreateTime] [datetime] NULL ,
	[Number] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Address] [nvarchar] (1000) COLLATE Chinese_PRC_CI_AS NULL ,
	[TelPhone] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[Type] [nvarchar] (10) COLLATE Chinese_PRC_CI_AS NULL ,
	[Principal] [nvarchar] (200) COLLATE Chinese_PRC_CI_AS NULL ,
	[PrincipalTel] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[ABackUp] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Name] [nvarchar] (30) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[MisCustomerZone] (
	[Guid] [uniqueidentifier] NOT NULL ,
	[DataCreateTime] [datetime] NULL ,
	[CustomerGuid] [uniqueidentifier] NULL ,
	[VideoServerSn] [nvarchar] (16) COLLATE Chinese_PRC_CI_AS NULL ,
	[ZoneID] [int] NULL 
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.gv_zone_customer_map
AS
SELECT TOP 100 PERCENT dbo.MisCustomer.Guid, dbo.MisCustomer.Number, 
      dbo.MisCustomer.Name, dbo.MisCustomer.Address, dbo.MisCustomer.TelPhone, 
      dbo.MisCustomer.Type, dbo.MisCustomer.Principal, dbo.MisCustomer.PrincipalTel, 
      dbo.MisCustomer.ABackUp, dbo.MisCustomerZone.ZoneID, 
      dbo.v_zone_info.is_armed AS state, 
      dbo.v_watch_point_device.video_server_name AS videoservername, 
      dbo.MisCustomerZone.CustomerGuid, dbo.MisCustomerZone.VideoServerSn
FROM dbo.MisCustomerZone LEFT OUTER JOIN
      dbo.v_watch_point_device ON 
      dbo.MisCustomerZone.VideoServerSn = dbo.v_watch_point_device.video_server_sn LEFT
       OUTER JOIN
      dbo.v_zone_info ON dbo.MisCustomerZone.ZoneID = dbo.v_zone_info.zone_id AND 
      dbo.MisCustomerZone.VideoServerSn = dbo.v_zone_info.video_server_sn RIGHT OUTER
       JOIN
      dbo.MisCustomer ON 
      dbo.MisCustomer.Guid = dbo.MisCustomerZone.CustomerGuid
ORDER BY dbo.MisCustomer.ABackUp DESC, dbo.MisCustomer.Type DESC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.gv_zone_info
AS
SELECT dbo.v_zone_info.video_server_sn AS VideoServerSn, 
      dbo.v_zone_info.zone_id AS ZoneID, 
      dbo.t_video_server.video_server_name AS VideoServerName, 
      dbo.MisCustomer.Name, dbo.MisCustomer.Guid AS CustomerGuid
FROM dbo.MisCustomerZone INNER JOIN
      dbo.MisCustomer ON 
      dbo.MisCustomerZone.CustomerGuid = dbo.MisCustomer.Guid RIGHT OUTER JOIN
      dbo.v_zone_info INNER JOIN
      dbo.t_video_server ON 
      dbo.v_zone_info.video_server_sn = dbo.t_video_server.VideoServGuid ON 
      dbo.MisCustomerZone.VideoServerSn = dbo.v_zone_info.video_server_sn AND 
      dbo.MisCustomerZone.ZoneID = dbo.v_zone_info.zone_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

