--------------------------------------------------------------------------
-- 将所有用户帐号的数据类型统一为自定义数据类型
--------------------------------------------------------------------------
if exists (select 1 from INFORMATION_SCHEMA.KEY_COLUMN_USAGE  
	where table_name = 't_user_device_role' and constraint_name = 'FK_T_USER_D_REFERENCE_T_ORG_US')
begin
	alter table t_user_device_role drop constraint FK_T_USER_D_REFERENCE_T_ORG_US
end
go

if exists (select 1 from INFORMATION_SCHEMA.KEY_COLUMN_USAGE  
	where table_name = 't_userrole_map' and constraint_name = 'FK_T_USERRO_REFERENCE_T_ORG_US')
begin
	alter table t_userrole_map drop constraint FK_T_USERRO_REFERENCE_T_ORG_US
end
go

/* 删除不必要的索引 idx_online_user_account*/
if exists (select 1 from sysindexes where name = 'idx_online_user_account')
   exec('DROP INDEX ' + 't_online_user.idx_online_user_account')
go

/* 删除不必要的索引 idx_t_online_user_account */
if exists (select 1 from INFORMATION_SCHEMA.KEY_COLUMN_USAGE  
   where table_name = 't_online_user' and constraint_name = 'idx_t_online_user_account')
begin
    alter table t_online_user drop constraint idx_t_online_user_account
end
go
exec spt_modify_column_type 't_online_user','user_account','user_account not null' 
go

exec spt_modify_column_type 'T_ORG_USER','USERACCOUNT','user_account not null'
exec spt_modify_column_type 'T_USERROLE_MAP','USERACCOUNT','user_account not null'
exec spt_modify_column_type 't_ca_user','user_account','user_account'
go

update t_photo set user_account = '' where user_account is null
go
exec spt_modify_column_type 't_photo','user_account','user_account null'
go

exec spt_modify_column_type 't_session','user_account','user_account'
exec spt_modify_column_type 't_turn_plan_set','USERACCOUNT','user_account'
exec spt_modify_column_type 't_user_device_role','USERACCOUNT','user_account not null'
exec spt_modify_column_type 'vc_video_conference_attendee','USERACCOUNT','user_account not null'
exec spt_modify_column_type 'vc_video_conference_user','USERACCOUNT','user_account not null'
exec spt_modify_column_type 't_login_log','user_name','user_account'
go

