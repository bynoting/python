---------------------------------------------------------------------------------
-- 增加一个是否布防的字段
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='is_armed' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add is_armed bool 
end
go

EXEC sp_bindefault N'[dbo].[one_or_true]', N'[t_video_input_port].[is_armed]'
GO

update t_video_input_port set is_armed  = 1 where is_armed is null
go

---------------------------------------------------------------------------------
-- 增加是否自动布防字段
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='is_auto_armed' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add is_auto_armed bool 
end
go

EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[t_video_input_port].[is_auto_armed]'
GO

update t_video_input_port set is_auto_armed  = 0 where is_auto_armed is null
go

---------------------------------------------------------------------------------
-- 增加自动布防起始时间字段
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='armed_begin_time' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add armed_begin_time datetime 
end
go

---------------------------------------------------------------------------------
-- 增加自动布防结束时间字段
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='armed_end_time' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add armed_end_time datetime 
end
go

---------------------------------------------------------------------------------
-- 增加防区编号字段（计算列），调用f_cacl_zone_id根据设备类型和端口号计算
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='zone_id' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add zone_id as ([dbo].[f_cacl_zone_id]([video_input_port_no], [device_type]))  
end
go


