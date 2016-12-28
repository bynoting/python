---------------------------------------------------------------------------------
-- ����һ���Ƿ񲼷����ֶ�
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='is_armed' and id = object_id(N't_input_port'))
begin
    alter table t_input_port add is_armed bool 
end
go

EXEC sp_bindefault N'[dbo].[one_or_true]', N'[t_input_port].[is_armed]'
GO

update t_input_port set is_armed  = 1 where is_armed is null
go

---------------------------------------------------------------------------------
-- ���ӷ��������ֶ�
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='zone_type' and id = object_id(N't_input_port'))
begin
    alter table t_input_port add zone_type int 
end
go

EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[t_input_port].[zone_type]'
GO

update t_input_port set zone_type  = 0 where zone_type is null
go

---------------------------------------------------------------------------------
-- �½�һ������
---------------------------------------------------------------------------------
if not exists(
    select 1 from sysindexes a join sysindexkeys b on a.id=b.id and a.indid=b.indid
	join sysobjects c on b.id=c.id and c.xtype='U' and  c.name<>'dtproperties'
	join syscolumns d on b.id=d.id and b.colid=d.colid
	where a.id = object_id('t_input_port') 
	    and d.name = 'VideoServGuid'
	    and  INDEXPROPERTY(a.id,a.name,'IsStatistics') = 0
	    and  INDEXPROPERTY(a.id,a.name,'IsAutoStatistics') = 0
	    and  INDEXPROPERTY(a.id,a.name,'IsClustered') = 0
	    )
begin	    
 CREATE  INDEX [IX_t_input_port_vs_sn] ON [dbo].[t_input_port]([VideoServGuid]) ON [PRIMARY]
end
go

---------------------------------------------------------------------------------
-- ��������������Ȫ��� 20070711
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- �����Ƿ��Զ������ֶ�
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='is_auto_armed' and id = object_id(N't_input_port'))
begin
    alter table t_input_port add is_auto_armed bool 
end
go

EXEC sp_bindefault N'[dbo].[zero_or_false]', N'[t_input_port].[is_auto_armed]'
GO

update t_input_port set is_auto_armed  = 0 where is_auto_armed is null
go

---------------------------------------------------------------------------------
-- �����Զ�������ʼʱ���ֶ�
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='armed_begin_time' and id = object_id(N't_input_port'))
begin
    alter table t_input_port add armed_begin_time datetime 
end
go

---------------------------------------------------------------------------------
-- �����Զ���������ʱ���ֶ�
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='armed_end_time' and id = object_id(N't_input_port'))
begin
    alter table t_input_port add armed_end_time datetime 
end
go

---------------------------------------------------------------------------------
-- ���ӷ�������ֶΣ������У�������f_cacl_zone_id�����豸���ͺͶ˿ںż���
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='zone_id' and id = object_id(N't_input_port'))
begin
    alter table t_input_port add zone_id as ([dbo].[f_cacl_zone_id]([input_port_number], [device_type]))  
end
go


