----------------------------------------------------------------------------------------
-- 删除一些无用的字段
----------------------------------------------------------------------------------------
if exists( select 1 from dbo.syscolumns s where name ='video_server_id'
	and id = object_id(N't_alarm_log'))
begin
	if exists( select 1 from sysobjects where name = 'DF_t_alarm_log_video_server_id')
		alter table t_alarm_log drop constraint DF_t_alarm_log_video_server_id

	alter table t_alarm_log drop column video_server_id
end

if exists( select 1 from dbo.syscolumns s where name ='transmit'
	and id = object_id(N't_alarm_log'))
begin
	alter table t_alarm_log drop column transmit
end

if exists( select 1 from dbo.syscolumns s where name ='gateway'
	and id = object_id(N't_alarm_log'))
begin
	alter table t_alarm_log drop column gateway
end

if exists( select 1 from dbo.syscolumns s where name ='is_transmit'
	and id = object_id(N't_alarm_log'))
begin
	alter table t_alarm_log drop column is_transmit
end

-----------------------------------------------------------------------------------
-- 将encoder_id更名为zone_ids
-----------------------------------------------------------------------------------
if exists (select  * from INFORMATION_SCHEMA.COLUMNS 
  where table_name = 't_alarm_log' and column_name = 'devicealarm_time')
begin
 exec sp_rename 't_alarm_log.encoder_id','zone_ids','COLUMN'
end

-----------------------------------------------------------------------------------
-- 将devicealarm_time更名为device_alarm_time
-----------------------------------------------------------------------------------
if exists (select  * from INFORMATION_SCHEMA.COLUMNS 
  where table_name = 't_alarm_log' and column_name = 'devicealarm_time')
begin
 exec sp_rename 't_alarm_log.devicealarm_time','device_alarm_time','COLUMN'
end

-----------------------------------------------------------------------------------
-- 加入GUID字段
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- 加入GUID字段
-----------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='guid' and id = object_id(N't_alarm_log'))
begin
	alter table t_alarm_log add guid guid
	create   index idx_t_alarm_log_guid on t_alarm_log (  guid ASC  )  
end
go

update t_alarm_log set guid = newid() where guid is null
go






