---------------------------------------------------------------------------------
-- ����һ���Ƿ񲼷����ֶ�
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
-- �����Ƿ��Զ������ֶ�
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
-- �����Զ�������ʼʱ���ֶ�
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='armed_begin_time' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add armed_begin_time datetime 
end
go

---------------------------------------------------------------------------------
-- �����Զ���������ʱ���ֶ�
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='armed_end_time' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add armed_end_time datetime 
end
go

---------------------------------------------------------------------------------
-- ���ӷ�������ֶΣ������У�������f_cacl_zone_id�����豸���ͺͶ˿ںż���
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='zone_id' and id = object_id(N't_video_input_port'))
begin
    alter table t_video_input_port add zone_id as ([dbo].[f_cacl_zone_id]([video_input_port_no], [device_type]))  
end
go


