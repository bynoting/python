if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_services_isp_live]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_services_isp_live]
GO

------------------------------------------------------------------------------
-- ����: v_services_isp_live
-- ����: zhangtao, 200703
-- ����: 
--   Ϊ�û���ISP�ַ�����ʱ, ������ҵ�ǰ��ķ���(�����õ�ISP��Ϣ)
------------------------------------------------------------------------------
CREATE VIEW dbo.v_services_isp_live
AS

SELECT s.guid, s.type, s.max_clients, s.live_clients,s.port, s.services, s.outip, i.isp,i.ip
FROM dbo.t_services s  inner join
        dbo.t_service_isp i ON s.guid = i.server_guid 
WHERE (i.isuse = 1) AND (s.is_live = 1)


