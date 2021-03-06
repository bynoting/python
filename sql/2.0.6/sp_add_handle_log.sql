if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_add_handle_log]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_add_handle_log]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.sp_add_handle_log
	@EventID varchar(50),
	@Handler varchar(36),
	@HandleObject nvarchar(1024),
	@State int,
	@Remark varchar(255)
 AS

	INSERT INTO t_handle_log(
		log_event_id,
		handler,
		handle_object,
		handle_date,
		handle_state,
		remark)
	VALUES(
		@EventID,
		@Handler,
		@HandleObject,
		getdate(),
		@State,
		@Remark)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

