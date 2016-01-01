/*==============================================================*/
/* Domain: gt_service_type                                      */
/*==============================================================*/
if not exists(select 1 from systypes where name='remark')
begin
   execute sp_addtype remark, 'nvarchar (255)'
end
go

execute sp_bindefault N'[dbo].[null_string]', N'remark'
go
