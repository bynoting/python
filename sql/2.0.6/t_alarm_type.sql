-----------------------------------------------------------------------------------------
-- ����һ�ֱ������ͣ� �Ž�����
-----------------------------------------------------------------------------------------
delete t_alarm_type where code = 8
go

insert into t_alarm_type (name_cn,name,code,has_channel) values ('�Ž�����','�Ž�����',8,1)
go

delete t_alarm_type where code = 9
go

insert into t_alarm_type (name_cn,name,code,has_channel) values ('��������','��������',9,1)
go