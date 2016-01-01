---------------------------------------------------------------------------------
-- �޸�t_ptz��control_protocol�ֶ�����Ϊserial_link_type
---------------------------------------------------------------------------------
if not exists( select 1 from dbo.syscolumns s where name ='serial_link_type' and id = object_id(N't_ptz'))
    begin	
	if exists( select 1 from dbo.syscolumns s where name ='control_protocol' and id = object_id(N't_ptz'))
	    begin
		exec sp_rename 't_ptz.control_protocol','serial_link_type','column'
	    end
	else
	    begin
		alter table t_ptz add serial_link_type int 
		exec sp_addextendedproperty N'MS_Description', N'������������.0:���Ӿ��� 1:������Ƶ������', N'user', N'dbo', N'table', N't_ptz', N'column', N'serial_link_type' 
	    end

    end
go

update t_ptz set serial_link_type = link_type where serial_link_type is null
go
