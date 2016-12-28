------------------------------------------------------------------
-- 加入设备序列号字段
------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='video_server_sn' and id = object_id(N't_alarm_transmit_log'))
begin
    alter table t_alarm_transmit_log add video_server_sn video_server_sn null
end

