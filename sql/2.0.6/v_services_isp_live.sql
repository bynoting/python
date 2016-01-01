if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_services_isp_live]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_services_isp_live]
GO

------------------------------------------------------------------------------
-- 名称: v_services_isp_live
-- 作者: zhangtao, 200703
-- 描述: 
--   为用户按ISP分发服务时, 方便查找当前活动的服务(带可用的ISP信息)
------------------------------------------------------------------------------
CREATE VIEW dbo.v_services_isp_live
AS

SELECT s.guid, s.type, s.max_clients, s.live_clients,s.port, s.services, s.outip, i.isp,i.ip
FROM dbo.t_services s  inner join
        dbo.t_service_isp i ON s.guid = i.server_guid 
WHERE (i.isuse = 1) AND (s.is_live = 1)


