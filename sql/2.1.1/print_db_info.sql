---------------------------------------------------------------------------------------------------
-- 在系统参数表中记录数据库版本
---------------------------------------------------------------------------------------------------
declare @db_version varchar(20)
set @db_version = '2.1.5.0'

if exists (select 1 from t_sys_parameter where paramname = 'database_version' and paramtype='00')
	update t_sys_parameter set paraval = @db_version where paramname = 'database_version' and paramtype='00'
else	
	insert into t_sys_parameter (paramtype,paramname,paradesc,paraval) values ('00','database_version','Database Version',@db_version)	
go

if exists (select 1 from t_sys_parameter where paramname = 'database_update_date' and paramtype='00')
	update t_sys_parameter set paraval = getdate() where paramname = 'database_update_date' and paramtype='00'
else	
	insert into t_sys_parameter (paramtype,paramname,paradesc,paraval) values ('00','database_update_date','Database Update Date',getdate())	
go

declare @db_version_current varchar(20)
declare @update_date varchar(40)
select @db_version_current = paraval from t_sys_parameter where paramname = 'database_version' and paramtype='00'
select @update_date = paraval from t_sys_parameter where paramname = 'database_update_date' and paramtype='00'

print ''
print 'Database Current Version: ' + @db_version_current
print 'database Update Date: ' + @update_date
go

