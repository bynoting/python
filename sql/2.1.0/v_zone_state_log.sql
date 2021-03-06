if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_zone_state_log]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_zone_state_log]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.v_zone_state_log
AS
SELECT 
	dbo.am_zone_state_log.guid, 
	dbo.am_zone_state_log.zone_guid, 
	dbo.am_zone_state_log.changed_state, 
	dbo.am_zone_state_log.change_time, 
	dbo.t_input_port.zone_id, 
      	dbo.v_watch_point_device.*
FROM 
	dbo.am_zone_state_log 
	INNER JOIN dbo.t_input_port ON dbo.am_zone_state_log.zone_guid = dbo.t_input_port.DiGuid 
	INNER JOIN dbo.v_watch_point_device ON dbo.t_input_port.VideoServGuid = dbo.v_watch_point_device.video_server_sn


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


