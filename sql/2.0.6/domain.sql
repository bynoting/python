/*==============================================================*/
/* Domain: gt_service_type                                      */
/*==============================================================*/
if not exists (select 1 from sysobjects where id=object_id('R_gt_service_type') and type='R')
begin
   execute ('create rule R_gt_service_type as @column is null or (@column in (0,1,2,3,4,5,6,7,8,9,10,11))')
end
go

if not exists(select 1 from systypes where name='gt_service_type')
begin
   execute sp_addtype gt_service_type, 'int'
end
go

execute sp_bindrule N'[dbo].[R_gt_service_type]', N'gt_service_type'
execute sp_bindefault N'[dbo].[zero_or_false]', N'gt_service_type'
go

/*==============================================================*/
/* Domain: ip                                                   */
/*==============================================================*/
if not exists(select 1 from systypes where name='ip')
begin    
    execute sp_addtype ip, 'nvarchar(15)' , 'not null'
end
go

/*==============================================================*/
/* Domain: bool                                                 */
/*==============================================================*/
if not exists(select 1 from systypes where name='bool')
begin    
    execute sp_addtype bool, 'int'
end
go

/*==============================================================*/
/* Domain: video_server_sn                                      */
/*==============================================================*/
if not exists(select 1 from systypes where name='video_server_sn')
begin    
    execute sp_addtype video_server_sn, 'char(16)' , 'not null'
end
go

EXECUTE sp_bindefault N'[dbo].[null_string]', N'[video_server_sn]'
go

/*==============================================================*/
/* Domain: guid                                                 */
/*==============================================================*/
if not exists(select 1 from systypes where name='guid')
begin    
    execute sp_addtype guid, 'uniqueidentifier' , 'not null'
end
go
execute sp_bindefault N'dbo.guid', N'guid'
go

/*==============================================================*/
/* Domain: device_type_code                                     */
/*==============================================================*/
if not exists(select 1 from systypes where name='device_type_code')
begin    
    execute sp_addtype device_type_code, 'int' , 'not null'
end
go

/*==============================================================*/
/* Domain: user_account                                         */
/*==============================================================*/
if not exists(select 1 from systypes where name='user_account')
begin    
    execute sp_addtype user_account, 'nvarchar(36)' , 'null'
end
go

/*==============================================================*/
/* Domain: data_create_time                                     */
/*==============================================================*/
if not exists(select 1 from systypes where name='data_create_time')
begin
    execute sp_addtype data_create_time, 'datetime' , 'null'
end
go

execute sp_bindefault N'dbo.now', N'data_create_time'
go

/*==============================================================*/
/*  guid_string                                                */
/*==============================================================*/
if not exists (select * from dbo.systypes where name = N'guid_string')
begin
    EXEC sp_addtype N'guid_string', N'nvarchar (36)', N'not null'
end
GO

/*==============================================================*/
/*  added by zhangtao 20071031                                  */
/*==============================================================*/

/*==============================================================*/
/* Domain: record_type                                          */
/*==============================================================*/
if not exists (select 1 from sysobjects where id=object_id('R_record_type') and type='R')
begin
    execute ('create rule R_record_type as @column in (0,1,2)')
end
go

if not exists(select 1 from systypes where name='record_type')
begin
    execute sp_addtype record_type, 'int' , 'not null'
end
go

execute sp_bindrule R_record_type, record_type
execute sp_bindefault N'dbo.zero_or_false', N'record_type'
go

/*==============================================================*/
/* Domain: plan_task_type                                       */
/*==============================================================*/
if not exists (select 1 from sysobjects where id=object_id('R_plan_task_type') and type='R')
begin
    execute ('create rule R_plan_task_type as @column in (0,1,2,3,4)')
end
go

if not exists(select 1 from systypes where name='plan_task_type')
begin
    execute sp_addtype plan_task_type, 'int' , 'not null'
end
go

execute sp_bindrule R_plan_task_type, plan_task_type
go

/*==============================================================*/
/* Domain: task_state   20080220                           */ 
/*==============================================================*/
if not exists (select 1 from sysobjects where id=object_id('R_task_state') and type='R')
begin
  execute ('create rule R_task_state as @column is null or (@column in (0,1,2,3,4,5,6))')
end
go

if not exists(select 1 from systypes where name='task_state')
begin
  execute sp_addtype task_state, 'int'
end
go

execute sp_bindrule R_task_state, task_state
go

execute sp_bindefault zero_or_false, 'task_state'
go

/*==============================================================*/
/* Domain: plan_type       20080221                            */
/*==============================================================*/
if not exists (select 1 from sysobjects where id=object_id('R_plan_type') and type='R')
begin
   execute ('create rule R_plan_type as @column is null or (@column in (0,1,2))')
end

if not exists(select 1 from systypes where name='plan_type')
begin
	execute sp_addtype plan_type, 'int'
end
go

execute sp_bindrule R_plan_type, plan_type
go

execute sp_bindefault zero_or_false, 'plan_type'
go

/*==============================================================*/
/* Domain: record_biz_type 20080225                             */
/*==============================================================*/
if not exists (select 1 from sysobjects where id=object_id('R_record_biz_type') and type='R')
begin
	exec ('create rule R_record_biz_type as @column is null or (@column in (0,1,2))')
end
go

if not exists(select 1 from systypes where name='record_biz_type')
begin
	execute sp_addtype record_biz_type, 'int'
end
go

execute sp_bindrule R_record_biz_type, record_biz_type
go

execute sp_bindefault zero_or_false, 'record_biz_type'
go


/*==============================================================*/
/* Domain: url                                                  */
/*==============================================================*/
if not exists(select 1 from systypes where name='url')
begin
   execute sp_addtype url, 'nvarchar(128)' , 'not null'
end
go

execute sp_bindefault null_string, 'url'
go


/*==============================================================*/
/* Domain: chinese_name                                                  */
/*==============================================================*/
if not exists (select * from dbo.systypes where name = N'chinese_name')
begin
  EXEC sp_addtype N'chinese_name', N'nvarchar (24)', N'not null'
end  
GO

EXEC sp_bindefault N'[dbo].[null_string]', N'[chinese_name]'
GO
