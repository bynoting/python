if not exists (select 1 from  sysobjects where type = 'D' and name = 'guid')
begin
    execute ('create default guid as newid()')
end    
go


if not exists (select 1 from  sysobjects where type = 'D' and name = 'now')
    begin
	execute ('create default now as getdate()')
    end
go

if not exists (select 1 from  sysobjects where type = 'D' and name = 'zero_or_false')
    begin
	execute ('create default zero_or_false as 0')
    end
go

if not exists (select 1 from  sysobjects where type = 'D' and name = 'one_or_true')
    begin
	execute ('create default one_or_true as 1')
    end
go

if not exists (select 1 from  sysobjects where type = 'D' and name = 'null_string')
    begin
	execute ('create default null_string as ''''')
    end
go

if not exists (select 1 from  sysobjects where type = 'D' and name = 'two')
    begin
	execute ('create default two as 2')
    end
go

if not exists (select 1 from  sysobjects where type = 'D' and name = 'three')
    begin
	execute ('create default three as 3')
    end
go

if not exists (select 1 from  sysobjects where type = 'D' and name = 'four')
    begin
	execute ('create default four as 4')
    end
go

if not exists (select 1 from  sysobjects where type = 'D' and name = 'five')
    begin
	execute ('create default five as 5')
    end
go


/*==============================================================*/
/* Default: "system_user"                                       */
/*==============================================================*/
if not exists (select 1 from  sysobjects where type = 'D' and name = 'system_account' and user_name(uid) = 'dbo' )
begin
  execute ('create default system_account as ''_sys_''')
end   
go


