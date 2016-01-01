update t_event_sender_set set sender_id='_sys_' where sender_id='sys'

---------------------------------------------------------------------
-- 加入防区号字段
---------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='zone_id' and id = object_id(N't_event_sender_set'))
begin
    alter table t_event_sender_set add zone_id int 
end
go

update t_event_sender_set set zone_id = p.zone_id from t_input_port p 
where 
p.VideoServGuid = t_event_sender_set.device_guid and 
p.input_port_number = t_event_sender_set.channel_id and 
t_event_sender_set.zone_id is null

go

---------------------------------------------------------------------
-- 更新老数据的非端口报警和移动侦测的防区号
---------------------------------------------------------------------
-- 人工报警
update t_event_sender_set set zone_id = 101,channel_id=101 where (zone_id is null) and (alarm_type = 4)
go
-- 故障报警
update t_event_sender_set set zone_id = 102,channel_id=102 where (zone_id is null) and (alarm_type = 2)
go
-- 数字报警
update t_event_sender_set set zone_id = 103,channel_id=103 where (zone_id is null) and (alarm_type = 7)
go
