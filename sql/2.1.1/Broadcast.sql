if not exists (select 1 from t_sys_parameter where paramname = 'BroadcastActionCode' and paramtype='01')
	insert into t_sys_parameter(PARAMTYPE, PARAMNAME, PARAVAL, PARADESC) values('01', 'BroadcastActionCode', '5,6', '高音广播控制动作码.一般为开始动作码 + 逗号 + 停止动作码')

if not exists (select 1 from t_sys_parameter where paramname = 'BroadcastIsOpenMic' and paramtype='01')
	insert into t_sys_parameter(PARAMTYPE, PARAMNAME, PARAVAL, PARADESC) values('01', 'BroadcastIsOpenMic', '0', '高音广播是否打开双向语音')