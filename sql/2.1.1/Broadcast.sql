if not exists (select 1 from t_sys_parameter where paramname = 'BroadcastActionCode' and paramtype='01')
	insert into t_sys_parameter(PARAMTYPE, PARAMNAME, PARAVAL, PARADESC) values('01', 'BroadcastActionCode', '5,6', '�����㲥���ƶ�����.һ��Ϊ��ʼ������ + ���� + ֹͣ������')

if not exists (select 1 from t_sys_parameter where paramname = 'BroadcastIsOpenMic' and paramtype='01')
	insert into t_sys_parameter(PARAMTYPE, PARAMNAME, PARAVAL, PARADESC) values('01', 'BroadcastIsOpenMic', '0', '�����㲥�Ƿ��˫������')