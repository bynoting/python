SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[f_cacl_zone_id]') and xtype in (N'FN', N'IF', N'TF'))
begin
    exec ('
	-------------------------------------------------------------------------------------------------------
	-- 用于在端口表t_input_port中计算防区编号
	-------------------------------------------------------------------------------------------------------
	create   function   f_cacl_zone_id(@port_number int , @device_type int)  
	returns   int  
	as  
	begin  

	--zone 
	if @device_type = 35 
	begin
	    if @port_number < 10 return @port_number
		return @port_number + 16
	    end
	    --video port 
	    return @port_number + 10
	end ')
end
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
