-----------------------------------------------------------------------------
-- 删除空的联动配置数据
-----------------------------------------------------------------------------
delete t_alarm_linkage where linkage_action = '0' or linkage_action = '0,0,0,0,0'
go

-- added 20080131 
exec spt_modify_column_type 't_alarm_linkage','linkage_action','nvarchar(50)'
go