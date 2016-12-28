if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[f_cacl_zone_id_linkage]') and xtype in (N'FN', N'IF', N'TF'))
begin
	exec ('
--------------------------------------------------------------------------------------------------------------------
-- 用于在端口表t_alarm_linkage中计算防区编号
--------------------------------------------------------------------------------------------------------------------
  create   function   f_cacl_zone_id_linkage(@port_number int , @linkage_type int)  
  returns   int  
  as  
  begin  
  
	  -- 端子
	  if @linkage_type  = 0 
	  begin
		if @port_number < 10 return @port_number
		return @port_number + 16
	  end

	  -- 视频端口
	  return @port_number + 10
  end  
  ')
end
go