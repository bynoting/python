if not exists (select 1 from t_sys_parameter where paramname = 'IsSwitchDevicePower' and paramtype='01')
	insert into t_sys_parameter(PARAMTYPE, PARAMNAME, PARAVAL, PARADESC) values('01', 'IsSwitchDevicePower', '1', '是否显示开关机控制按钮.1:是 0:否')