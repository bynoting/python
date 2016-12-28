truncate table t_alarm_type

exec spt_id_to_guid 't_alarm_type'
exec spt_modify_column_type 't_alarm_type','code','int'
exec spt_modify_column_type 't_alarm_type','has_channel','int'

go

