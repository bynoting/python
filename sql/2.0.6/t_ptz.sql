---------------------------------------------------------------------------------
-- 修改t_ptz表control_protocol字段名称为serial_link_type
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
		exec sp_addextendedproperty N'MS_Description', N'串口连接类型.0:连接矩阵 1:连接视频服务器', N'user', N'dbo', N'table', N't_ptz', N'column', N'serial_link_type' 
	    end

    end
go

update t_ptz set serial_link_type = link_type where serial_link_type is null
go
