--------------------------------------------------------------------------------------------------------------
-- 将防区号按照设备与系统的通讯协议统一起来
-- 具体的更改为：
--    移动侦测防区号从10开始，因此将移动侦测防区号加10
--------------------------------------------------------------------------------------------------------------
update t_alarm_linkage set linkage_port = linkage_port + 10 where linkage_type = 1 and linkage_port < 10
update T_event_sender_set set channel_id = channel_id + 10 where alarm_type = 5 and channel_id < 10