if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_biz_record_file]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_biz_record_file]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

------------------------------------------------------------------------------------
-- 描述：与业务关联的录像文件
-- 作者：zhangtao, 20080310
------------------------------------------------------------------------------------

CREATE VIEW dbo.v_biz_record_file
AS
SELECT dbo.am_record_biz.biz_guid, 
      dbo.am_record_biz.biz_type, 
      dbo.am_record_biz.record_type, 
      dbo.am_record_biz.record_state, 
      dbo.am_record_biz.message, 
      dbo.am_record_file.file_path, 
      dbo.am_record_biz.file_guid, 
      dbo.am_record_file.name, 
      dbo.am_record_file.begin_time, 
      dbo.am_record_file.width, 
      dbo.am_record_file.height, 
      dbo.am_record_file.video_format, 
      dbo.am_record_file.is_has_audio, 
      dbo.am_record_file.is_valid, 
      dbo.am_record_file.duration_s, 
      dbo.am_record_file.size_k, 
      dbo.am_record_file.data_create_user, 
      dbo.am_record_file.data_create_time
FROM dbo.am_record_biz INNER JOIN dbo.am_record_file ON dbo.am_record_biz.file_guid = dbo.am_record_file.guid

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

